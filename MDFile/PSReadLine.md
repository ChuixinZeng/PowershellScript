之前配置完VSCode和PowerShell集成后，可以使用powershell的智能感知，高亮等功能，查了一下，这个应该跟PSReadLine有关系。**PSReadLine**在PowerShell控制台中提供了改进的命令行编辑体验。

PSReadLine需要PowerShell 3.0或更高版本以及控制台主机。***它在PowerShell ISE中不起作用。它在Visual Studio Code的控制台中工作。**

https://docs.microsoft.com/zh-cn/powershell/module/psreadline/about/about_psreadline?view=powershell-6#about_psreadline

PSReadLine provides a powerful command line editing experience for the PowerShell console. It provides:

- Syntax coloring of the command line
- A visual indication of syntax errors
- A better multi-line experience (both editing and history)
- Customizable key bindings
- Cmd and Emacs modes
- Many configuration options
- Bash style completion (optional in Cmd mode, default in Emacs mode)
- Emacs yank/kill ring
- PowerShell token based "word" movement and kill