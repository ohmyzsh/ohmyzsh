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

CRUNCH_BRACKET_COLOR="%F{white}"
CRUNCH_TIME_COLOR="%F{yellow}"
CRUNCH_RVM_COLOR="%F{magenta}"
CRUNCH_DIR_COLOR="%F{cyan}"
CRUNCH_GIT_BRANCH_COLOR="%F{green}"
CRUNCH_GIT_CLEAN_COLOR="%F{green}"
CRUNCH_GIT_DIRTY_COLOR="%F{red}"

# These Git variables are used by the oh-my-zsh git_prompt_info helper:
ZSH_THEME_GIT_PROMPT_PREFIX="$CRUNCH_BRACKET_COLOR:$CRUNCH_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN=" $CRUNCH_GIT_CLEAN_COLOR✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $CRUNCH_GIT_DIRTY_COLOR✗"

# Our elements:
CRUNCH_TIME_="$CRUNCH_BRACKET_COLOR{$CRUNCH_TIME_COLOR%T$CRUNCH_BRACKET_COLOR}%f"
ZSH_THEME_RUBY_PROMPT_PREFIX="$CRUNCH_BRACKET_COLOR"["$CRUNCH_RVM_COLOR"
ZSH_THEME_RUBY_PROMPT_SUFFIX="$CRUNCH_BRACKET_COLOR"]"%f"
CRUNCH_RVM_='$(ruby_prompt_info)'
CRUNCH_DIR_="$CRUNCH_DIR_COLOR%~\$(git_prompt_info) "
CRUNCH_PROMPT="$CRUNCH_BRACKET_COLOR➭ "

# Put it all together!
PROMPT="$CRUNCH_TIME_$CRUNCH_RVM_$CRUNCH_DIR_$CRUNCH_PROMPT%f"
