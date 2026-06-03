-- clipboard.lua for neovim
-- Linux: ~/.config/nvim/lua/config/clipboard.lua
-- Windows: %LOCALAPPDATA%\nvim\lua\config\clipboard.lua
-- mgua@tomware.it 2026
--
-- Robust clipboard setup: decides how the "+ register reaches the OS
-- clipboard, then verifies after startup that a working provider exists.
-- If copy&paste cannot work, a notification explains exactly how to fix it.
-- Run :ClipboardStatus at any time for a full diagnosis.
--
-- Strategies (in order of detection):
--   windows  native clipboard, always available
--   tmux     nvim's builtin tmux provider (tmux load-buffer -w) forwards
--            copies to the outer terminal via OSC52, as long as the tmux
--            option set-clipboard is "on" or "external" (the default)
--   osc52    remote/headless session: copy goes to the LOCAL terminal
--            clipboard via OSC52 escape sequence. Copy-only: paste of the
--            OS clipboard into nvim must use the terminal's own paste
--            shortcut (Shift+Insert / Ctrl+Shift+V), arriving as a
--            bracketed paste. Triggered by SSH_* env vars OR by the absence
--            of any X/Wayland display (covers "ssh, then sudo su -" which
--            strips the SSH_* variables).
--   local    desktop Linux with a display: native provider via
--            xclip / xsel (X11) or wl-copy (Wayland)

local M = {}

M.strategy = nil   -- one of: windows, tmux, osc52, local

vim.opt.clipboard = "unnamedplus"

if vim.fn.has('win32') == 1 then
  M.strategy = 'windows'
elseif vim.env.TMUX then
  M.strategy = 'tmux'
  vim.opt.ttimeoutlen = 0   -- fast escape inside tmux
elseif vim.env.SSH_CLIENT or vim.env.SSH_TTY or vim.env.SSH_CONNECTION
    or (not vim.env.DISPLAY and not vim.env.WAYLAND_DISPLAY) then
  M.strategy = 'osc52'
  -- OSC52 for copy (write to local terminal clipboard).
  -- Paste is served from nvim's internal register — no terminal read query —
  -- because OSC52 read is disabled by default in most terminals and would
  -- otherwise hang every paste for the full read timeout (~10 s).
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste_from_unnamed()
    return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
  end
  vim.g.clipboard = {
    name = "osc52-copy-only",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = paste_from_unnamed,
      ["*"] = paste_from_unnamed,
    },
  }
else
  M.strategy = 'local'
  -- no vim.g.clipboard override; native provider (xclip/xsel/wl-copy) is
  -- fast with no terminal roundtrip
end

-- ===========================================================================
-- Diagnosis: explain the current state and, when broken, how to fix it
-- ===========================================================================

-- returns: lines (table of strings), broken (boolean)
function M.diagnose()
  local lines = {}
  local broken = false
  local exec = vim.fn['provider#clipboard#Executable']()

  table.insert(lines, "Clipboard strategy: " .. M.strategy
    .. "  (provider: " .. (exec ~= "" and exec or "NONE") .. ")")

  if M.strategy == 'windows' then
    table.insert(lines, "Native Windows clipboard. Copy and paste both work.")

  elseif M.strategy == 'tmux' then
    table.insert(lines, "Copies go into a tmux buffer; tmux relays them to the terminal clipboard via OSC52.")
    local setclip = vim.fn.system({ "tmux", "show", "-gv", "set-clipboard" })
    if vim.v.shell_error == 0 and setclip:match("off") then
      broken = true
      table.insert(lines, "PROBLEM: tmux option 'set-clipboard' is OFF, so copies never leave tmux.")
      table.insert(lines, "FIX: add to ~/.tmux.conf:    set -s set-clipboard external")
      table.insert(lines, "     then run: tmux source-file ~/.tmux.conf")
    end
    table.insert(lines, "Your terminal must support OSC52 (Windows Terminal, kitty, iTerm2, alacritty, recent xterm do).")

  elseif M.strategy == 'osc52' then
    table.insert(lines, "Remote/headless session: copy is sent to your LOCAL machine's clipboard via OSC52.")
    table.insert(lines, "Your terminal must support OSC52 (Windows Terminal, kitty, iTerm2, alacritty, recent xterm do).")
    table.insert(lines, "Pasting the OS clipboard INTO nvim: use the terminal's paste shortcut (Shift+Insert / Ctrl+Shift+V),")
    table.insert(lines, "not nvim's p — nvim's paste only sees what was copied inside nvim itself.")

  else -- local
    if exec == "" then
      broken = true
      local err = vim.fn['provider#clipboard#Error']()
      table.insert(lines, "PROBLEM: no clipboard tool found (" .. err .. ").")
      table.insert(lines, "Copy&paste with the OS clipboard will NOT work until one is installed:")
      table.insert(lines, "FIX (X11):     sudo apt install xclip")
      table.insert(lines, "FIX (Wayland): sudo apt install wl-clipboard")
      table.insert(lines, "Then restart nvim. (Over SSH this is not needed: OSC52 is used instead.)")
    else
      table.insert(lines, "Desktop session: native clipboard via " .. exec .. ". Copy and paste both work.")
    end
  end

  -- catch-all: provider resolution failed in a way not covered above
  if exec == "" and not broken then
    broken = true
    table.insert(lines, "PROBLEM: " .. vim.fn['provider#clipboard#Error']())
    table.insert(lines, "See :h clipboard for provider requirements.")
  end

  return lines, broken
end

vim.api.nvim_create_user_command("ClipboardStatus", function()
  local lines, broken = M.diagnose()
  vim.notify(table.concat(lines, "\n"),
    broken and vim.log.levels.WARN or vim.log.levels.INFO)
end, { desc = "Diagnose clipboard setup and show fixes if broken" })

-- after startup, warn (once) only if the clipboard is actually broken
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      local lines, broken = M.diagnose()
      if broken then
        table.insert(lines, "(run :ClipboardStatus to see this again)")
        vim.notify(table.concat(lines, "\n"), vim.log.levels.WARN)
      end
    end, 500)
  end,
})

return M
