# System clipboard integration
#
# This file has support for doing system clipboard copy and paste operations
# from the command line in a generic cross-platform fashion.
#
# This is uses essentially the same heuristic as neovim, with the additional
# special support for Cygwin.
# See: https://github.com/neovim/neovim/blob/e682d799fa3cf2e80a02d00c6ea874599d58f0e7/runtime/autoload/provider/clipboard.vim#L55-L121
#
# - pbcopy, pbpaste (macOS)
# - cygwin (Windows running Cygwin)
# - wl-copy, wl-paste (if $WAYLAND_DISPLAY is set)
# - xsel (if $DISPLAY is set)
# - xclip (if $DISPLAY is set)
# - lemonade (for SSH) https://github.com/pocke/lemonade
# - doitclient (for SSH) http://www.chiark.greenend.org.uk/~sgtatham/doit/
# - win32yank (Windows)
# - tmux (if $TMUX is set)
#
# Defines two functions, clipcopy and clippaste, based on the detected platform.
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
function detect-clipboard() {
  emulate -L zsh

  if [[ "${OSTYPE}" == darwin* ]] && (( ${+commands[pbcopy]} )) && (( ${+commands[pbpaste]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | pbcopy; }
    function clippaste() { pbpaste; }
  elif [[ "${OSTYPE}" == (cygwin|msys)* ]]; then
    function clipcopy() { cat "${1:-/dev/stdin}" > /dev/clipboard; }
    function clippaste() { cat /dev/clipboard; }
  elif (( $+commands[clip.exe] )) && (( $+commands[powershell.exe] )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | clip.exe; }
    function clippaste() { powershell.exe -noprofile -command Get-Clipboard; }
  elif [ -n "${WAYLAND_DISPLAY:-}" ] && (( ${+commands[wl-copy]} )) && (( ${+commands[wl-paste]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | wl-copy &>/dev/null &|; }
    function clippaste() { wl-paste --no-newline; }
  elif [ -n "${DISPLAY:-}" ] && (( ${+commands[xsel]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | xsel --clipboard --input; }
    function clippaste() { xsel --clipboard --output; }
  elif [ -n "${DISPLAY:-}" ] && (( ${+commands[xclip]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | xclip -selection clipboard -in &>/dev/null &|; }
    function clippaste() { xclip -out -selection clipboard; }
  elif (( ${+commands[lemonade]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | lemonade copy; }
    function clippaste() { lemonade paste; }
  elif (( ${+commands[doitclient]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | doitclient wclip; }
    function clippaste() { doitclient wclip -r; }
  elif (( ${+commands[win32yank]} )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | win32yank -i; }
    function clippaste() { win32yank -o; }
  elif [[ $OSTYPE == linux-android* ]] && (( $+commands[termux-clipboard-set] )); then
    function clipcopy() { cat "${1:-/dev/stdin}" | termux-clipboard-set; }
    function clippaste() { termux-clipboard-get; }
  elif [ -n "${TMUX:-}" ] && (( ${+commands[tmux]} )); then
    function clipcopy() { tmux load-buffer "${1:--}"; }
    function clippaste() { tmux save-buffer -; }
  else
    function _retry_clipboard_detection_or_fail() {
      local clipcmd="${1}"; shift
      if detect-clipboard; then
        "${clipcmd}" "$@"
      else
        print "${clipcmd}: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
        return 1
      fi
    }
    function clipcopy() { _retry_clipboard_detection_or_fail clipcopy "$@"; }
    function clippaste() { _retry_clipboard_detection_or_fail clippaste "$@"; }
    return 1
  fi
}

function clipcopy clippaste {
  unfunction clipcopy clippaste
  detect-clipboard || true # let one retry
  "$0" "$@"
}
