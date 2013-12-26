oh-my-zsh::plugin::nodeenv-prompt
====================================

This is a plugin derived from
[virtualenv prompt](https://github.com/tonyseek/oh-my-zsh-virtualenv-prompt).
It support to customize the
[nodeenv](https://github.com/ekalinin/nodeenv)
prompt in oh-my-zsh themes.

Customize Theme
---------------

There are two constant strings which could be overrided in your custom theme.

- `ZSH_THEME_NODEENV_PROMPT_PREFIX`
- `ZSH_THEME_NODEENV_PROMPT_SUFFIX`

And the function `nodeenv_prompt_info` could be used in the prompt of your
theme.

Example
-------
See the following theme codes for example:

    function _virtualenv_prompt_info {
            [[ -n $(whence virtualenv_prompt_info) ]] && virtualenv_prompt_info
    }

    function _nodeenv_prompt_info {
            [[ -n $(whence nodeenv_prompt_info) ]] && nodeenv_prompt_info
    }

    ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    function prompt_char {
                if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
    }

    PROMPT='%(?, ,%{$fg[red]%}FAIL%{$reset_color%}
    )
    $(_nodeenv_prompt_info)$(_virtualenv_prompt_info)%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info)
    %_ $(prompt_char) '

    RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'
