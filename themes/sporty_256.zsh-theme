# zsh theme requires 256 color enabled terminal
# i.e TERM=xterm-256color
<<<<<<< HEAD
# Preview - http://www.flickr.com/photos/adelcampo/4556482563/sizes/o/
=======
# Preview - https://www.flickr.com/photos/adelcampo/4556482563/sizes/o/
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
# based on robbyrussell's shell but louder!

PROMPT='%{$fg_bold[blue]%}$(git_prompt_info) %F{208}%c%f
%{$fg_bold[white]%}%# %{$reset_color%}'
RPROMPT='%B%F{208}%n%f%{$fg_bold[white]%}@%F{039}%m%f%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{154}±|%f%F{124}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}%B✘%b%F{154}|%f%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%F{154}|"
