# vagrant-prompt

This plugin prompts the status of the Vagrant VMs. It supports single-host and
multi-host configurations as well.

To use it, add `vagrant-prompt` to the plugins array in your zshrc file:

```zsh
plugins=(... vagrant-prompt)
```

**Alberto Re <alberto.re@gmail.com>**

## Usage

To display Vagrant info on your prompt add the `vagrant_prompt_info` to the
`$PROMPT` or `$RPROMPT` variable in your theme. Example:

```zsh
PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $(vagrant_prompt_info)$(svn_prompt_info)$(git_prompt_info)%(!.#.$) '
```

`vagrant_prompt_info` makes use of some custom variables. This is an example
definition:

```zsh
ZSH_THEME_VAGRANT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
ZSH_THEME_VAGRANT_PROMPT_SUFFIX="%{$fg_bold[blue]%}]%{$reset_color%} "
ZSH_THEME_VAGRANT_PROMPT_RUNNING="%{$fg_no_bold[green]%}●"
ZSH_THEME_VAGRANT_PROMPT_POWEROFF="%{$fg_no_bold[red]%}●"
ZSH_THEME_VAGRANT_PROMPT_SUSPENDED="%{$fg_no_bold[yellow]%}●"
ZSH_THEME_VAGRANT_PROMPT_NOT_CREATED="%{$fg_no_bold[white]%}○"
```
