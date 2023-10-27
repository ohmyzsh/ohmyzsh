#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
#          FILE: redoracle.zsh-theme
#   DESCRIPTION: A sleek, futuristic yet insightful theme
#        AUTHOR: Redoracle (info[at]redoracle.com)
#       VERSION: 1.0.0
#       DEPENDS: None
#    RECOMMENDS: Powerline fonts
#
# The redoracle theme is an evolution of the gnzh theme, infused with a modern 
# futuristic touch while maintaining a clean, polished appearance. It's meticulously
# designed to deliver a comprehensive overview of vital information right at the 
# prompt, yet keeping a minimalist and sleek demeanor.
#
# The theme elegantly unfolds the current time, user and host data, and the current 
# directory in a structured, visually delineated manner. For the developer fraternity,
# it seamlessly integrates Node Version Manager (NVM) and Git branch data, ensuring 
# an effortless tracking of the working milieu.
#
# For the superuser (root), the prompt subtly transitions to a cautionary red hue 
# signaling elevated privileges, thereby fostering operational awareness.
#
# In the realm of SSH login, the hostname adopts a red coloration as a gentle reminder 
# of remote operation, ensuring the user's contextual awareness is never compromised.
#
# The theme is adept at showcasing the return code of the preceding failed command,
# facilitating swift troubleshooting without disrupting the command flow.
#
# A notable feature is the intuitive formatting of Git branch data. The prompt 
# adopts a red coloration in the presence of modified files, and transitions to green 
# for staged files, delivering a lucid visual indication of the repo status.
#
# The right-hand side of the prompt is dedicated to displaying the return code 
# of the last command, providing immediate feedback on command execution status.
#
# The redoracle theme embodies adaptability with simple modifications in the script,
# empowering users to fine-tune colors, formatting, and displayed information to 
# resonate with personal preferences or specific operational scenarios.
#
# The redoracle theme is a harmonious amalgamation of aesthetics, functionality, and 
# informational clarity, designed to elevate the ZSH terminal experience for both 
# casual users and seasoned developers.
# ------------------------------------------------------------------------------

# Set the option to expand prompts before displaying them, allowing dynamic updates
setopt prompt_subst

# Function to get the emoji for the prompt
emotty() {
  # You can replace the below line with a line that gets an emoji based on tty or any other logic
  echo "👺"
}

# Define the function to build the prompt
build_prompt() {
  # Declare local variables to store user, user operation, prompt, and host info
  local PR_USER PR_USER_OP PR_PROMPT PR_HOST

  # Get the emoji for the prompt
  local prompt_emoji="$(emotty)"

  # Format the current time to display in yellow and red colors
  local REDORACLE_CURRENT_TIME_="%{$fg[yellow]%}%{$fg[red]%}%D %T%{$fg[yellow]%}%{$reset_color%}"

  # Format the return code to display in red if it's non-zero
  local return_code="%(?..%F{red}%? ↵%f)"

  # Check the UID to determine if the user is normal or root
  if [[ $UID -ne 0 ]]; then # Normal user
    PR_USER='%F{green}%n%f'  # Format username in green
    PR_USER_OP='%F{green}%#%f'  # Format user operation symbol in green
    PR_PROMPT="%f${prompt_emoji} %f"  # Set the prompt symbol for normal user
  else # Root user
    PR_USER='%F{red}%n%f'  # Format username in red for root
    PR_USER_OP='%F{red}%#%f'  # Format user operation symbol in red for root
    PR_PROMPT="%f${prompt_emoji} %f"  # Set the prompt symbol for root in red
  fi

  # Check if we are on SSH or not
  if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
    PR_HOST='%F{red}%M%f' # Format hostname in red if on SSH
  else
    PR_HOST='%F{green}%m%f' # Format hostname in green if not on SSH
  fi

  # Concatenate user and host info
  local user_host="${PR_USER}%F{cyan}@${PR_HOST}"

  # Format the current directory info
  local current_dir="%B%F{blue}%~%f%b"

  # Get the git branch info
  local git_branch='$(git_prompt_info)'

  # Set the left-hand side of the prompt with various info
  PROMPT="
%F{red}╭─%f $REDORACLE_CURRENT_TIME_ ${user_host} ${current_dir} $(nvm_prompt_info) ${git_branch}
%F{red}╰─%f$PR_PROMPT"

  # Set the right-hand side of the prompt with return code
  RPROMPT="${return_code}"

  # Set Git prompt prefix and suffix
  ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
  ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"

  # Set Ruby prompt prefix and suffix
  ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
  ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"
}

build_prompt  # Call the function to set the prompt, initializing the prompt with the defined settings
