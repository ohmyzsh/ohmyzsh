dir=$(dirname $0)
source $dir/../git/git.plugin.zsh
source $dir/git-prompt.sh

function git_prompt_info() {
  __git_ps1 "${ZSH_THEME_GIT_PROMPT_PREFIX//\%/%%}%s${ZSH_THEME_GIT_PROMPT_SUFFIX//\%/%%}"
}
