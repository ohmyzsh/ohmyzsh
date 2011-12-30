# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '┄ '`basename $VIRTUAL_ENV`' ┄─'
}
PR_GIT_UPDATE=1

setopt prompt_subst
autoload colors
colors

autoload -U add-zsh-hook
autoload -Uz vcs_info

#use extended color pallete if available
turquoise="$fg[blue]"
orange="$fg[yellow]"
purple="$fg[magenta]"
hotpink="$fg[red]"
limegreen="$fg[green]"
red="$fg[red]"

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%{${reset_color}%}"
FMT_BRANCH="(%{$turquoise%}%b%u%c${PR_RST})"
FMT_ACTION="(%{$limegreen%}%a${PR_RST})"
FMT_UNSTAGED="%{$red%}⁺"
FMT_STAGED="%{$limegreen%}⁺"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function epegzz_preexec {
    case "$(history $HISTCMD)" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
        *svn*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec epegzz_preexec

function epegzz_chpwd {
    PR_GIT_UPDATE=1
}
add-zsh-hook chpwd epegzz_chpwd

function epegzz_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # check for untracked files or updated submodules, since vcs_info doesn't
        if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
            PR_GIT_UPDATE=1
            FMT_BRANCH="%B%{$turquoise%}%b%u%c%{$hotpink%}%B⁺${PR_RST}"
        else
            FMT_BRANCH="%B%{$turquoise%}%b%u%c${PR_RST}"
        fi
        zstyle ':vcs_info:*:prompt:*' formats       "on ${FMT_BRANCH}"

        vcs_info 'prompt'
        PR_GIT_UPDATE=
    fi
}
add-zsh-hook precmd epegzz_precmd

local return_code="%(?..%{$fg[red]%}%B%? ⚡%b%{$reset_color%}) "

PROMPT=$'
┌─ %B%{$purple%}%n%{$reset_color%}%b at %B%{$orange%}%m%{$reset_color%}%b in %B%{$limegreen%}%~%{$reset_color%}%b $vcs_info_msg_0_%{$reset_color%}
└─$(virtualenv_info)%{$reset_color%}➤%b '
RPROMPT='${return_code}%F{bla}%*%b${PR_NO_COLOUR}'
