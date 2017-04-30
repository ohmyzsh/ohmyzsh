#!/usr/bin/env zsh

prompt_borior_help () {
  cat <<'EOF'
This prompt is color-scheme-able.  You can invoke it thus:

  prompt borior [<wdcolor> [<promptcolor> [<rootcolor> [<rpromptcolor> [<hilightcolor>]]]]]

EOF
}

precmd  () { 
  case ${TERM} in
    *xterm*|rxvt*|ansi)
      # Set term title to "user@host:cwd"
      print -Pn "\e]0;${PR_TITLEBAR:q}\a"
    ;;
    screen*)
      # Set screen title to "cwd"
      print -Pn "\ek${PR_CWD:q}\e\\"
    ;;
  esac
  
  [[ -z "${OLD_RPROMPT}" ]] && OLD_RPROMPT=$RPROMPT
  
  GIT_BRANCH="$(git branch --no-color 2>/dev/null | noglob grep "\*" | cut -d" " -f2-)"
  if [[ -n "${GIT_BRANCH}" ]]; then
    RPROMPT="%{$fg_bold[red]%}${GIT_BRANCH} %{$reset_color%}${OLD_RPROMPT}"
  else
    RPROMPT="${OLD_RPROMPT}"
  fi
}

preexec () { 
  case ${TERM} in
    xterm*|rxvt*)
      # Set term title to "[cmdname] user@host:cwd"
      print -Pn "\e]0;[${1:q}] - ${PR_TITLEBAR:q} \a" 
    ;;
    screen*)
      # Set screen title to "[cmdname]"
      print -Pn "\ek[${1:q}]\e\\"
    ;;
  esac
}

prompt_borior_setup () {
  setopt prompt_subst localoptions

  # Setup helpers for color
  autoload colors zsh/terminfo

  colors

  typeset -A prompt_borior 
  typeset -A prompt_borior_colours
  
  local colour_wd=${1:-"blue"}
  local colour_prompt=${2:-"green"}
  local colour_root=${3:-"red"}
  local colour_rprompt=${4:-"grey"}
  local colour_hilight=${5:-"yellow"}

  prompt_borior_colours[wd]="%{$fg_bold[$colour_wd]%}"
  prompt_borior_colours[prompt]="%{%(!.$fg_bold[$colour_root].$fg_bold[$colour_prompt])%}"
  prompt_borior_colours[rprompt]="%{$fg_bold[$colour_rprompt]%}"
  prompt_borior_colours[hilight]="%{$fg_bold[$colour_hilight]%}"
  prompt_borior_colours[reset]="%{$reset_color%}"

  for k in ${(k)prompt_borior_colours}; do
    local "pbc_$k"=$prompt_borior_colours[$k]
  done

  prompt_borior[cwd]="%25<...<%~%<<"
  prompt_borior[exit_code]="%(?.%?.$pbc_hilight%?)"

  for k in ${(k)prompt_borior}; do
     local "pb_$k"=$prompt_borior[$k]
   done

  prompt_borior[PS1]="$pbc_wd$pb_cwd $pbc_prompt%(!.#.»)$pbc_reset "
  prompt_borior[PS2]="$pbc_prompt>> $pbc_user%_ $pbc_prompt:$pbc_reset "
  prompt_borior[RPROMPT]="$pbc_rprompt(${pb_exit_code}${pbc_rprompt}) %T$pbc_reset"

  PR_TITLEBAR="%(!.[ROOT].) $pb_cwd"
  PR_CWD=$prompt_borior[cwd]

  PS1=$prompt_borior[PS1]
  PS2=$prompt_borior[PS2]
  RPROMPT=$prompt_borior[RPROMPT]

}

prompt_borior_setup "$@"
