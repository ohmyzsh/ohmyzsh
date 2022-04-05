#
# Based on Geoffrey Grosenbach's peepcode zsh theme from
# https://github.com/topfunky/zsh-simple
#

git_repo_path() {
<<<<<<< HEAD
  git rev-parse --git-dir 2>/dev/null
}

git_commit_id() {
  git rev-parse --short HEAD 2>/dev/null
=======
  command git rev-parse --git-dir 2>/dev/null
}

git_commit_id() {
  command git rev-parse --short HEAD 2>/dev/null
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

git_mode() {
  if [[ -e "$repo_path/BISECT_LOG" ]]; then
    echo "+bisect"
  elif [[ -e "$repo_path/MERGE_HEAD" ]]; then
    echo "+merge"
  elif [[ -e "$repo_path/rebase" || -e "$repo_path/rebase-apply" || -e "$repo_path/rebase-merge" || -e "$repo_path/../.dotest" ]]; then
    echo "+rebase"
  fi
}

git_dirty() {
<<<<<<< HEAD
  if [[ "$repo_path" != '.' && `git ls-files -m` != "" ]]; then
=======
  if [[ "$repo_path" != '.' && -n "$(command git ls-files -m)" ]]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    echo " %{$fg_bold[grey]%}✗%{$reset_color%}"
  fi
}

git_prompt() {
<<<<<<< HEAD
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
=======
  local cb=$(git_current_branch)
  if [[ -n "$cb" ]]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    local repo_path=$(git_repo_path)
    echo " %{$fg_bold[grey]%}$cb %{$fg[white]%}$(git_commit_id)%{$reset_color%}$(git_mode)$(git_dirty)"
  fi
}

<<<<<<< HEAD
local smiley="%(?,%{$fg[green]%}☺%{$reset_color%},%{$fg[red]%}☹%{$reset_color%})"

PROMPT='
%~
${smiley}  %{$reset_color%}'

RPROMPT='%{$fg[white]%} $(~/.rvm/bin/rvm-prompt)$(git_prompt)%{$reset_color%}'
=======
local smiley='%(?.%F{green}☺%f.%F{red}☹%f)'

PROMPT='
${VIRTUAL_ENV:+"($VIRTUAL_ENV) "}%~
${smiley}  '

RPROMPT='%F{white} $(ruby_prompt_info)$(git_prompt)%{$reset_color%}'

# Disable automatic virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
