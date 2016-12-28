# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for git-extras (http://github.com/tj/git-extras).
#
#  This depends on and reuses some of the internals of the _git completion
#  function that ships with zsh itself. It will not work with the _git that ships
#  with git.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Alexis GRIMALDI (https://github.com/agrimaldi)
#  * spacewander (https://github.com/spacewander)
#
# ------------------------------------------------------------------------------
# Inspirations
# -----------
#
#  * git-extras (http://github.com/tj/git-extras)
#  * git-flow-completion (http://github.com/bobthecow/git-flow-completion)
#
# ------------------------------------------------------------------------------


# Internal functions
# These are a lot like their __git_* equivalents inside _git

__gitex_command_successful () {
  if (( ${#*:#0} > 0 )); then
    _message 'not a git repository'
    return 1
  fi
  return 0
}

__gitex_commits() {
    declare -A commits
    git log --oneline -15 | sed 's/\([[:alnum:]]\{7\}\) /\1:/' | while read commit
    do
        hash=$(echo $commit | cut -d':' -f1)
        commits[$hash]="$commit"
    done
    local ret=1
    _describe -t commits commit commits && ret=0
}

__gitex_tag_names() {
    local expl
    declare -a tag_names
    tag_names=(${${(f)"$(_call_program tags git for-each-ref --format='"%(refname)"' refs/tags 2>/dev/null)"}#refs/tags/})
    __git_command_successful || return
    _wanted tag-names expl tag-name compadd $* - $tag_names
}


__gitex_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}

__gitex_specific_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads/"$1" 2>/dev/null)"}#refs/heads/$1/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}

__gitex_feature_branch_names() {
    __gitex_specific_branch_names 'feature'
}

__gitex_refactor_branch_names() {
    __gitex_specific_branch_names 'refactor'
}

__gitex_bug_branch_names() {
    __gitex_specific_branch_names 'bug'
}

__gitex_submodule_names() {
    local expl
    declare -a submodule_names
    submodule_names=(${(f)"$(_call_program branchrefs git submodule status | awk '{print $2}')"})  # '
    __git_command_successful || return
    _wanted submodule-names expl submodule-name compadd $* - $submodule_names
}


__gitex_author_names() {
    local expl
    declare -a author_names
    author_names=(${(f)"$(_call_program branchrefs git log --format='%aN' | sort -u)"})
    __git_command_successful || return
    _wanted author-names expl author-name compadd $* - $author_names
}

# subcommands

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
                        ':branch-name:__gitex_bug_branch_names'
                    ;;
            esac
    esac
}


_git-changelog() {
    _arguments \
        '(-l --list)'{-l,--list}'[list commits]' \
}



_git-contrib() {
    _arguments \
        ':author:__gitex_author_names'
}


_git-count() {
    _arguments \
        '--all[detailed commit count]'
}


_git-delete-branch() {
    _arguments \
        ':branch-name:__gitex_branch_names'
}


_git-delete-submodule() {
    _arguments \
        ':submodule-name:__gitex_submodule_names'
}


_git-delete-tag() {
    _arguments \
        ':tag-name:__gitex_tag_names'
}


_git-effort() {
    _arguments \
        '--above[ignore file with less than x commits]'
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
        '(-v --version)'{-v,--version}'[show current version]'
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
                        ':branch-name:__gitex_feature_branch_names'
                    ;;
            esac
    esac
}


_git-graft() {
    _arguments \
        ':src-branch-name:__gitex_branch_names' \
        ':dest-branch-name:__gitex_branch_names'
}


_git-ignore() {
    _arguments  -C \
        '(--local -l)'{--local,-l}'[show local gitignore]' \
        '(--global -g)'{--global,-g}'[show global gitignore]'
}


_git-missing() {
    _arguments \
        ':first-branch-name:__gitex_branch_names' \
        ':second-branch-name:__gitex_branch_names'
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
                        ':branch-name:__gitex_refactor_branch_names'
                    ;;
            esac
    esac
}


_git-squash() {
    _arguments \
        ':branch-name:__gitex_branch_names'
}

_git-summary() {
    _arguments '--line[summarize with lines rather than commits]'
    __gitex_commits
}


_git-undo(){
    _arguments  -C \
        '(--soft -s)'{--soft,-s}'[only rolls back the commit but changes remain un-staged]' \
        '(--hard -h)'{--hard,-h}'[wipes your commit(s)]'
}

zstyle ':completion:*:*:git:*' user-commands \
    alias:'define, search and show aliases' \
    archive-file:'export the current HEAD of the git repository to a archive' \
    back:'undo and stage latest commits' \
    bug:'create a bug branch' \
    changelog:'populate changelog file with commits since the previous tag' \
    commits-since:'list commits since a given date' \
    contrib:'display author contributions' \
    count:'count commits' \
    create-branch:'create local and remote branch' \
    delete-branch:'delete local and remote branch' \
    delete-merged-branches:'delete merged branches'\
    delete-submodule:'delete submodule' \
    delete-tag:'delete local and remote tag' \
    effort:'display effort statistics' \
    extras:'git-extras' \
    feature:'create a feature branch' \
    fork:'fork a repo on github' \
    fresh-branch:'create empty local branch' \
    gh-pages:'create the GitHub Pages branch' \
    graft:'merge commits from source branch to destination branch' \
    ignore:'add patterns to .gitignore' \
    info:'show info about the repository' \
    local-commits:'list unpushed commits on the local branch' \
    lock:'lock a file excluded from version control' \
    locked:'ls files that have been locked' \
    missing:'show commits missing from another branch' \
    pr:'checks out a pull request locally' \
    rebase-patch:'rebases a patch' \
    refactor:'create a refactor branch' \
    release:'commit, tag and push changes to the repository' \
    rename-tag:'rename a tag' \
    repl:'read-eval-print-loop' \
    reset-file:'reset one file' \
    root:'show path of root' \
    setup:'setup a git repository' \
    show-tree:'show branch tree of commit history' \
    squash:'merge commits from source branch into the current one as a single commit' \
    summary:'repository summary' \
    touch:'one step creation of new files' \
    undo:'remove the latest commit' \
    unlock:'unlock a file excluded from version control'
