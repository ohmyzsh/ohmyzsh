# aliases
alias hga='hg add'
alias hgc='hg commit'
alias hgca='hg commit --amend'
alias hgci='hg commit --interactive'
alias hgb='hg branch'
alias hgba='hg branches'
alias hgbk='hg bookmarks'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|person}: {desc|strip|firstline}\n" '
alias hgun='hg resolve --list'
# pull and update
alias hgi='hg incoming'
alias hgl='hg pull -u'
alias hglr='hg pull --rebase'
alias hgo='hg outgoing'
alias hglg='hg log --stat -v'
alias hglgp='hg log --stat  -p -v'

function hgic() {
  hg incoming "$@" | grep "changeset" | wc -l
}

function hgoc() {
  hg outgoing "$@" | grep "changeset" | wc -l
}

# functions
function hg_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.hg" ]]; then
      echo "$dir"
      return 0
    fi
    dir="${dir:h}"
  done
  return 1
}

function in_hg() {
  hg_root >/dev/null
}

function hg_get_branch_name() {
  local dir
  if ! dir=$(hg_root); then
    return
  fi

  if [[ ! -f "$dir/.hg/branch" ]]; then
    echo default
    return
  fi

  echo "$(<"$dir/.hg/branch")"
}

function hg_get_bookmark_name() {
  local dir
  if ! dir=$(hg_root); then
    return
  fi

  if [[ ! -f "$dir/.hg/bookmarks.current" ]]; then
    return
  fi

  echo "$(<"$dir/.hg/bookmarks.current")"
}

function update_hg_vars() {
  if $(hg id >/dev/null 2>&1); then
    local rev="$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')"
    local branch="$(hg id -b 2>/dev/null)"
    local hg_status=`hg st`
    HG_REV_BRANCH="${rev:gs/%/%%}%{$FG[239]%}@%{$reset_color%}${branch:gs/%/%%}"
    HG_UNKNOWN="$(echo $hg_status | grep "^\?" | wc -l)"
    HG_MODIFIED="$(echo $hg_status | grep "^\M" | wc -l)"
    HG_ADDED="$(echo $hg_status | grep "^\A" | wc -l)"
    HG_REMOVED="$(echo $hg_status | grep "^\R" | wc -l)"
    HG_DELETED="$(echo $hg_status | grep "^\!" | wc -l)"
    HG_AHEAD="$(hg log -r "draft()" | grep "summary" | wc -l)"
    # HG_BEHIND="$(hg incoming | grep "summary" | wc -l)"
  fi
}

function hg_prompt_info() {
  update_hg_vars
  if $(hg id >/dev/null 2>&1); then
    local hg_status="$ZSH_THEME_HG_PROMPT_PREFIX$ZSH_THEME_HG_PROMPT_BRANCH$HG_REV_BRANCH%{${reset_color}%}"
    if [[ "$HG_BEHIND" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_BEHIND$HG_BEHIND%{$reset_color%}"
    fi
    if [[ "$HG_AHEAD" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_AHEAD$HG_AHEAD%{$reset_color%}"
    fi
    hg_status="$hg_status$ZSH_THEME_HG_PROMPT_SEPARATOR"
    if [[ "$HG_MODIFIED" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_MODIFIED$HG_MODIFIED%{$reset_color%}"
    fi
    if [[ "$HG_ADDED" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_ADDED$HG_ADDED%{$reset_color%}"
    fi
    if [[ "$HG_REMOVED" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_REMOVED$HG_REMOVED%{$reset_color%}"
    fi
    if [[ "$HG_DELETED" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_DELETED$HG_DELETED%{$reset_color%}"
    fi
    if [[ "$HG_UNKNOWN" -ne "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_UNKNOWN$HG_UNKNOWN%{$reset_color%}"
    fi
    if [[ "$HG_MODIFIED" -eq "0" && "$HG_ADDED" -eq "0" && "$HG_REMOVED" -eq "0" && "$HG_DELETED" -eq "0" && "$HG_UNKNOWN" -eq "0" ]]; then
      hg_status="$hg_status$ZSH_THEME_HG_PROMPT_CLEAN"
    fi
    hg_status="$hg_status%{${reset_color}%}$ZSH_THEME_HG_PROMPT_SUFFIX"
    echo "$hg_status"
  fi
}

# Default values for the appearance of the prompt.
ZSH_THEME_HG_PROMPT_PREFIX="("
ZSH_THEME_HG_PROMPT_SUFFIX=")"
ZSH_THEME_HG_PROMPT_SEPARATOR="|"
ZSH_THEME_HG_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_HG_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_HG_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_HG_PROMPT_MODIFIED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_HG_PROMPT_ADDED="%{$fg[blue]%}%{✚%G%}"
ZSH_THEME_HG_PROMPT_REMOVED="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_HG_PROMPT_DELETED="%{$fg[red]%}%{🗑️%G%}"
ZSH_THEME_HG_PROMPT_UNKNOWN="%{$fg[cyan]%}%{…%G%}"
ZSH_THEME_HG_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
