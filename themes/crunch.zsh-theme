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

CRUNCH_BRACKET_COLOR="%{$fg[white]%}"
CRUNCH_TIME_COLOR="%{$fg[yellow]%}"
CRUNCH_RVM_COLOR="%{$fg[magenta]%}"
CRUNCH_DIR_COLOR="%{$fg[cyan]%}"
CRUNCH_GIT_BRANCH_COLOR="%{$fg[green]%}"
CRUNCH_GIT_CLEAN_COLOR="%{$fg[green]%}"
CRUNCH_GIT_DIRTY_COLOR="%{$fg[red]%}"

# These Git variables are used by the oh-my-zsh git_prompt_info helper:
ZSH_THEME_GIT_PROMPT_PREFIX="$CRUNCH_BRACKET_COLOR:$CRUNCH_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" $CRUNCH_GIT_CLEAN_COLOR✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $CRUNCH_GIT_DIRTY_COLOR✗"

# Intelligently show Ruby version if the 'rbenv' or 'rvm' plugins are active.
for plugin ($plugins); do
  if [[ $plugin = 'rvm' ]]; then
    CRUNCH_RUBY_VERSION="\${\$(rvm-prompt i v g)#ruby-}"
  elif [[ $plugin = 'rbenv' ]]; then
    CRUNCH_RUBY_VERSION="\${\$(rbenv_prompt_info)%%-*}"
  fi
done

# Our elements:
CRUNCH_TIME_="$CRUNCH_BRACKET_COLOR{$CRUNCH_TIME_COLOR%T$CRUNCH_BRACKET_COLOR}%{$reset_color%}"
if [[ -n $CRUNCH_RUBY_VERSION ]]; then
  CRUNCH_RUBY_="$CRUNCH_BRACKET_COLOR"["$CRUNCH_RVM_COLOR$CRUNCH_RUBY_VERSION$CRUNCH_BRACKET_COLOR"]"%{$reset_color%}"
fi
CRUNCH_DIR_="$CRUNCH_DIR_COLOR%~\$(git_prompt_info) "
CRUNCH_PROMPT="$CRUNCH_BRACKET_COLOR➭ "

# Put it all together!
PROMPT="$CRUNCH_TIME_$CRUNCH_RUBY_$CRUNCH_DIR_$CRUNCH_PROMPT%{$reset_color%}"
