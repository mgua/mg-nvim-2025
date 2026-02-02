To activate AI assistance within your neovim installation:
install a local ollama engine
add coding models with ollama pull/run
(i prepared qwen and rnj)

prepare custom models with the following commands:
(an ollama custom model allows you to prepare specific parameters & prompt)
go in the folder where you have Modelfile.qwen-coder and Modelfile.rnj-coder
and run the following commands

❯ ollama create qwen-coder -f Modelfile.qwen-coder
❯ ollama create rnj-coder -f Modelfile.rnj-coder

now run ollama list to validate you have the two new custom models

- mgua
