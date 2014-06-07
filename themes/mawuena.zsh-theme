# CRUNCH - created from Steve Eley's cat waxing.
# Initially hacked from the Dallas theme. Thanks, Dallas Reedy.
#
# This theme assumes you do most of your oh-my-zsh'ed "colorful" work at a single machine,
# and eschews the standard space-consuming user and hostname info.  Instead, only the
# things that vary in my own workflow are shown:
#
# * The time (not the date)
# * The RVM version and gemset (omitting the 'ruby' name if it's MRI)
# * The current directory
# * The Git branch and its 'dirty' state
#
# Colors are at the top so you can mess with those separately if you like.
# For the most part I stuck with Dallas's.

CL_NORMAL='%{[0m%}'   # %{^[[0m%} = normal
CL_GREY='%{[0;30m%}'  # %{^[[0;30m%} = grey
CL_RED='%{[0;31m%}'   # %{^[[0;31m%} = red
CL_GREEN='%{[0;32m%}' # %{^[[0;32m%} = green
CL_BROWN='%{[0;35m%}' # %{^[[0;35m%} = brown
CL_YELLOW='%{[0;33m%}'        # %{^[[0;33m%} = yellow
CL_BLUE='%{[0;34m%}'  # %{^[[0;34m%} = blue
CL_CYAN='%{[0;36m%}'  # %{^[[0;36m%} = cyan
CL_SPECIAL='%{[1;30m%}'       # %{^[[1;30m%} = bold grey

CR_DEB_COLOR="%{$fg[green]%}"
CRUNCH_BRACKET_COLOR="%{$fg[white]%}"
CRUNCH_TIME_COLOR="%{$fg[yellow]%}"
CRUNCH_RVM_COLOR="%{$fg[magenta]%}"
CRUNCH_DIR_COLOR="%{$fg[cyan]%}"
CRUNCH_GIT_BRANCH_COLOR="%{$fg[green]%}"
CRUNCH_GIT_CLEAN_COLOR="%{$fg[green]%}"
CRUNCH_GIT_DIRTY_COLOR="%{$fg[red]%}"

case ${HOST} in
    *grimly*)
            if [ ${USER} = 'root' ]
            then
                PR_USER="[${CL_GREEN}%n${CL_NORMAL} @"
                PR_HOST=" ${CL_SPECIAL}%m${CL_NORMAL}] %# "
            elif [ ${USER} = 'rockyluke' ]
            then
                PR_USER="${CL_YELLOW}%n${CL_NORMAL}"
                PR_HOST=" ${CL_GREEN}%m${CL_NORMAL} %# "
            else
                PR_USER="%n"
                PR_HOST=" %m %#}"
            fi
            ;;
        *)
            if [ ${USER} = 'root' ]
            then
                PR_USER="[${CL_RED}%n${CL_NORMAL} @"
                PR_HOST=" ${CL_SPECIAL}%m${CL_NORMAL}] %# "
            elif [ ${USER} = 'rockyluke' ]
            then
                PR_USER="${CL_YELLOW}%n ● ${CL_NORMAL}"
                PR_HOST=" ${CL_RED}%m${CL_NORMAL} %# "
            else
                PR_USER="%n ● "
                PR_HOST="%m %h"
            fi
            ;;
esac

# These Git variables are used by the oh-my-zsh git_prompt_info helper:
ZSH_THEME_GIT_PROMPT_PREFIX="$CRUNCH_BRACKET_COLOR:$CRUNCH_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" $CRUNCH_GIT_CLEAN_COLOR✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $CRUNCH_GIT_DIRTY_COLOR✗"

# Our elements:
CRUNCH_TIME_="$CRUNCH_BRACKET_COLOR(${PR_USER}${PR_HOST}$CRUNCH_BRACKET_COLOR)%{$reset_color%}"
if which rvm-prompt &> /dev/null; then
  CRUNCH_RVM_="$CRUNCH_BRACKET_COLOR"["$CRUNCH_RVM_COLOR\${\$(~/.rvm/bin/rvm-prompt i v g)#ruby-}$CRUNCH_BRACKET_COLOR"]"%{$reset_color%}"
else
  if which rbenv &> /dev/null; then
    CRUNCH_RVM="$CRUNCH_BRACKET_COLOR"["$CRUNCH_RVM_COLOR\${\$(rbenv version | sed -e 's/ (set.*$//' -e 's/^ruby-//')}$CRUNCH_BRACKET_COLOR"]"%{$reset_color%}"
  fi
fi
CRUNCH_DIR_="$CRUNCH_DIR_COLOR%~\$(git_prompt_info) "
CRUNCH_PROMPT="$CRUNCH_BRACKET_COLOR➭ "

# Put it all together!
precmd() {
PROMPT="${CL_BROWN}%(!.#.❆)%{$reset_color%} $CRUNCH_DIR_$(hirakata romaji) $CRUNCH_PROMPT%{$reset_color%}"
}

RPROMPT="(%(?:${CL_BROWN}:${CL_RED})%T${CL_NORMAL})"

