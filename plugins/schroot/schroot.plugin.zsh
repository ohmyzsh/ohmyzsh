###################################################################
# Show current schroot
#
# Author:
# https://github.com/fshp
#
# You need modify theme
# The theme can be obtained here:
# https://github.com/fshp/schroot.zsh-theme
###################################################################

function schroot_prompt_info() {
  if [ -n "$SCHROOT_CHROOT_NAME" ]; then
    echo "${ZSH_THEME_SCHROOT_PROMPT_PREFIX}${SCHROOT_CHROOT_NAME}${ZSH_THEME_SCHROOT_PROMPT_SUFFIX}"
  fi
}
