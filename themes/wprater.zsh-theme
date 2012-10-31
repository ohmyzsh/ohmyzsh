# wprater zsh prompt (oh-my-zsh)
#
# Most of the ideas in here have been borrrowed from environments I've used
# over the past 10 years or so.  Unfortunetely Im not able to credit everyone.
#

# If we're root, then user and prompt will be bold red
function prompt_char {
    [ $UID -eq 0 ] && echo "%{$fg_bold[red]%}#%{$reset_color%}" && return
    echo "%{$green%}$%{$reset_color%}"
}

function user_name {
    [ $UID -eq 0 ] && echo "%{$fg_bold[red]%}%n%{$reset_color%}" && return
    echo "%{$purple%}%n%{$reset_color%}"
}

function rvm_ruby {
    if which rvm-prompt &> /dev/null; then
      echo "‹$(rvm-prompt i v g)›%{$reset_color%}"
    else
      if which rbenv &> /dev/null; then
        echo "‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}"
      fi
    fi
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

setopt prompt_subst
autoload colors
colors

autoload -U add-zsh-hook
autoload -Uz vcs_info

#use extended color pallete if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
    yellow="%F{226}"
    lightgrey="%F{243}"
else
    turquoise="$fg[cyan]"
    orange="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
fi

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
FMT_UNSTAGED="%{$orange%}●"
FMT_STAGED="%{$limegreen%}●"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function precmd {
    title zsh "$PWD"
    if [[ $ZSH_VERSION > 4.3.6 ]]; then
        vcs_info 'prompt'
    fi
}

PROMPT='
 $(user_name)@%{$orange%}%m%{$reset_color%}: %{$yellow%}%~%{$reset_color%} $vcs_info_msg_0_ %{$lightgrey%}$(rvm_ruby)%{$reset_color%}
 $(virtualenv_info)$(prompt_char)%{$reset_color%} '
