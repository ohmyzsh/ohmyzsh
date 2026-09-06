# Don't skip this file until a Zsh release does the necessary quoting.
# This is because even though 5.8.1 undid recursive prompt_subst inside
# prompt sequences, % characters in relevant fields will still be rendered
# incorrectly in vcs_info, on all Zsh releases up to writing this.
#
# There is no release yet that does this right, since it requires changing
# how what vcs_info hooks expect to receive. Even so, I'd rather be correct
# and break custom vcs_info hooks than have a broken prompt.

# Quote necessary $hook_com[<field>] items just before they are used
# in the line "VCS_INFO_hook 'post-backend'" of the VCS_INFO_formats
# function, where <field> is:
#
#   base:       the full path of the repository's root directory.
#   base-name:  the name of the repository's root directory.
#   branch:     the name of the currently checked out branch.
#   misc:       a string that may contain anything the vcs_info backend wants.
#   revision:   an identifier of the currently checked out revision.
#   subdir:     the path of the current directory relative to the
#               repository's root directory.
#
# This patch %-quotes these fields previous to their use in vcs_info hooks and
# the zformat call and, eventually, when they get expanded in the prompt.
# It's important to quote these here, and not later after hooks have modified the
# fields, because then we could be quoting % characters from valid prompt sequences,
# like %F{color}, %B, etc.
#
#  32   │ hook_com[subdir]="$(VCS_INFO_reposub ${hook_com[base]})"
#  33   │ hook_com[subdir_orig]="${hook_com[subdir]}"
#  34   │
#  35 + │ for tmp in base base-name branch misc revision subdir; do
#  36 + │     hook_com[$tmp]="${hook_com[$tmp]//\%/%%}"
#  37 + │ done
#  38 + │
#  39   │ VCS_INFO_hook 'post-backend'
#
# This is especially important so that no command substitution is performed
# due to malicious input as a consequence of CVE-2021-45444, which affects
# zsh versions from 5.0.3 to 5.8.
#
# The patch is applied when VCS_INFO_formats is first called, since loading
# and patching it on every startup costs time in shells that never use
# vcs_info. `autoload` doesn't replace an already defined function, so this
# wrapper survives a later `autoload -Uz vcs_info` in a theme or .zshrc, and
# vcs_info's own `autoload -Uz VCS_INFO_formats`.
function VCS_INFO_formats {
  unfunction VCS_INFO_formats
  autoload -Uz +X regexp-replace VCS_INFO_formats 2>/dev/null || return 1

  # We use $tmp here because it's already a local variable in VCS_INFO_formats
  local PATCH='for tmp (base base-name branch misc revision subdir) hook_com[$tmp]="${hook_com[$tmp]//\%/%%}"'
  # Unique string to avoid reapplying the patch if this code gets called twice
  local PATCH_ID=vcs_info-patch-9b9840f2-91e5-4471-af84-9e9a0dc68c1b
  # Only patch the VCS_INFO_formats function if not already patched
  if [[ "$functions[VCS_INFO_formats]" != *$PATCH_ID* ]]; then
    regexp-replace 'functions[VCS_INFO_formats]' \
      "VCS_INFO_hook 'post-backend'" \
      ': ${PATCH_ID}; ${PATCH}; ${MATCH}'
  fi

  VCS_INFO_formats "$@"
}
