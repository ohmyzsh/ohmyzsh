prompt_writable() {
  if [ ! -w "$PWD" ]; then
    echo " 🔐"
  fi
}

prompt_pwd() {
  local PERSI_PWD=${PWD/#$HOME/'~'}
  if [ "${PERSI_PWD}" != "~" ]; then
    PERSI_PWD=${PERSI_PWD##*/}
  fi
  echo "${PERSI_PWD}"
}

prompt_user_identifier() {
  if [ "${USER}" = "root" ]; then
    # shellcheck disable=SC2154
    # shellcheck disable=SC1087
    echo "%{$fg[red]%} # %{$reset_color%}"
  else
    # shellcheck disable=SC2154
    # shellcheck disable=SC1087
    echo "%{$fg[black]%} $ %{$reset_color%}"
  fi
}

prompt_user() {
  id -u -n
}

prompt_hostname() {
  hostname
}

# shellcheck disable=SC2016
# shellcheck disable=SC2034
PROMPT='%{$fg[magenta]%}$(prompt_user)@$(prompt_hostname)%{$reset_color%}%{$fg_bold[blue]%}➧%{$reset_color%}%{$fg_bold[green]%}$(prompt_pwd)$(prompt_writable)%{$reset_color%}$(git_prompt_info)%{$reset_color%}$(prompt_user_identifier)%{$reset_color%}'

# shellcheck disable=SC2034
# shellcheck disable=SC1087
ZSH_THEME_GIT_PROMPT_PREFIX=" ⚡️ %{$fg[magenta]%}"
# shellcheck disable=SC2034
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# shellcheck disable=SC2034
ZSH_THEME_GIT_PROMPT_DIRTY=" 💥%{$reset_color%}"
# shellcheck disable=SC2034
# shellcheck disable=SC1087
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?%{$reset_color%}"
# shellcheck disable=SC2034
ZSH_THEME_GIT_PROMPT_CLEAN=" 💫%{$reset_color%}"

export CLICOLOR=1
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='no=00:fi=00:di=01;32:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=00;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:*.log=02;34:*.zip=01;32:'
