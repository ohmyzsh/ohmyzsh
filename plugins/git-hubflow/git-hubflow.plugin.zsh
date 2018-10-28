alias ghf='git hf'
alias ghff='git hf feature'
alias ghfr='git hf release'
alias ghfh='git hf hotfix'
alias ghfs='git hf support'
alias ghfu='git hf update'

_git-hf ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)

            local -a subcommands
            subcommands=(
                'init:Initialize a new git repo with support for the branching model.'
                'feature:Manage your feature branches.'
                'release:Manage your release branches.'
                'hotfix:Manage your hotfix branches.'
                'support:Manage your support branches.'
                'update:Pull upstream changes down into your master and develop branches.'
                'version:Shows version information.'
            )
            _describe -t commands 'git hf' subcommands
        ;;

        (options)
            case $line[1] in

                (init)
                    _arguments \
                        -f'[Force setting of gitflow branches, even if already configured]'
                ;;

                (version)
                ;;

                (hotfix)
                    __git-hf-hotfix
                ;;

                (release)
                    __git-hf-release
                ;;

                (feature)
                    __git-hf-feature
                ;;
            esac
        ;;
    esac
}

__git-hf-release ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)

            local -a subcommands
            subcommands=(
                'start:Start a new release branch.'
                'finish:Finish a release branch.'
                'list:List all your release branches. (Alias to `git hf release`)'
                'cancel:Cancel release'
                'push:Push release to github'
                'pull:Pull release from github'
                'track:Track release'
            )
            _describe -t commands 'git hf release' subcommands
            _arguments \
                -v'[Verbose (more) output]'
        ;;

        (options)
            case $line[1] in

                (start)
                    _arguments \
                        -F'[Fetch from origin before performing finish]'\
                        ':version:__git_hf_version_list'
                ;;

                (finish)
                    _arguments \
                        -F'[Fetch from origin before performing finish]' \
                        -s'[Sign the release tag cryptographically]'\
                        -u'[Use the given GPG-key for the digital signature (implies -s)]'\
                        -m'[Use the given tag message]'\
                        -p'[Push to $ORIGIN after performing finish]'\
                        -k'[Keep branch after performing finish]'\
                        -n"[Don't tag this release]"\
                        ':version:__git_hf_version_list'
                ;;

                *)
                    _arguments \
                        -v'[Verbose (more) output]'
                ;;
            esac
        ;;
    esac
}

__git-hf-hotfix ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)

            local -a subcommands
            subcommands=(
                'start:Start a new hotfix branch.'
                'finish:Finish a hotfix branch.'
                'list:List all your hotfix branches. (Alias to `git hf hotfix`)'
                'publish:Publish the hotfix branch.'
                'track:Track the hotfix branch.'
                'pull:Pull the hotfix from github.'
                'push:Push the hotfix to github.'
                'cancel:Cancel the hotfix.'
            )
            _describe -t commands 'git hf hotfix' subcommands
            _arguments \
                -v'[Verbose (more) output]'
        ;;

        (options)
            case $line[1] in

                (start)
                    _arguments \
                        -F'[Fetch from origin before performing finish]'\
                        ':hotfix:__git_hf_version_list'\
                        ':branch-name:__git_branch_names'
                ;;

                (finish)
                    _arguments \
                        -F'[Fetch from origin before performing finish]' \
                        -s'[Sign the release tag cryptographically]'\
                        -u'[Use the given GPG-key for the digital signature (implies -s)]'\
                        -m'[Use the given tag message]'\
                        -p'[Push to $ORIGIN after performing finish]'\
                        -k'[Keep branch after performing finish]'\
                        -n"[Don't tag this release]"\
                        ':hotfix:__git_hf_hotfix_list'
                ;;

                *)
                    _arguments \
                        -v'[Verbose (more) output]'
                ;;
            esac
        ;;
    esac
}

__git-hf-feature ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)

            local -a subcommands
            subcommands=(
                'list:List all your feature branches. (Alias to `git hf feature`)'
                'start:Start a new feature branch'
                'finish:Finish a feature branch'
                'submit:submit'
                'track:track'
                'diff:Diff'
                'rebase:Rebase feature branch against develop'
                'checkout:Checkout feature'
                'pull:Pull feature branch from github'
                'push:Push feature branch to github'
                'cancel:Cancel feature'
            )
            _describe -t commands 'git hf feature' subcommands
            _arguments \
                -v'[Verbose (more) output]'
        ;;

        (options)
            case $line[1] in

                (start)
                    _arguments \
                        -F'[Fetch from origin before performing finish]'\
                        ':feature:__git_hf_feature_list'\
                        ':branch-name:__git_branch_names'
                ;;

                (finish)
                    _arguments \
                        -F'[Fetch from origin before performing finish]' \
                        -r'[Rebase instead of merge]'\
                        ':feature:__git_hf_feature_list'
                ;;

                (publish)
                    _arguments \
                        ':feature:__git_hf_feature_list'\
                ;;

                (track)
                    _arguments \
                        ':feature:__git_hf_feature_list'\
                ;;

                (diff)
                    _arguments \
                        ':branch:__git_branch_names'\
                ;;

                (rebase)
                    _arguments \
                        -i'[Do an interactive rebase]' \
                        ':branch:__git_branch_names'
                ;;

                (checkout)
                    _arguments \
                        ':branch:__git_hf_feature_list'\
                ;;

                (pull)
                    _arguments \
                        ':remote:__git_remotes'\
                        ':branch:__git_branch_names'
                ;;

                *)
                    _arguments \
                        -v'[Verbose (more) output]'
                ;;
            esac
        ;;
    esac
}

__git_hf_version_list ()
{
    local expl
    declare -a versions

    versions=(${${(f)"$(_call_program versions git hf release list 2> /dev/null | tr -d ' |*')"}})
    __git_command_successful || return

    _wanted versions expl 'version' compadd $versions
}

__git_hf_feature_list ()
{
    local expl
    declare -a features

    features=(${${(f)"$(_call_program features git hf feature list 2> /dev/null | tr -d ' |*')"}})
    __git_command_successful || return

    _wanted features expl 'feature' compadd $features
}

__git_remotes () {
    local expl gitdir remotes

    gitdir=$(_call_program gitdir git rev-parse --git-dir 2>/dev/null)
    __git_command_successful || return

    remotes=(${${(f)"$(_call_program remotes git config --get-regexp '"^remote\..*\.url$"')"}//#(#b)remote.(*).url */$match[1]})
    __git_command_successful || return

    # TODO: Should combine the two instead of either or.
    if (( $#remotes > 0 )); then
        _wanted remotes expl remote compadd $* - $remotes
    else
        _wanted remotes expl remote _files $* - -W "($gitdir/remotes)" -g "$gitdir/remotes/*"
    fi
}

__git_hf_hotfix_list ()
{
    local expl
    declare -a hotfixes

    hotfixes=(${${(f)"$(_call_program hotfixes git hf hotfix list 2> /dev/null | tr -d ' |*')"}})
    __git_command_successful || return

    _wanted hotfixes expl 'hotfix' compadd $hotfixes
}

__git_branch_names () {
    local expl
    declare -a branch_names

    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return

    _wanted branch-names expl branch-name compadd $* - $branch_names
}

__git_command_successful () {
    if (( ${#pipestatus:#0} > 0 )); then
        _message 'not a git repository'
        return 1
    fi
    return 0
}

zstyle ':completion:*:*:git:*' user-commands flow:'description for foo'
