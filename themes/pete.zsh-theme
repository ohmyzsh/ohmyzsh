#!/bin/bash

PROMPT='(%w%t) [%{$fg[blue]%}%n%{$reset_color%}@%{$fg[green]%}%M%{$reset_color%}] %{$fg[yellow]%}%d%{$reset_color%}$(git_prompt_info)$(rvm_prompt_info) %(!.#.$)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_RVM_PROMPT_PREFIX=" (%{$fg_bold[green]%}"
ZSH_THEME_RVM_PROMPT_SUFFIX="%{$reset_color%})"
