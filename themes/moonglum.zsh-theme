local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})  "

function git-status() {
  if [[ `git rev-parse --git-dir 2>/dev/null` != '' ]]; then
    # We are in a git repo
    
    local gitdirty=""
    if [[ `git ls-files -m` != "" ]]; then
      # There are changes to files
      
      gitdirty="%{$fg[red]%} ✗%{$reset_color%}"
    fi
    
    echo ' @' `git symbolic-ref -q HEAD | sed 's/refs\/heads\///'` $gitdirty
  fi
}

PROMPT='${smiley}'
RPROMPT='%~$(git-status)'