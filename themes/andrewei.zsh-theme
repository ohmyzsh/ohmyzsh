# modified by andrewei1316
# http://github.com/andrewei1316
#
# prompt style and colors based on half-life theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/half-life.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

PR_GIT_UPDATE=1
setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

# COLOR
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"

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
FMT_BRANCH="$BLUE on($CYAN%b$BLUE)%u%c${PR_RST}"
FMT_ACTION=" performing a $GREEN%a${PR_RST}"
FMT_UNSTAGED="$YELLOW✭ "
FMT_STAGED="$GREEN✭ "

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function steeef_preexec {
    case "$(history $HISTCMD)" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
        *svn*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec steeef_preexec

function steeef_chpwd {
    PR_GIT_UPDATE=1
}
add-zsh-hook chpwd steeef_chpwd

function steeef_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # check for untracked files or updated submodules, since vcs_info doesn't
        if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
            PR_GIT_UPDATE=1
            FMT_BRANCH="${PM_RST}$BLUE on($CYAN%b$BLUE)%u%c$RED✭ ${PR_RST}"
        else
            FMT_BRANCH="${PM_RST}$BLUE on($CYAN%b$BLUE)%u%c${PR_RST}"
        fi
        zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"

        vcs_info 'prompt'
        PR_GIT_UPDATE=1
    fi
}
add-zsh-hook precmd steeef_precmd

PROMPT='$RED$(virtualenv_prompt_info)$FINISH$BLUE%n@%m$FINISH $GREEN%~$FINISH$vcs_info_msg_0_$_YELLOW$FINISH at $RED%*$YELLOW λ%{$reset_color%}
$CYAN%n$_YELLOW>>>$FINISH '
