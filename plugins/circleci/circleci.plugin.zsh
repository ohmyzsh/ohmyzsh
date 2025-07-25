# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
__CI_ZSH_DIR="${0:h:A}"

alias cis='circleci_status'


function circleci_status() {
    python3 "$__CI_ZSH_DIR"/circleci_status.py "$(git_current_branch)" "$(git_repo_name)" | less
}
