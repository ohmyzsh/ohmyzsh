autoload promptinit && promptinit || return 1

zmodload zsh/parameter

# has it been loaded correctly? if not, bail out early.
(( $+functions[prompt_powerline_setup] )) || return 2

# we can never know for sure powerline font is installed, but if we're on
# rxvt-unicode, chances are good. note that most zstyles have to be set before
# the prompt is loaded since they are not continuously re-evaluated.
#[[ $TERM == "rxvt-unicode-256color" ]] || return 3

### additional zstyles

# set some fixed host colors
zstyle ':prompt:*:twilight*' host-color 093
zstyle ':prompt:*:pinkie*' host-color 201
zstyle ':prompt:*:rarity' host-color white
zstyle ':prompt:*:applejack' host-color 208
zstyle ':prompt:*:fluttershy' host-color 226

# only show username on remote server or if it's different from my default
[[ -n $SSH_CONNECTION || $USER == valodim ]] && zstyle ':prompt:powerline:ps1' hide-user 1

# enable check-for-changes, for the ¹² indicators in git
zstyle ':vcs_info:*:powerline:*' check-for-changes true


### additional git info hooks


# Show remote ref name and number of commits ahead-of or behind
+vi-git-tracking () {
    local ahead behind remote tmp
    local -a formats

    # Get tracking-formats, or bail out immediately
    zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" trackingformats formats || return 0

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        if (( ahead && behind )); then
zformat -f tmp $formats[3] a:$ahead b:$behind
        elif (( ahead )); then
zformat -f tmp $formats[1] a:$ahead
        elif (( behind )); then
zformat -f tmp $formats[2] b:$behind
        fi

hook_com[branch]+=$tmp
    fi
}

# Show count of stashed changes
+vi-git-stash () {
    local -a stashes
    local -a format

    zstyle -s ":vcs_info:${vcs}:${usercontext}:${rrn}" stashformat format || return 0

    if [[ -n $format && -s ${hook_com[base]}/.git/refs/stash ]] ; then
        # find number of stashed commits
        stashes=$(git stash list 2>/dev/null | wc -l)
        (( stashes )) || return 0

        # add to misc
        zformat -f tmp $format s:$stashes
        hook_com[misc]+=$tmp
    fi
}

# install git hooks
zstyle ':vcs_info:git+set-message:*' hooks git-tracking git-stash


### lofi hook


# this is a hook which stops vcs_info right after the vcs detection step.
#
# this allows displaying a piece of information that the current PWD is inside
# a vcs repository and its type, without loading the heavyweight vcs data.
#
# this function was hardly tested with anything besides git, and probably has
# bugs.
#
+vi-lofi () {

    # locals
    local msg basedir subdir
    local -i i
    local -xA hook_com
    local -xa msgs

    # lofi mode enabled?
    if ! zstyle -t ":vcs_info:${vcs}:${usercontext}:${PWD}" lofi ; then
        # if not, just leave.
        return 0
    fi

    # get lofi styles
    zstyle -a ":vcs_info:${vcs}:${usercontext}:${rrn}" lofiformats msgs

    # if no lofi styles are set, better chicken out here
    (( $#msgs == 0 )) && return 0

    # git has the only detect mechanism that does not set the basedir. sheesh.
    if (( $+vcs_comm[gitdir] )); then
basedir=${PWD%/${$( ${vcs_comm[cmd]} rev-parse --show-prefix )%/##}}
    elif (( $+vcs_comm[basedir] )); then
basedir=$vcs_comm[basedir]
    else
        # no set? huh. just assume it's PWD, then...
        basedir=$PWD
    fi
    # get subdir within repo tree
    subdir="$(VCS_INFO_reposub ${basedir})"

    # process the messages as usual, but with only the vcs name as %s
    (( ${#msgs} > maxexports )) && msgs[$(( maxexports + 1 )),-1]=()
    for i in {1..${#msgs}} ; do
if VCS_INFO_hook "set-lofi-message" $(( $i - 1 )) "${msgs[$i]}"; then
zformat -f msg ${msgs[$i]} s:${vcs} R:${basedir} S:${subdir}
            msgs[$i]=${msg}
        else
msgs[$i]=${hook_com[message]}
        fi
done

    # this from msgs
    VCS_INFO_set

    # this is the value passed back up to vcs_info, which stops further processing
    ret=1
    return 1
}

# function which disables lofi for this particular directory
prompt-unlofi-pwd () {
    # disable lofi mode for this directory and all subdirs
    zstyle ":vcs_info:*:*:$PWD*" lofi false

    # if this is run as a widget, ...
    if zle; then
        # manually re-run all prompt precmd functions (so vcs_info is
        # reevaluated as well), and reset prompt to update status.
        for f in ${(M)precmd_functions#prompt_*_precmd}; $f
        zle .reset-prompt
    fi
}
zle -N prompt-unlofi-pwd
bindkey '^G^L' prompt-unlofi-pwd

# lofi every directory by default
zstyle ':vcs_info:*' lofi true
# but not .zsh, that's small we always wanna see it
zstyle ":vcs_info:*:$HOME/.zsh*" lofi true
zstyle ':vcs_info-static_hooks:pre-get-data' hooks lofi


### actually select the prompt

prompt powerline
