-- https://github.com/folke/flash.nvim
-- fast lets you navigate your code with search labels, enhanced chaeacter motions, and Treesitter integration.
-- see also https://www.youtube.com/watch?v=f-G6kc1dzm
--
--  in normal mode use press "s" and search sequence then you visually see markers after found sequences, pressing which you jump there
--  it searches across windows
--

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" },  function() require("flash").jump() end,                     desc = "Flash" },
    { "S", mode = { "n", "x", "o" },  function() require("flash").treesitter() end,               desc = "Flash Treesitter" },
    { "r", mode = "o",                function() require("flash").remote() end,                   desc = "Remote Flash" },
    { "R", mode = { "o", "x" },       function() require("flash").treesitter_search() end,        desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },        function() require("flash").toggle() end,                   desc = "Toggle Flash Search" },
  },
}
