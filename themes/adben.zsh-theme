#!/usr/bin/env zsh
# #
# # #README
# #
# # This theme provides two customizable header functionalities:
# # a) displaying a pseudo-random message from a database of quotations
# # (https://en.wikipedia.org/wiki/Fortune_%28Unix%29)
# # b) displaying randomly command line tips from The command line fu
# # (https://www.commandlinefu.com) community: in order to make use of this functionality
# # you will need Internet connection.
# # This theme provides as well information for the current user's context, like;
# # branch and status for the current version control system (git and svn currently
# # supported) and time, presented to the user in a non invasive volatile way.
# #
# # #REQUIREMENTS
# # This theme requires wget::
# # -Homebrew-osx- brew install wget
# # -Debian/Ubuntu- apt-get install wget
# # and fortune ::
# # -Homebrew-osx- brew install fortune
# # -Debian/Ubuntu- apt-get install fortune
# #
# # optionally:
# # -Oh-myzsh vcs plug-ins git and svn.
# # -Solarized theme (https://github.com/altercation/solarized/)
# # -OS X: iTerm 2 (https://iterm2.com/)
# # -font Source code pro (https://github.com/adobe/source-code-pro)
# #
# # This theme's look and feel is based on the Aaron Toponce's zsh theme, more info:
# # https://pthree.org/2008/11/23/727/
# # enjoy!

########## COLOR ###########
for COLOR in CYAN WHITE YELLOW MAGENTA BLACK BLUE RED DEFAULT GREEN GREY; do
  typeset -g PR_$COLOR="%b%{$fg[${(L)COLOR}]%}"
  typeset -g PR_BRIGHT_$COLOR="%B%{$fg[${(L)COLOR}]%}"
done
PR_RESET="%{$reset_color%}"

RED_START="${PR_GREY}<${PR_RED}<${PR_BRIGHT_RED}<${PR_RESET} "
RED_END="${PR_BRIGHT_RED}>${PR_RED}>${PR_GREY}>${PR_RESET} "
GREEN_START="${PR_GREY}>${PR_GREEN}>${PR_BRIGHT_GREEN}>${PR_RESET}"
GREEN_END="${PR_BRIGHT_GREEN}>${PR_GREEN}>${PR_GREY}>${PR_RESET} "

########## VCS ###########
VCS_DIRTY_COLOR="${PR_YELLOW}"
VCS_CLEAN_COLOR="${PR_GREEN}"
VCS_SUFFIX_COLOR="${PR_RED}› ${PR_RESET}"

########## SVN ###########
ZSH_THEME_SVN_PROMPT_PREFIX="${PR_RED}‹svn:"
ZSH_THEME_SVN_PROMPT_SUFFIX="${VCS_SUFFIX_COLOR}"
ZSH_THEME_SVN_PROMPT_DIRTY="${VCS_DIRTY_COLOR} ✘"
ZSH_THEME_SVN_PROMPT_CLEAN="${VCS_CLEAN_COLOR} ✔"

########## GIT ###########
ZSH_THEME_GIT_PROMPT_PREFIX="${PR_RED}‹git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="${VCS_SUFFIX_COLOR}"
ZSH_THEME_GIT_PROMPT_DIRTY="${VCS_DIRTY_COLOR} ✘"
ZSH_THEME_GIT_PROMPT_CLEAN="${VCS_CLEAN_COLOR} ✔"
ZSH_THEME_GIT_PROMPT_ADDED="${PR_YELLOW} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="${PR_YELLOW} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="${PR_YELLOW} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="${PR_YELLOW} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="${PR_YELLOW} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${PR_YELLOW} ✭"

# Get a fortune quote
ps1_fortune() {
  if (( ${+commands[fortune]} )); then
    fortune
  fi
}

# Obtain a command tip
ps1_command_tip() {
  {
    if (( ${+commands[wget]} )); then
      command wget -qO- https://www.commandlinefu.com/commands/random/plaintext
    elif (( ${+commands[curl]} )); then
      command curl -fsL https://www.commandlinefu.com/commands/random/plaintext
    fi
  } | sed '1d;/^$/d'
}

# Show prompt header (fortune / command tip)
prompt_header() {
  local header=$(
    case "${ENABLE_COMMAND_TIP:-}" in
    true) ps1_command_tip ;;
    *) ps1_fortune ;;
    esac
  )

  # Make sure to quote % so that they're not expanded by the prompt
  echo -n "${header:gs/%/%%}"
}

# Context: user@directory or just directory
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    echo -n "${PR_RESET}${PR_RED}%n@%m"
  fi
}

########## SETUP ###########

# Required for the prompt
setopt prompt_subst

# Prompt: header, context (user@host), directory
PROMPT="${RED_START}${PR_YELLOW}\$(prompt_header)${PR_RESET}
${RED_START}\$(prompt_context)${PR_BRIGHT_YELLOW}%~${PR_RESET}
${GREEN_START} "
# Right prompt: vcs status + time
RPROMPT="\$(git_prompt_info)\$(svn_prompt_info)${PR_YELLOW}%D{%R.%S %a %b %d %Y} ${GREEN_END}"
# Matching continuation prompt
PROMPT2="${GREEN_START} %_ ${GREEN_START} "
