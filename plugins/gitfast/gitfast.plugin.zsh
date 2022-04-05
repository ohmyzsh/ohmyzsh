<<<<<<< HEAD
dir=$(dirname $0)
source $dir/../git/git.plugin.zsh
source $dir/git-prompt.sh
=======
# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

source "${0:A:h}/git-prompt.sh"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

function git_prompt_info() {
  dirty="$(parse_git_dirty)"
  __git_ps1 "${ZSH_THEME_GIT_PROMPT_PREFIX//\%/%%}%s${dirty//\%/%%}${ZSH_THEME_GIT_PROMPT_SUFFIX//\%/%%}"
}
