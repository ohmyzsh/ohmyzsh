#compdef git
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for git-extras (http://github.com/visionmedia/git-extras).
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Alexis GRIMALDI (https://github.com/agrimaldi)
#
# ------------------------------------------------------------------------------
# Inspirations
# -----------
#
#  * git-extras (http://github.com/visionmedia/git-extras)
#  * git-flow-completion (http://github.com/bobthecow/git-flow-completion)
#
# ------------------------------------------------------------------------------


__git_command_successful () {
    if (( ${#pipestatus:#0} > 0 )); then
        _message 'not a git repository'
        return 1
    fi
    return 0
}


__git_tag_names() {
    local expl
    declare -a tag_names
    tag_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/tags 2>/dev/null)"}#refs/tags/})
    __git_command_successful || return
    _wanted tag-names expl tag-name compadd $* - $tag_names
}


__git_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}


__git_feature_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads/feature 2>/dev/null)"}#refs/heads/feature/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}


__git_refactor_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads/refactor 2>/dev/null)"}#refs/heads/refactor/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}


__git_bug_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads/bug 2>/dev/null)"}#refs/heads/bug/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}


__git_submodule_names() {
    local expl
    declare -a submodule_names
    submodule_names=(${(f)"$(_call_program branchrefs git submodule status | awk '{print $2}')"})
    __git_command_successful || return
    _wanted submodule-names expl submodule-name compadd $* - $submodule_names
}


__git_author_names() {
    local expl
    declare -a author_names
    author_names=(${(f)"$(_call_program branchrefs git log --format='%aN' | sort -u)"})
    __git_command_successful || return
    _wanted author-names expl author-name compadd $* - $author_names
}


_git-changelog() {
    _arguments \
        '(-l --list)'{-l,--list}'[list commits]' \
}


_git-effort() {
    _arguments \
        '--above[ignore file with less than x commits]' \
}


_git-contrib() {
    _arguments \
        ':author:__git_author_names'
}


_git-count() {
    _arguments \
        '--all[detailed commit count]'
}


_git-delete-branch() {
    _arguments \
        ':branch-name:__git_branch_names'
}


_git-delete-submodule() {
    _arguments \
        ':submodule-name:__git_submodule_names'
}


_git-delete-tag() {
    _arguments \
        ':tag-name:__git_tag_names'
}


_git-extras() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'update:update git-extras'
            )
            _describe -t commands command commands && ret=0
            ;;
    esac

    _arguments \
        '(-v --version)'{-v,--version}'[show current version]' \
}


_git-graft() {
    _arguments \
        ':src-branch-name:__git_branch_names' \
        ':dest-branch-name:__git_branch_names'
}


_git-squash() {
    _arguments \
        ':branch-name:__git_branch_names'
}


_git-feature() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'finish:merge feature into the current branch'
            )
            _describe -t commands command commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*}-$line[1]:
            case $line[1] in
                (finish)
                    _arguments -C \
                        ':branch-name:__git_feature_branch_names'
                    ;;
            esac
    esac
}


_git-refactor() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'finish:merge refactor into the current branch'
            )
            _describe -t commands command commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*}-$line[1]:
            case $line[1] in
                (finish)
                    _arguments -C \
                        ':branch-name:__git_refactor_branch_names'
                    ;;
            esac
    esac
}


_git-bug() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'finish:merge bug into the current branch'
            )
            _describe -t commands command commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*}-$line[1]:
            case $line[1] in
                (finish)
                    _arguments -C \
                        ':branch-name:__git_bug_branch_names'
                    ;;
            esac
    esac
}


zstyle ':completion:*:*:git:*' user-commands \
    changelog:'populate changelog file with commits since the previous tag' \
    contrib:'display author contributions' \
    count:'count commits' \
    delete-branch:'delete local and remote branch' \
    delete-submodule:'delete submodule' \
    delete-tag:'delete local and remote tag' \
    extras:'git-extras' \
    graft:'merge commits from source branch to destination branch' \
    squash:'merge commits from source branch into the current one as a single commit' \
    feature:'create a feature branch' \
    refactor:'create a refactor branch' \
    bug:'create a bug branch' \
    summary:'repository summary' \
    effort:'display effort statistics' \
    repl:'read-eval-print-loop' \
    commits-since:'list commits since a given date' \
    release:'release commit with the given tag' \
    alias:'define, search and show aliases' \
    ignore:'add patterns to .gitignore' \
    info:'show info about the repository' \
    create-branch:'create local and remote branch' \
    fresh-branch:'create empty local branch' \
    undo:'remove the latest commit' \
    setup:'setup a git repository' \
    touch:'one step creation of new files' \
    obliterate:'Completely remove a file from the repository, including past commits and tags' \
    local-commits:'list unpushed commits on the local branch' \
