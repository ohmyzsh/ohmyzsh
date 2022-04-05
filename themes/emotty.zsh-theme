#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
#          FILE: emotty.zsh-theme
#   DESCRIPTION: A varying emoji based theme
#        AUTHOR: Alexis Hildebrandt (afh[at]surryhill.net)
#       VERSION: 1.0.0
#       DEPENDS: emotty plugin
#    RECOMMENDS: Hasklig font
#
# This theme shows a different emoji for each tty at the main prompt.
#
# There are pre-defined different emoji sets to choose from, e.g.:
# emoji, stellar, floral, zodiac, love (see emotty plugin).
# 
# To choose a different emotty set than the default (emoji)
# % export emotty_set=nature
#
# For the superuser (root) this theme shows a designated indicator
# and switches the foreground color to red
# (see root_prompt variable, default: skull).
# But you are using sudo (8) instead of designated a root shell, right‽
#
# When logged in via SSH the main prompt also shows the user- and hostname.
#
# The exit status of the last failed command is displayed in the window title
# along with an indicator (see warn_glyph variable, default: collision symbol).
# To clear it just run: $NULL, true or :
#
# The right prompt shows the current working directory (3 levels up) in cyan.
#
# When in a git repository the main prompt shows the current branch name
# with a branch indicator in yellow
# (see vcs_branch_glyph variable, default: Hasklig branch glyph).
#
# If there are modified files the prompt switches to red and shows an unstaged
# indicator (see vcs_unstaged_glyph variable, default: circled letter M).
#
# If there are staged files the prompt switches to green and shows an staged
# indicator (see vcs_staged_glyph variable, default: high voltage sign).
#
# In a git repository the right prompt shows the repository name in bold and
# prepends the current working directory subpath within the repository.
#
# When git currently performs an action such as merge or rebase, the action is
# displayed in red instead of the branch name and a special action indicator
# is shown (see vcs_action_glyph variable, default: chevron).
# ------------------------------------------------------------------------------

(( ${+functions[emotty]} )) || {
  echo "error: the emotty theme requires the emotty plugin" >&2
  return 1
}

(( ${+emoji} )) || {
  echo "error: the emotty theme requires the emoji plugin" >&2
  return 1
}

user_prompt="$(emotty)"
root_prompt="$emoji[skull]"
warn_prompt="$emoji[collision_symbol]"

vcs_unstaged_glyph="%{$emoji[circled_latin_capital_letter_m]$emoji2[emoji_style] %2G%}"
vcs_staged_glyph="%{$emoji[high_voltage_sign]%2G%}"
vcs_branch_glyph=$'\Ue0a0' # 
vcs_action_glyph=$'\U276f' # ❯

red="$FG[001]"
yellow="$FG[003]"
green="$FG[002]"
cyan="$FG[014]"

prompt_glyph="%{%(#.${root_prompt}.${user_prompt}) %2G%}"

# Uncomment the next line if you also like to see the warn_prompt in the prompt on the right.
#last_command_failed="%(?.. %F{red}%1{${warn_prompt} %1G%}%?%f)"


setopt promptsubst

# Workaround for zsh 5.2 release (kudos to @timothybasanov)
autoload +X VCS_INFO_nvcsformats
functions[VCS_INFO_nvcsformats]=${functions[VCS_INFO_nvcsformats]/local -a msgs/}

autoload -U add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git #hg svn cvs
zstyle ':vcs_info:*' get-revision false
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr "${red}${vcs_unstaged_glyph}"
zstyle ':vcs_info:*' stagedstr "${green}${vcs_staged_glyph}"

# %(K|F){color} set (back|fore)ground color
# %(k|f) reset (back|fore)ground color
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' nvcsformats "${prompt_glyph}" '%3~' ''
zstyle ':vcs_info:*' formats "${yellow}%u%c%b${vcs_branch_glyph}%f" '%S|' "$FX[bold]%r$FX[no-bold]" 
zstyle ':vcs_info:*' actionformats "${red}%K{white}%a${vcs_action_glyph}%k%f" '%S|' "$FX[bold]%r$FX[no-bold]"

red_if_root="%(!.%F{red}.)"
sshuser_on_host="${SSH_TTY:+%(!.$red.$yellow)%n@%m$reset_color}"

PROMPT='${sshuser_on_host}${vcs_info_msg_0_}${red_if_root} '
RPROMPT='${cyan}${vcs_info_msg_1_##.|}${vcs_info_msg_2_}%f${last_command_failed}'

emotty_title() {
  title "${${?/[^0]*/$warn_prompt $?}/0/${prompt_glyph}}"
}
add-zsh-hook precmd emotty_title
add-zsh-hook precmd vcs_info

# vim:ft=zsh ts=2 sw=2 sts=2
