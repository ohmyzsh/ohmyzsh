# andynu's theme.
# - svn aware
# - git aware
#   - only branch display
#   - no dirty check (too slow)
# - screen aware (displays window number)
# - displays non-zero exit codes
# - user@host:path in scp friendly format
# - $ for user, # for super.
# - mutes hostname if == $PRIMARY_HOST 
#     (serves to highlight when you have 
#     this prompt on a remote host)
# 
# Example:
# [non-zero exit code]\n
# user@host:path [(git:branch|svn:path)]
#
# Prompt Expansion Reference:
# http://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_13.html

typeset -ga chpwd_functions
typeset -ga precmd_functions
precmd_functions+='_prompt'
chpwd_functions+='_prompt'

export NC="$(tput sgr0)" # No Color
export LightRed="$(tput bold ; tput setaf 1)"
c() { 
  echo `tput setaf $1` 
}

if [[ $host = $PRIMARY_HOST ]];
then h_color=$(c 238)
else h_color=$(c 28)
fi
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git::\1)/'
}
parse_svn_branch() {
  parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print "(svn::"$1 "/" $2 ")"}'
}
parse_svn_url() {
  svn info 2>/dev/null | grep -e '^URL*' | sed -e 's#^URL: *\(.*\)#\1#g '
}
parse_svn_repository_root() {
  svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g '
}
err_prompt() {
  err=$?
  msg="error exit "
  if [ $err = 0 ];
  then echo -e "\n$NC"
  else echo -e "$(tput bold)$(c 1)$msg$err$NC\n$NC\n$NC"
  fi
}
screen_window(){
  if [ x$WINDOW != x ]; 
  then echo "$(c 231)$WINDOW$(c 245):" # in screen
  else echo "" # regular
  fi
}

PROMPT=""
RPROMPT=""

_prompt(){
    export PS1="$(err_prompt)$(screen_window)%{$(c 24)%}%n%{$NC%}%{$(c 237)%}@%{$h_color%}%m%{$(c 237)%}:%{$(c 124)%}%~ %{$(c 11)%}$(parse_git_branch)$(parse_svn_branch)%{$(c 233)%}
%{$LightRed%}%# %{$NC%}"
}
_prompt
