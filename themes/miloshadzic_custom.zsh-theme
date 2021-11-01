BOLD=$(tput bold)

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX=" %{$reset_color%}%{$FG[075]%}↑"
ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX=" %{$reset_color%}%{$FG[131]%}↓"
ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$reset_color%}%{$FG[027]%}%{$BOLD%}+"
ZSH_THEME_GIT_PROMPT_ADDED="%{$reset_color%}%{$FG[034]%}%{$BOLD%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$reset_color%}%{$FG[178]%}%{$BOLD%}±"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$reset_color%}%{$FG[164]%}%{$BOLD%}●"
ZSH_THEME_GIT_PROMPT_DELETED="%{$reset_color%}%{$FG[196]%}%{$BOLD%}-"
ZSH_THEME_GIT_PROMPT_STASHED="%{$reset_color%}%{$FG[007]%}%{$BOLD%}●"

ZSH_THEME_GIT_PROMPT_UNMERGED="%{$reset_color%}%{$FG[057]%}%{$BOLD%}⚔︎"

ZSH_THEME_AWS_VAULT_PROMPT_SET="%{$reset_color%}%{$FG[178]%}%{$BOLD%}"

DELIMETER="$FG[129]%} ► %{$reset_color%}"

function theme_branch() {
  branch=$(git_current_branch)
  n=$(echo $branch | md5sum | cut -c1-5)
  color=$(( (0x${n} % 131) + 100 ))
	echo "%{$reset_color%}%{$FG[$color]%}$branch"	
}

function theme_git_prompt() {
	local ORIG STATUS
	ORIG="$(theme_git_status_promp)"
	STATUS=""
	if [[ -n "$ORIG" ]]; then
  	STATUS="%{$DELIMETER%}$ORIG"
	fi
	echo $STATUS
}

function aws_vault_prompt() {
   [[ ! -z "${AWS_VAULT+x}" ]] && echo "$DELIMETER$ZSH_THEME_AWS_VAULT_PROMPT_SET$AWS_VAULT"
}

function theme_git_status_promp() {
	local INDEX STATUS
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""

  #UNMERGED
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$(echo $INDEX | grep -E '^UU ' | wc -l | tr -d '[:space:]') $STATUS"
  fi

  #RENAMED
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$(echo $INDEX | grep -E '^R  ' | wc -l | tr -d '[:space:]') $STATUS"
  fi

  #DELETED
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$(echo $INDEX | grep -E '^ D ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$(echo $INDEX | grep -E '^D  ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$(echo $INDEX | grep -E '^AD ' | wc -l | tr -d '[:space:]') $STATUS"
  fi

  #MODIFIED
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$(echo $INDEX | grep -E '^ M ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$(echo $INDEX | grep -E '^AM ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$(echo $INDEX | grep -E '^MM ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$(echo $INDEX | grep -E '^ T ' | wc -l | tr -d '[:space:]') $STATUS"
  fi

  #ADDED
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$(echo $INDEX | grep -E '^A  ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$(echo $INDEX | grep -E '^M  ' | wc -l | tr -d '[:space:]') $STATUS"
  elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$(echo $INDEX | grep -E '^MM ' | wc -l | tr -d '[:space:]') $STATUS"
  fi

  #UNTRACKED
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$(echo $INDEX | grep -E '^\?\? ' | wc -l | tr -d '[:space:]') $STATUS"
  fi

  echo $STATUS
}

FIRST_PARTITION='%1~'

function firstPartition() {
  echo "${XTITLE:-$FIRST_PARTITION}"
}

PROMPT='%{$fg[cyan]%}$(firstPartition)%{$reset_color%}%{$DELIMETER%}$(theme_branch)$(git_commits_behind)$(git_commits_ahead)$(theme_git_prompt)$(aws_vault_prompt)%{$FG[129]%}%{$BOLD%}⇒%{$reset_color%} '
