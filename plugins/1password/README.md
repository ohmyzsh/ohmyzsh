# 1Password

This plugin adds 1Password functionality to oh-my-zsh.

To use, add `1password` to the list of plugins in your `.zshrc` file:

`plugins=(... 1password)`

Then, you can use the command `opswd` to copy passwords for services into your
clipboard.

For example, `opswd GitHub` will put your GitHub password into your clipboard - if a
onetime password exists for the service, your clipboard will contain it after a
brief pause. Everything is cleared after few seconds.

You need to have
[1Password's command line utility](https://1password.com/downloads/command-line/)
installed as well as [`jq`](https://stedolan.github.io/jq/).
