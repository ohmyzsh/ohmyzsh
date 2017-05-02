+vi-git-submodule-unstaged () {
  if ( cd $hook_com[base]; `git submodule status | grep -cqv "^ "` ) ; then
    hook_com[unstaged]=${hook_com[unstaged]:-"%{$FG[202]%}"}
    hook_com[unstaged]+='ɱ'
  fi
}

+vi-git-clean () {
  if [[ -z ${hook_com[staged]} ]] && [[ -z ${hook_com[unstaged]} ]] ; then
    hook_com[staged]="%{$FG[034]%}✓"
  fi
  hook_com[staged]=" ${hook_com[staged]}"
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "%{$FG[202]%}✻"
zstyle ':vcs_info:*' stagedstr "%{$FG[118]%}✚"
zstyle ':vcs_info:*' actionformats "%{$FG[064]%}±%{$FG[235]%}[%{$FG[088]%}%b%{$FG[235]%}|%{$FG[033]%}%a%c%u%{$FG[235]%}] "
zstyle ':vcs_info:*' formats "%{$FG[064]%}±%{$FG[235]%}[%{$FG[088]%}%b%c%u%{$FG[235]%}] "
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks git-submodule-unstaged git-clean

precmd () {
  vcs_info
}

PROMPT='%{$FG[088]%}◷%{$FG[006]%}%T %{$FG[024]%}%3~ $vcs_info_msg_0_%{$reset_color%}'
