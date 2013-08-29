#compdef git
# Completion for git-note sciprt:
# https://bitbucket.org/rkj/dotfiles/src/88f2d39f09ae40622c9561c366cd97d3363fe57c/bin/git-note?at=default
__git_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}

_git-note() {
    _arguments \
      - set1 \
      '-b[branch to attach note to]:branch-name:__git_branch_names ' \
      - set2 \
      '-l[list all branches with notes]' \
      - set3 \
      '-v[also show branches without notes]'
}

zstyle ':completion:*:*:git:*' user-commands \
    note:'add a note to branch' \

