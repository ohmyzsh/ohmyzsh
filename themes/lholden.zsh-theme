# ------------------------------------------------------------------------
# Lori Holden oh-my-zsh theme
# Git and RVM information on the prompt
# ------------------------------------------------------------------------

function git_custom_branch() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX${cb}$ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX"
  fi
}

function rvm_custom_prompt {
  local rvmp=$(~/.rvm/bin/rvm-prompt i v g s 2> /dev/null) || return
  echo "$ZSH_THEME_RVM_PROMPT_BRANCH_PREFIX${rvmp}$ZSH_THEME_RVM_PROMPT_BRANCH_SUFFIX"
}

ZSH_THEME_RVM_PROMPT_BRANCH_PREFIX=" $reset_color$fg[magenta]["
ZSH_THEME_RVM_PROMPT_BRANCH_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_BRANCH_PREFIX=" $reset_color$fg[magenta]["
ZSH_THEME_GIT_PROMPT_BRANCH_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="@"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="]"
ZSH_THEME_GIT_PROMPT_DIRTY="$reset_color$fg_bold[red]*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_AHEAD="$reset_color$fg_bold[red]!"

# Prompt format
PROMPT='( $fg[white]%n@%m$fg[white]:$(parse_git_dirty)$(git_prompt_ahead)$reset_color$fg_bold[blue]%~%u$(git_custom_branch)$(git_prompt_short_sha)$(rvm_custom_prompt)$reset_color )
$fg_bold[blue]%%$reset_color '
