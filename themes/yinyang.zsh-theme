# YinYang - Chi-ful zshing
# Mostly copied form the great Crunch and Dallas theme. Thank you guys a lot!
#
# Displays as little information as possible while maintaining a good overview of what is going on:
# * The RVM version and gemset (omitting the 'ruby' name if it's MRI)
# * The current directory
# * The Git branch and its 'dirty' state

YINYANG_BRACKET_COLOR="%{$reset_color%}"
YINYANG_RVM_COLOR="%{$fg[red]%}"
YINYANG_DIR_COLOR="%{$fg[cyan]%}"
YINYANG_GIT_BRANCH_COLOR="%{$fg[green]%}"
YINYANG_GIT_CLEAN_COLOR="%{$fg[green]%}"
YINYANG_GIT_DIRTY_COLOR="%{$fg[red]%}"

if which rvm-prompt &> /dev/null; then
  YINYANG_RVM_="$YINYANG_RVM_COLOR\${\$(~/.rvm/bin/rvm-prompt i v g)#ruby-}%{$reset_color%}"
else
  if which rbenv &> /dev/null; then
    YINYANG_RVM_="$YINYANG_RVM_COLOR\${\$(rbenv version | sed -e 's/ (set.*$//' -e 's/^ruby-//')}%{$reset_color%}"
  fi
fi

ZSH_THEME_GIT_PROMPT_PREFIX=" $YINYANG_BRACKET_COLOR($YINYANG_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YINYANG_BRACKET_COLOR)"
ZSH_THEME_GIT_PROMPT_CLEAN=" $YINYANG_GIT_CLEAN_COLOR✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $YINYANG_GIT_DIRTY_COLOR✗"

PROMPT="$YINYANG_RVM_\$(git_prompt_info) $YINYANG_DIR_COLOR%c%{$reset_color%} ☯  "
