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
# - OSC52 (for SSH/remote terminals) https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Operating-System-Commands
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
# Check if terminal supports OSC52 escape sequences for clipboard operations
# OSC52 allows copying to clipboard through terminal escape sequences, useful for SSH sessions
function _osc52_supported() {
  emulate -L zsh
  
  # Check for known OSC52-capable terminals
  # iTerm2, WezTerm, foot, Alacritty, and many modern terminals support OSC52
  [[ -n "${ITERM_SESSION_ID:-}" ]] && return 0
  [[ -n "${WEZTERM_PANE:-}" ]] && return 0
  [[ "$TERM" =~ ^(foot|alacritty|kitty|rxvt-unicode|xterm) ]] && return 0
  
  # Check if we're in a terminal that likely supports OSC52
  # Most modern terminals support it, but we'll be conservative
  [[ -t 1 ]] && [[ -n "${TERM:-}" ]] && return 0
  
  return 1
}

# Copy to clipboard using OSC52 escape sequence
# OSC52 format: \033]52;c;<base64-data>\033\\
function _osc52_copy() {
  emulate -L zsh
  
  # Read input (file or stdin)
  local input="${1:-/dev/stdin}"
  local data
  data=$(cat "$input" 2>/dev/null)
  
  if [[ -z "$data" ]]; then
    return 1
  fi
  
  # Base64 encode the data
  # base64 command is standard on most Unix-like systems
  local base64_data
  if (( ${+commands[base64]} )); then
    base64_data=$(printf '%s' "$data" | base64 | tr -d '\n')
  elif (( ${+commands[python3]} )); then
    base64_data=$(printf '%s' "$data" | python3 -m base64 2>/dev/null | tr -d '\n')
  elif (( ${+commands[python]} )); then
    base64_data=$(printf '%s' "$data" | python -m base64 2>/dev/null | tr -d '\n')
  else
    print "osc52: base64 encoder not found" >&2
    return 1
  fi
  
  if [[ -z "$base64_data" ]]; then
    return 1
  fi
  
  # Send OSC52 escape sequence to terminal
  printf '\033]52;c;%s\033\\' "$base64_data"
}

# Paste from clipboard using OSC52 escape sequence
# Note: Paste support is less common than copy support
function _osc52_paste() {
  emulate -L zsh
  
  # Query clipboard using OSC52
  # Format: \033]52;c;?\033\\
  printf '\033]52;c;?\033\\'
  
  # Note: Most terminals don't support OSC52 paste queries reliably
  # This is a best-effort implementation
  # The terminal would need to respond with the clipboard content
  # For now, we'll return an error to fall back to other methods
  return 1
}

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
  elif _osc52_supported; then
    # OSC52 clipboard support for SSH/remote terminals
    # Copy works reliably in most modern terminals (iTerm2, WezTerm, foot, Alacritty, etc.)
    # Paste support is limited - most terminals don't support OSC52 paste queries reliably
    function clipcopy() { _osc52_copy "${1:-/dev/stdin}"; }
    function clippaste() { 
      # OSC52 paste query support is unreliable across terminals
      # For now, we don't implement paste via OSC52 as it's not widely supported
      # Users can use other methods (tmux, terminal-specific paste) for pasting
      print "clippaste: OSC52 paste not supported. Try tmux or terminal-specific paste." >&2
      return 1
    }
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
