# System clipboard integration
#
# This file has support for doing system clipboard copy and paste operations
# from the command line in a generic cross-platform fashion.
#
# Defines two functions, clipcopy and clippaste, based on the detected platform.
# Additionally provides two management functions:
#   - clipboard-list: Lists the available clipboard drivers by name.
#   - clipboard-detect: Detects and sets the best clipboard available.
#   - clipboard-set: Sets the clipboard by name. (For example, "clipboard-set xclip").
#
# Users may set the array variable `ZSH_CLIPBOARDS` to their preferred list of
# drivers to try. By default, the each of the following are tried in order:
#
# - macos: Uses pbcopy and pbpaste on macOS
# - cygwin: Cygwin on Windows uses /dev/clipboard
# - wayland: Uses wl-copy, wl-paste (if $WAYLAND_DISPLAY is set)
# - xclip: If $DISPLAY is set
# - xsel: If $DISPLAY is set
# - lemonade: For SSH. See https://github.com/pocke/lemonade
# - doitclient: For SSH. See http://www.chiark.greenend.org.uk/~sgtatham/doit/
# - win32yank: If available, for Windows.
# - termux: For Android linux
# - tmux: Uses tmux's copy-buffer/save-buffer if $TMUX is set.
# - powershell: For Windows
# - file: Saves/loads the clipboard from a file. Uses ZSH_CLIPBOARD_FILENAME if provided.
# - var: Saves/loads the clipboard to an environment variable.
# - dummy: Empty source/sink. Copies to /dev/null and always pastes empty.
#
# The default list is essentially the same heuristic as neovim.
# See: https://github.com/neovim/neovim/blob/e682d799fa3cf2e80a02d00c6ea874599d58f0e7/runtime/autoload/provider/clipboard.vim#L55-L121
#
##
#
# clipcopy - Copy data to clipboard
#
# Usage:
#
#  <command> | clipcopy    - copies stdin to clipboard
#
#  clipcopy <file>         - copies a file's contents to clipboard
#
##
#
# clippaste - "Paste" data from clipboard to stdout
#
# Usage:
#
#   clippaste   - writes clipboard's contents to stdout
#
#   clippaste | <command>    - pastes contents and pipes it to another process
#
#   clippaste > <file>      - paste contents to a file
#
# Examples:
#
#   # Pipe to another process
#   clippaste | grep foo
#
#   # Paste to a file
#   clippaste > file.txt
#
##

# CLIPBOARD DEFINITIONS {{
#
# Each clipboard type defines a set of functions prefixed
# with '__omz_clipboard_${name}_…'.
#
# Those functions comform to the following interface:
#   available: Return 0 if the clipboard is available, otherwise non-zero.
#   clipcopy: Read into clipboard from either the first argument as filename, or stdin.
#   clippaste: Write the current clipboard contents to stdout.
# and optionally:
#   setup: Prepare to use the clipboard.
#   teardown: Clean up anything related to the use of the clipboard.
#
typeset -ag __omz_all_clipboards
__omz_all_clipboards=()

## clipboard: macos {{
__omz_all_clipboards+=(macos)
function __omz_clipboard_macos_available() { [[ "${OSTYPE}" == darwin* ]] && (( ${+commands[pbcopy]} )) && (( ${+commands[pbpaste]} )); }
function __omz_clipboard_macos_clipcopy() { pbcopy < "${1:-/dev/stdin}"; }
function __omz_clipboard_macos_clippaste() { pbpaste; }
# }}

## clipboard: cygwin {{
__omz_all_clipboards+=(cygwin)
function __omz_clipboard_cygwin_available() { [[ "${OSTYPE}" == cygwin* ]]; }
function __omz_clipboard_cygwin_clipcopy() { cat "${1:-/dev/stdin}" > /dev/clipboard; }
function __omz_clipboard_cygwin_clippaste() { cat /dev/clipboard; }
# }}

## clipboard: wayland {{
__omz_all_clipboards+=(wayland)
function __omz_clipboard_wayland_available() { [ -n "${WAYLAND_DISPLAY:-}" ] && (( ${+commands[wl-copy]} )) && (( ${+commands[wl-paste]} )); }
function __omz_clipboard_wayland_clipcopy() { wl-copy < "${1:-/dev/stdin}"; }
function __omz_clipboard_wayland_clippaste() { wl-paste; }
# }}

## clipboard: xclip {{
__omz_all_clipboards+=(xclip)
function __omz_clipboard_xclip_available() { [ -n "${DISPLAY:-}" ] && (( ${+commands[xclip]} )); }
function __omz_clipboard_xclip_clipcopy() { xclip -in -selection clipboard < "${1:-/dev/stdin}"; }
function __omz_clipboard_xclip_clippaste() { xclip -out -selection clipboard; }
# }}

## clipboard: xsel {{
__omz_all_clipboards+=(xsel)
function __omz_clipboard_xsel_available() { [ -n "${DISPLAY:-}" ] && (( ${+commands[xsel]} )); }
function __omz_clipboard_xsel_clipcopy() { xsel --clipboard --input < "${1:-/dev/stdin}"; }
function __omz_clipboard_xsel_clippaste() { xsel --clipboard --output; }
# }}

## clipboard: lemonade {{
__omz_all_clipboards+=(lemonade)
function __omz_clipboard_lemonade_available() { (( ${+commands[lemonade]} )); }
function __omz_clipboard_lemonade_clipcopy() { lemonade copy < "${1:-/dev/stdin}"; }
function __omz_clipboard_lemonade_clippaste() { lemonade paste; }
# }}

## clipboard: doitclient {{
__omz_all_clipboards+=(doitclient)
function __omz_clipboard_doitclient_available() { (( ${+commands[doitclient]} )); }
function __omz_clipboard_doitclient_clipcopy() { doitclient wclip < "${1:-/dev/stdin}"; }
function __omz_clipboard_doitclient_clippaste() { doitclient wclip -r; }
# }}

## clipboard: win32yank {{
__omz_all_clipboards+=(win32yank)
function __omz_clipboard_win32yank_available() { (( ${+commands[win32yank]} )); }
function __omz_clipboard_win32yank_clipcopy() { win32yank -i < "${1:-/dev/stdin}"; }
function __omz_clipboard_win32yank_clippaste() { win32yank -o; }
# }}

## clipboard: termux {{
__omz_all_clipboards+=(termux)
function __omz_clipboard_termux_available() { [[ $OSTYPE == linux-android* ]] && (( ${+commands[termux-clipboard-set]} )); }
function __omz_clipboard_termux_clipcopy() { termux-clipboard-set "${1:-/dev/stdin}"; }
function __omz_clipboard_termux_clippaste() { termux-clipboard-get; }
# }}

## clipboard: tmux {{
__omz_all_clipboards+=(tmux)
function __omz_clipboard_tmux_available() { [ -n "${TMUX:-}" ] && (( ${+commands[tmux]} )); }
function __omz_clipboard_tmux_clipcopy() { tmux load-buffer "${1:--}"; }
function __omz_clipboard_tmux_clippaste() { tmux save-buffer -; }
# }}

## clipboard: powershell {{
__omz_all_clipboards+=(powershell)
function __omz_clipboard_powershell_available() { [[ "$(uname -r)" == *icrosoft* ]]; }
function __omz_clipboard_powershell_clipcopy() { clip.exe < "${1:-/dev/stdin}"; }
function __omz_clipboard_powershell_clippaste() { powershell.exe -noprofile -command Get-Clipboard; }
# }}

## clipboard: file {{
# Copy/paste into a file.
#
# User may set `ZSH_CLIPBOARD_FILENAME` to a filename. Otherwise, a tempfile is
# created which gets cleaned up when the shell exits.
__omz_all_clipboards+=(file)
function __omz_clipboard_file_available() { return 0; }
function __omz_clipboard_file_clipcopy() { cat "${1:-/dev/stdin}" > "${ZSH_CLIPBOARD_FILENAME}"; }
function __omz_clipboard_file_clippaste() { cat "${ZSH_CLIPBOARD_FILENAME}"; }
function __omz_clipboard_file_setup() {
  # This filename may be inherited from a parent shell,
  # or the user may have set it manually to share it between shells.
  typeset -gx ZSH_CLIPBOARD_FILENAME

  # But if it didn't exist, we'll create a temporary file and clean it up on exit.
  if [ -z "${ZSH_CLIPBOARD_FILENAME:-}" ]; then
    if [ -z "${__omz_clipboard_file:-}" ]; then
      autoload -U add-zsh-hook

      # NOTE: This is not exported. That way we can be sure *we* created it.
      __omz_clipboard_file="$(mktemp -t omz-clipboard-${USER}.XXXXXXX)"
      typeset -rg __omz_clipboard_file

      # NOTE: This is done at zshexit instead of teardown (like if switching
      # clipboards), so that subshells may continue to use the file as long
      # as the parent shell is alive.
      function __omz_cleanup_file_clipboard() { rm -f "${__omz_clipboard_file}"; }
      add-zsh-hook zshexit __omz_cleanup_file_clipboard
    fi

    ZSH_CLIPBOARD_FILENAME="${__omz_clipboard_file}"
  fi
}
# }}

## clipboard: var {{
# Copy/paste into an environment variable. Fine for local copies/pastes in vi-mode.
__omz_all_clipboards+=(var)
function __omz_clipboard_var_available() { return 0; }
function __omz_clipboard_var_clipcopy() { ZSH_CLIPBOARD_CONTENTS="$(< "${1:-/dev/stdin}")"; }
function __omz_clipboard_var_clippaste() { printf %s "${ZSH_CLIPBOARD_CONTENTS:-}"; }
function __omz_clipboard_var_setup() { typeset -gx ZSH_CLIPBOARD_CONTENTS; }
function __omz_clipboard_var_teardown() { unset ZSH_CLIPBOARD_CONTENTS; }
# }}

## clipboard: null {{
# Copy into /dev/null, and always paste nothing. Safe, available everywhere, pretty useless.
__omz_all_clipboards+=(null)
function __omz_clipboard_null_available() { return 0; }
function __omz_clipboard_null_clipcopy() { cat "${1:-/dev/stdin}" > /dev/null; }
function __omz_clipboard_null_clippaste() { print ''; }
# }}

typeset -rg __omz_all_clipboards
# }}

## STATE MANAGEMENT {{
#
# NOTE: Users should not set this variable directly. Instead they should use `set-clipboard`.
typeset -gx ZSH_CLIPBOARD

# If we're a sub-shell inheriting a clipboard, don't attempt to do things like
# clean up the temp files.
__omz_parent_shell_clipboard="${ZSH_CLIPBOARD:-}"
typeset -rg __omz_parent_shell_clipboard

function clipcopy() { "__omz_clipboard_${ZSH_CLIPBOARD:-null}_clipcopy" "$@"; }
function clippaste() { "__omz_clipboard_${ZSH_CLIPBOARD:-null}_clippaste" "$@"; }

# Set the current clipboard driver, handling any setup or teardown.
function clipboard-set() {
  emulate -L zsh

  # If setting to the same as current clipboard, do nothing.
  if [ "${1}" = "${ZSH_CLIPBOARD:-}" ]; then
    return 0
  # Make sure we're setting to a clipboard that we deem available.
  elif ! typeset -f "__omz_clipboard_${1}_available" >/dev/null 2>&1; then
    print "Clipboard ${1} is not known clipboard driver" >&2
    return 1
  elif ! "__omz_clipboard_${1}_available"; then
    print "Clipboard ${1} does not appear to be available on this platform" >&2
    return 1
  # Run the existing clipboard's teardown, if there is one.
  # Avoid tearing down an inherited clipboard.
  elif [ -n "${ZSH_CLIPBOARD:-}" ] \
    && [ "${ZSH_CLIPBOARD}" != "${__omz_parent_shell_clipboard:-}" ] \
    && typeset -f "__omz_clipboard_${ZSH_CLIPBOARD}_teardown" > /dev/null 2>&1; then
      "__omz_clipboard_${ZSH_CLIPBOARD}_teardown"
  fi

  # Run the new clipboard's setup, if there is one.
  # Does not try to reinitialize an inherited clipboard.
  if [ "${1}" != "${__omz_parent_shell_clipboard:-}" ] \
    && typeset -f "__omz_clipboard_${1}_setup" > /dev/null 2>&1; then
      "__omz_clipboard_${1}_setup"
  fi

  # Track the new current clipboard as this new one, which will by used by
  # clipcopy and clippaste.
  ZSH_CLIPBOARD="${1}"
}
# }}

## AUTODETECTION {{
#
# If the user did not define their preferred list of ZSH_CLIPBOARDS,
# default to trying every available clipboard type, in the reasonable order
# defined above.
#
if ! (( ${+ZSH_CLIPBOARDS} )); then
  typeset -ag ZSH_CLIPBOARDS
  ZSH_CLIPBOARDS=("${__omz_all_clipboards[@]}")
fi

# Attempt to detect and set up the "best" clipboard to use.
# Respects the user variable ZSH_CLIPBOARDS, but ensures that 'null' is used if
# nothing else succeeds.
function clipboard-detect() {
  for c in "${ZSH_CLIPBOARDS[@]}"; do
    if typeset -f "__omz_clipboard_${c}_available" >/dev/null 2>&1 \
      && "__omz_clipboard_${c}_available" \
      && clipboard-set "${c}"; then
        return 0
    fi
    # Otherwise, try the next one.
  done

  # Last resort; clipcopy and clippaste are defined with no-op sources/sinks:
  clipboard-set dummy
  return 1
}

# If `ZSH_CLIPBOARD` is already set while we're loading this module, we may be
# in a subshell and detection and setup has already occurred. Either that, or
# the user *really* wants to use this one.
#
# Either way, we only want to run initial detection if that variable is has not
# already been set.
if [ -z "${ZSH_CLIPBOARD:-}" ]; then
  # Detect at startup. A non-zero exit here indicates that the dummy clipboards
  # were set, which is not really an error.
  clipboard-detect || true
fi

# }}

# List all available clipboard drivers. Just a helpful user command.
function clipboard-list() {
  for c in "${__omz_all_clipboards[@]}"; do
    if "__omz_clipboard_${c}_available"; then
      print "${c}"
    fi
  done
}
