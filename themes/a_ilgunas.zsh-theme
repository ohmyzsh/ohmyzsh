# a_ilgunas prompt theme
#
# Completeley hijacked the adam2 theme
#
# ... and you thought adam2 was overkill.

p_setup () {
  # Some can't be local
  local p_gfx_tlc p_gfx_mlc p_gfx_blc

  # Are we a root account?
  AM_ROOT="true"

  # Are we using a terminal that supports UTF-8 characters?
  if [[ ${LC_ALL:-${LC_CTYPE:-$LANG}} = *UTF-8* ]]; then
      UTF_TERM="true"
  else
      UTF_TERM="false"
  fi

  if [[ $1 == '8bit' ]]; then
    shift
    if [[ $UTF_TERM == "true" ]]; then
      p_gfx_tlc=$'\xe2\x94\x8c'
      p_gfx_mlc=$'\xe2\x94\x9c'
      p_gfx_blc=$'\xe2\x94\x94'
      p_gfx_hyphen=$'\xe2\x94\x80'
    else
      p_gfx_tlc=$'\xda'
      p_gfx_mlc=$'\xc3'
      p_gfx_blc=$'\xc0'
      p_gfx_hyphen=$'\xc4'
    fi
  else
    if [[ $UTF_TERM == "true" ]]; then
      p_gfx_tlc='┌'
    else
      p_gfx_tlc='.'
    fi
    p_gfx_mlc='|'
    if [[ $UTF_TERM == "true" ]]; then
      p_gfx_blc='└'
    else
      p_gfx_blc='\`';
    fi
    p_gfx_hyphen='-'
  fi

  # Color scheme
   if [ "$AM_ROOT" = "true" ]; then
      c_hyp=${1:-'red'}     # hyphens
      c_cwd=${2:-'cyan'}    # current directory
      c_usr=${3:-'cyan'}    # user@host
      c_input=${4:-'green'} # user input
      c_time=${5:-'yellow'} # time
      c_prompt=${6:-'red'}  # prompt
   else
      c_hyp=${1:-'cyan'}    # hyphens
      c_cwd=${2:-'cyan'}    # current directory
      c_usr=${3:-'cyan'}    # user@host
      c_input=${4:-'green'} # user input
      c_time=${5:-'yellow'} # time
      c_prompt=${6:-'cyan'} # prompt
   fi

   # Format the svn prompts
   if [[ $UTF_TERM == "true" ]]; then
      ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
      ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%}✓%{$reset_color%}"
   else
      ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[yellow]%}X%{$reset_color%}"
      ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%}O%{$reset_color%}"
   fi

   # Format the git prompts
   if [[ $UTF_TERM == "true" ]]; then
      ZSH_THEME_GIT_PROMPT_PREFIX=" git:(%{$fg[red]%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%})%{$fg[yellow]%}✗%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%})%{$fg[green]%}✓%{$reset_color%}"
   else
      ZSH_THEME_GIT_PROMPT_PREFIX=" git:(%{$fg[red]%}%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%})%{$fg[yellow]%}X%{$reset_color%}"
      ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%})%{$fg[green]%}O%{$reset_color%}"
   fi

  local p_gfx_bbox

  # Not really sure what this is for, but keeping it anyway.
  p_gfx_tbox="%F{$c_hyp}${p_gfx_tlc}%F{$c_hyp}${p_gfx_hyphen}"
  p_gfx_bbox="%F{$c_hyp}${p_gfx_blc}${p_gfx_hyphen}%F{$c_hyp}"

  # This is a cute hack.  Well Adam likes it, anyway.
  p_gfx_bbox_to_mbox=$'%{\e[A\r'"%}%F{$c_hyp}${p_gfx_mlc}%F{$c_hyp}${p_gfx_hyphen}%{"$'\e[}'

  # Format the left and right parenthesis
  p_l_paren="%B%F{black}[%b"
  p_r_paren="%B%F{black}]%b"

  # Format the user@hostname
  p_user_host="%b%F{$c_usr}%n%B%F{$c_usr}@%b%F{$c_usr}%m"

  # Format the time
  p_time="$p_l_paren%B%F{$c_time}%T%b$p_r_paren";

  # The svn prompt
  p_svn='$(svn_prompt_info)'

  # The git prompt
  p_git='$(git_prompt_info)'

  p_line_1a="$p_gfx_tbox$p_l_paren%F{$c_cwd}%~$p_r_paren%F{$c_hyp}"
  p_line_1b="$p_l_paren$p_user_host$p_r_paren$p_time%F{$c_hyp}${p_gfx_hyphen}"

  p_line_2="$p_gfx_bbox${p_gfx_hyphen}%F{white}${p_svn}${p_git}"

  # Format the prompt characters (dunno.root prompt.unprivileged user prompt)
  if [[ $UTF_TERM == "true" ]]; then
   p_char="%(!.➤.➤)"
  else
   p_char="%(!.#.>)"
  fi

  p_opts=(cr subst percent)

  add-zsh-hook precmd p_precmd
}

p_precmd() {
  setopt noxtrace localoptions extendedglob
  local p_line_1

  p_choose_prompt

  PS1="$p_line_1$p_newline$p_line_2 %F{$c_prompt}$p_char %f%k"
  PS2="$p_line_2$p_gfx_bbox_to_mbox%F{$c_prompt}%_> %f%k"
  PS3="$p_line_2$p_gfx_bbox_to_mbox%F{$c_prompt}?# %f%k"
  zle_highlight[(r)default:*]="default:fg=$c_input"

}

p_choose_prompt () {
  local p_line_1a_width=${#${(S%%)p_line_1a//(\%([KF1]|)\{*\}|\%[Bbkf])}}
  local p_line_1b_width=${#${(S%%)p_line_1b//(\%([KF1]|)\{*\}|\%[Bbkf])}}

  local p_padding_size=$(( COLUMNS - p_line_1a_width - p_line_1b_width))

  # Try to fit in long path and user@host.
  if (( p_padding_size > 0 )); then
    local p_padding
    eval "p_padding=\${(l:${p_padding_size}::${p_gfx_hyphen}:)_empty_zz}"
    p_line_1="$p_line_1a$p_padding$p_line_1b"
    return
  fi

  p_padding_size=$(( COLUMNS - p_line_1a_width ))

  # Didn't fit; try to fit in just long path.
  if (( p_padding_size > 0 )); then
    local p_padding
    eval "p_padding=\${(l:${p_padding_size}::${p_gfx_hyphen}:)_empty_zz}"
    p_line_1="$p_line_1a$p_padding"
    return
  fi

  # Still didn't fit; truncate
  local p_pwd_size=$(( COLUMNS - 5 ))
  p_line_1="$p_gfx_tbox$p_l_paren%F{$c_cwd}%$p_pwd_size<...<%~%<<$p_r_paren%F{$c_hyp}$p_gfx_hyphen"
}

p_setup "$@"
