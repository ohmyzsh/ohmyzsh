#compdef git
__git_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}

_git-note() {
    _arguments '-b :branch-name:__git_branch_names [branch to attach note to]' \
      '-l[list all branches with notes]' \
      '-v[also show branches without notes]'
}

zstyle ':completion:*:*:git:*' user-commands \
    note:'add a note to branch' \

