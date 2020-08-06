#!/usr/bin/env zsh

function omz {
    [[ $# -gt 0 ]] || {
        _omz::help
        return 1
    }

    local command="$1"
    shift

    # Subcommand functions start with _ so that they don't
    # appear as completion entries when looking for `omz`
    (( $+functions[_omz::$command] )) || {
        _omz::help
        return 1
    }

    _omz::$command "$@"
}

function _omz {
    local -a cmds subcmds
    cmds=(
        'help:Usage information'
        'update:Update Oh My Zsh'
        'pr:Commands for Oh My Zsh Pull Requests'
    )

    if (( CURRENT == 2 )); then
        _describe 'command' cmds
    elif (( CURRENT == 3 )); then
        case "$words[2]" in
            pr) subcmds=( 'test:Test a Pull Request' 'clean:Delete all Pull Request branches' )
                _describe 'command' subcmds ;;
        esac
    fi

    return 0
}

compdef _omz omz


function _omz::help {
    cat <<EOF
Usage: omz <command> [options]

Available commands:

    help                Print this help message
    update              Update Oh My Zsh
    pr <command>        Commands for Oh My Zsh Pull Requests

EOF
}

function _omz::log {
    # if promptsubst is set, a message with `` or $()
    # will be run even if quoted due to `print -P`
    setopt localoptions nopromptsubst

    # $1 = info|warn|error|debug
    # $@ = text

    local logtype=$1
    local logname=${${functrace[1]#_}%:*}
    shift

    # Don't print anything if debug is not active
    if [[ $logtype = debug && -z $_OMZ_DEBUG ]]; then
        return
    fi

    # Choose coloring based on log type
    case "$logtype" in
        prompt) print -Pn "%S%F{blue}$logname%f%s: $@" ;;
        debug) print -P "%F{white}$logname%f: $@" ;;
        info) print -P "%F{green}$logname%f: $@" ;;
        warn) print -P "%S%F{yellow}$logname%f%s: $@" ;;
        error) print -P "%S%F{red}$logname%f%s: $@" ;;
    esac >&2
}

function _omz::pr {
    (( $# > 0 && $+functions[_omz::pr::$1] )) || {
        cat <<EOF
Usage: omz pr <command> [options]

Available commands:

    clean                       Delete all PR branches (ohmyzsh/pull-*)
    test <PR_number_or_URL>     Fetch PR #NUMBER and rebase against master

EOF
        return 1
    }

    local command="$1"
    shift

    _omz::pr::$command "$@"
}

function _omz::pr::clean {
    (
        set -e
        builtin cd -q "$ZSH"

        _omz::log info "removing all Oh My Zsh Pull Request branches..."
        command git branch --list 'ohmyzsh/pull-*' | while read branch; do
            command git branch -D "$branch"
        done
    )
}

function _omz::pr::test {
    # Allow $1 to be a URL to the pull request
    if [[ "$1" = https://* ]]; then
        1="${1:t}"
    fi

    # Check the input
    if ! [[ -n "$1" && "$1" =~ ^[[:digit:]]+$ ]]; then
        echo >&2 "Usage: omz pr test <PR_NUMBER_or_URL>"
        return 1
    fi

    # Save current git HEAD
    local branch
    branch=$(builtin cd -q "$ZSH"; git symbolic-ref --short HEAD) || {
        _omz::log error "error when getting the current git branch. Aborting..."
        return 1
    }


    # Fetch PR onto ohmyzsh/pull-<PR_NUMBER> branch and rebase against master
    # If any of these operations fail, undo the changes made
    (
        set -e
        builtin cd -q "$ZSH"

        # Get the ohmyzsh git remote
        command git remote -v | while read remote url _; do
            case "$url" in
            https://github.com/ohmyzsh/ohmyzsh(|.git)) found=1; break ;;
            git@github.com:ohmyzsh/ohmyzsh(|.git)) found=1; break ;;
            esac
        done

        (( $found )) || {
            _omz::log error "could not found the ohmyzsh git remote. Aborting..."
            return 1
        }

        # Fetch pull request head
        _omz::log info "fetching PR #$1 to ohmyzsh/pull-$1..."
        command git fetch -f "$remote" refs/pull/$1/head:ohmyzsh/pull-$1 || {
            _omz::log error "error when trying to fetch PR #$1."
            return 1
        }

        # Rebase pull request branch against the current master
        _omz::log info "rebasing PR #$1..."
        command git rebase master ohmyzsh/pull-$1 || {
            command git rebase --abort &>/dev/null
            _omz::log warn "could not rebase PR #$1 on top of master."
            _omz::log warn "you might not see the latest stable changes."
            _omz::log info "run \`zsh\` to test the changes."
            return 1
        }

        _omz::log info "fetch of PR #${1} successful."
    )

    # If there was an error, abort running zsh to test the PR
    [[ $? -eq 0 ]] || return 1

    # Run zsh to test the changes
    _omz::log info "running \`zsh\` to test the changes. Run \`exit\` to go back."
    command zsh -l

    # After testing, go back to the previous HEAD if the user wants
    _omz::log prompt "do you want to go back to the previous branch? [Y/n] "
    read -r -k 1

    # If no newline entered, add a newline
    [[ "$REPLY" != $'\n' ]] && echo
    # If NO selected, do nothing else
    [[ "$REPLY" = [nN] ]] && return

    (
        set -e
        builtin cd -q "$ZSH"

        command git checkout "$branch" -- || {
            _omz::log error "could not go back to the previous branch ('$branch')."
            return 1
        }
    )
}

function _omz::update {
    env ZSH="$ZSH" sh "$ZSH/tools/upgrade.sh"
    # Update last updated file
    zmodload zsh/datetime
    echo "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >! "${ZSH_CACHE_DIR}/.zsh-update"
    # Remove update lock if it exists
    command rm -rf "$ZSH/log/update.lock"
}
