# An RDM theme called The Poncho by Ed Heltzel (http://rainydaymedia.net)
# Use with iTerm 2 - the kitkat color scheme (https://github.com/zdj/themes)
# Regular Font - 12pt Source Code Pro Non-ASCII Font - 12pt Source Code Pro Powerline
# Meant for those who use rvm, rbenv and git, mercurial, svn

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira, robbyrussell, fino, eastwood
# lots of borrowed shit

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo "$GIT_PROMPT_SYMBOL" && return
    hg root >/dev/null 2>/dev/null && echo "$MER_PROMPT_SYMBOL" && return
    svn info >/dev/null 2>/dev/null && echo "$SVN_PROMPT_SYMBOL" && return
    echo '◇'%{$reset_color%}
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# http://blog.joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
# copied from https://gist.github.com/4415470
# Adapted from code found at <https://gist.github.com/1712320>.

#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
MER_PROMPT_SYMBOL="%{$FG[177]%}☿"
SVN_PROMPT_SYMBOL="%{$FG[170]%}∮"
GIT_PROMPT_SYMBOL="%{$FG[162]%}±"
GIT_PROMPT_PREFIX="%{$FG[239]%} %{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$FG[239]%} %{$reset_color%}"
GIT_PROMPT_AHEAD="%{$FG[003]%}⬆%{$reset_color%} "
GIT_PROMPT_BEHIND="%{$FG[003]%}⬇%{$reset_color%} "
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$FG[003]%}✭ "
GIT_PROMPT_MODIFIED="%{$FG[014]%}▲ "
GIT_PROMPT_ADDED="%{$FG[002]%}✚%{$reset_color%} "

# Git prompt configuration
GIT_PROMPT_DIRTY="%{$FG[160]%} ✘✘✘"
GIT_PROMPT_CLEAN="%{$FG[040]%} ✔"

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

# Checks if working tree is dirty
git_dirty() {
  if [[ -n $(git status -s --ignore-submodules=dirty 2> /dev/null) ]]; then
    echo "$GIT_PROMPT_DIRTY"
  else
    echo "$GIT_PROMPT_CLEAN"
  fi
}

# If inside a Git repository, print its branch and state
function git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "%{$FG[239]%}\ue0a0 %{$fg[white]%}${git_where#(refs/heads/|tags/)}$(git_dirty)$(parse_git_state)"
}

# RVM Stuff
local rvm_ruby='$(rvm-prompt i v g)%{$reset_color%}'

function current_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

PROMPT='
%{$FG[239]%}╭─ %{$FG[033]%}$(current_pwd)%{$reset_color%} $(git_prompt_string)%{$reset_color%}
%{$FG[239]%}╰─$(prompt_char)%{$reset_color%} '

# RPROMPT=%{$fg[yellow]%}rvm:%{$reset_color%}%{$FG[239]%}%{$fg[red]%}${rvm_ruby}

# Add the battery status to right-side of prompt -- add the oh-my-zsh battery plugin to your zshrc
RPROMPT='$(battery_pct_prompt)%{$reset_color%}'

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color [(y)es (n)o (a)bort (e)dit]? "
