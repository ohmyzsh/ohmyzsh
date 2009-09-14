# Varables for themeing the git info prompt:
# ZSH_THEME_GIT_PROMPT_PREFIX - Prefix at the very beginning of the prompt, before the branch name
# ZSH_THEME_GIT_PROMPT_SUFFIX - At the very end of the prompt
# ZSH_THEME_GIT_PROMPT_DIRTY  - Text to display if the branch is dirty
# ZSH_THEME_GIT_PROMPT_CLEAN  - Text to display if the branch is clean

ZSH_THEME_GIT_PROMPT_PREFIX="git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# get the name of the branch we are on
function git_prompt_info() {
  if [[ -d .git ]]; then
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    branch=${ref#refs/heads/}
    CURRENT_BRANCH="$ZSH_THEME_GIT_PROMPT_PREFIX${branch}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  else
    CURRENT_BRANCH=''
  fi

  echo $CURRENT_BRANCH
}
parse_git_dirty () {
  if [[ $(git status  | tail -n1) != "nothing to commit (working directory clean)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

