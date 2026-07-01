# VcXsrv plugin

This plugin add the environment variables to allow graphic apps running on WSL
to find the VcXsrv instance intalled on Windows. It assumes that you have let 
the VcXsrv configured with your local machine.

To use it, add `vcxsrv` to the plugins array in your zshrc file:

```zsh
plugins=(... vcxsrv)
```

## Requirements

In order to make this work, you will need to have the folowing softwares 
installed:
* [WSL2](https://docs.microsoft.com/en-us/windows/wsl/);
* [VxXsrv](https://sourceforge.net/projects/vcxsrv/).

 VcXsrv installed on Windows.

More info on the usage and install: https://github.com/direnv/direnv
