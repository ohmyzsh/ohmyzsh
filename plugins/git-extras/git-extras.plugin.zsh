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

__gitex_chore_branch_names() {
    __gitex_specific_branch_names 'chore'
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
_git-authors() {
    _arguments  -C \
        '(--list -l)'{--list,-l}'[show authors]' \
        '--no-email[without email]' \
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
                        ':branch-name:__gitex_bug_branch_names'
                    ;;
            esac
    esac
}


_git-changelog() {
    _arguments \
        '(-l --list)'{-l,--list}'[list commits]' \
}

_git-chore() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'finish:merge and delete the chore branch'
            )
            _describe -t commands command commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*}-$line[1]:
            case $line[1] in
                (finish)
                    _arguments -C \
                        ':branch-name:__gitex_chore_branch_names'
                    ;;
            esac
    esac
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

_git-guilt() {
    _arguments -C \
        '(--email -e)'{--email,-e}'[display author emails instead of names]' \
        '(--ignore-whitespace -w)'{--ignore-whitespace,-w}'[ignore whitespace only changes]' \
        '(--debug -d)'{--debug,-d}'[output debug information]' \
        '-h[output usage information]'
}

_git-ignore() {
    _arguments  -C \
        '(--local -l)'{--local,-l}'[show local gitignore]' \
        '(--global -g)'{--global,-g}'[show global gitignore]'
}


_git-ignore() {
    _arguments  -C \
        '(--append -a)'{--append,-a}'[append .gitignore]' \
        '(--replace -r)'{--replace,-r}'[replace .gitignore]' \
        '(--list-in-table -l)'{--list-in-table,-l}'[print available types in table format]' \
        '(--list-alphabetically -L)'{--list-alphabetically,-L}'[print available types in alphabetical order]' \
        '(--search -s)'{--search,-s}'[search word in available types]'
}


_git-merge-into() {
    _arguments '--ff-only[merge only fast-forward]'
    _arguments \
        ':src:__gitex_branch_names' \
        ':dest:__gitex_branch_names'
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

_git-stamp() {
    _arguments  -C \
         '(--replace -r)'{--replace,-r}'[replace stamps with same id]'
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
    archive-file:'export the current head of the git repository to an archive' \
    authors:'generate authors report' \
    back:'undo and stage latest commits' \
    bug:'create bug branch' \
    changelog:'generate a changelog report' \
    chore:'create chore branch' \
    clear-soft:'soft clean up a repository' \
    clear:'rigorously clean up a repository' \
    commits-since:'show commit logs since some date' \
    contrib:'show user contributions' \
    count:'show commit count' \
    create-branch:'create branches' \
    delete-branch:'delete branches' \
    delete-merged-branches:'delete merged branches' \
    delete-submodule:'delete submodules' \
    delete-tag:'delete tags' \
    delta:'lists changed files' \
    effort:'show effort statistics on file(s)' \
    extras:'awesome git utilities' \
    feature:'create/merge feature branch' \
    force-clone:'overwrite local repositories with clone' \
    fork:'fork a repo on github' \
    fresh-branch:'create fresh branches' \
    gh-pages:'create the github pages branch' \
    graft:'merge and destroy a given branch' \
    guilt:'calculate change between two revisions' \
    ignore-io:'get sample gitignore file' \
    ignore:'add .gitignore patterns' \
    info:'returns information on current repository' \
    local-commits:'list local commits' \
    lock:'lock a file excluded from version control' \
    locked:'ls files that have been locked' \
    merge-into:'merge one branch into another' \
    merge-repo:'merge two repo histories' \
    missing:'show commits missing from another branch' \
    obliterate:'rewrite past commits to remove some files' \
    pr:'checks out a pull request locally' \
    psykorebase:'rebase a branch with a merge commit' \
    pull-request:'create pull request to GitHub project' \
    reauthor:'replace the author and/or committer identities in commits and tags' \
    rebase-patch:'rebases a patch' \
    refactor:'create refactor branch' \
    release:'commit, tag and push changes to the repository' \
    rename-branch:'rename a branch' \
    rename-tag:'rename a tag' \
    repl:'git read-eval-print-loop' \
    reset-file:'reset one file' \
    root:'show path of root' \
    scp:'copy files to ssh compatible `git-remote`' \
    sed:'replace patterns in git-controlled files' \
    setup:'set up a git repository' \
    show-merged-branches:'show merged branches' \
    show-tree:'show branch tree of commit history' \
    show-unmerged-branches:'show unmerged branches' \
    squash:'import changes from a branch' \
    stamp:'stamp the last commit message' \
    standup:'recall the commit history' \
    summary:'show repository summary' \
    sync:'sync local branch with remote branch' \
    touch:'touch and add file to the index' \
    undo:'remove latest commits' \
    unlock:'unlock a file excluded from version control'
