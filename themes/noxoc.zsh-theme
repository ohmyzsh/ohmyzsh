if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_no_bold[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}"

PROMPT='
%{$fg[$NCOLOR]%}%n@%m%{$reset_color%}%{$fg[white]%}:${PWD/#$HOME/~} $(noxoc_git_prompt_info)%{$reset_color%}$(noxoc_rvm_prompt_info)%{$reset_color%}
%(!.#.$) '
RPROMPT='$(vi_mode_prompt_info)[%*]'

MODE_INDICATOR="%{$fg[green]%}⌘ %{$reset_color%}"

function noxoc_rvm_prompt_info() {
  ruby_version=$(~/.rvm/bin/rvm-prompt 2> /dev/null) || return
  echo "$ruby_version"
}

function noxoc_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(noxoc_parse_git_dirty)±[${ref#refs/heads/}@$(git_prompt_short_sha)]$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
noxoc_parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=02;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

#  vim: set ts=8 sw=2 tw=79 cc=80 ft=zsh:
