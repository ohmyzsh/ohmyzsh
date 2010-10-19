# Use the following within your prompt
#   ${vcs_info_msg_0_}
#
# The style of vcs_info can be tweaked within a theme by modifying the output
# using zstyle.
#
# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#IDX2133
#
autoload -Uz vcs_info

precmd() {
  vcs_info
}
