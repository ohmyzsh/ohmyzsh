# thm-zshtheme

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo "$GIT_PROMPT_SYMBOL" && return
    hg root >/dev/null 2>/dev/null && echo "$MER_PROMPT_SYMBOL" && return
    svn info >/dev/null 2>/dev/null && echo "$SVN_PROMPT_SYMBOL" && return
    echo '◇'%{$reset_color%}
}

# You can set your computer name in the ~/.box-name file if you want.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
MER_PROMPT_SYMBOL="%{$FG[177]%}☿" #Mercurial
SVN_PROMPT_SYMBOL="%{$FG[170]%}∮" #SVN
GIT_PROMPT_SYMBOL="%{$FG[162]%}±" #Git
GIT_PROMPT_PREFIX="%{$fg[black]%} %{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[black]%} %{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[yellow]%}⬆%{$reset_color%} "
GIT_PROMPT_BEHIND="%{$fg[yellow]%}⬇%{$reset_color%} "
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}✭ "
GIT_PROMPT_MODIFIED="%{$fg[cyan]%}▲ "
GIT_PROMPT_ADDED="%{$fg[green]%}✚%{$reset_color%} "

# Git prompt configuration
GIT_PROMPT_DIRTY="%{$fg[red]%} ✘✘✘"
GIT_PROMPT_CLEAN="%{$fg[green]%} ✔"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
function parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_ADDED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi

}

git_dirty() {
  if [[ -n $(git status -s --ignore-submodules=dirty 2> /dev/null) ]]; then
    echo "$GIT_PROMPT_DIRTY"
  else
    echo "$GIT_PROMPT_CLEAN"
  fi
}

function git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "%{$FG[239]%}\ue0a0 %{$fg[white]%}${git_where#(refs/heads/|tags/)}$(git_dirty)$(parse_git_state)"
}

local rvm_ruby='$(rvm-prompt i v g)%{$reset_color%}'

function current_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

PROMPT='
%{$fg[green]%}╭──%{$fg[yellow]%} $(current_pwd)%{$reset_color%} $(git_prompt_string)%{$reset_color%}
%{$fg[green]%}╰────▶ %{$reset_color%}'

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "
