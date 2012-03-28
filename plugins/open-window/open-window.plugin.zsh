############################################################################
# Open current directory in a file browser. Supports the following:
#
#   * Explorer (Windows)
#   * Explorer from Cygwin (Windows)
#   * Finder (OS X)
#   * Nautilus (Gnome)
#   * Konqueror (KDE)
#
# Suggested use: bind open-current-window to a key so you can quickly
# pop open the current directory. I don't use backward-kill-word, so ^W
# works well for me:
#
#   bindkey '^w' open-current-window
#
# The open-window function relies on OS-specific utilities that can open
# more than just a file browser. Capabilities vary from system to system,
# but most are designed to open the argument in whatever the system thinks
# is the best program for the job, usually by MIME type. URLs will also
# open in the default web browser.
#
# To use open-window on its own, your best bet is to alias it:
#
#   alias o=open-window
############################################################################

open-window()
{
  if (( $+commands[start] )) ; then
    start $1
  elif (( $+commands[cmd] )) ; then
    # Cygwin can't directly run start from its bash prompt; use cmd shell
    cmd /C start $1
  elif (( $+commands[gnome-open] )) ; then
    gnome-open $1
  elif (( $+commands[kde-open] )) ; then
    kde-open $1
  elif (( $+commands[xdg-open] )) ; then
    # Fallback that may or may not work on oddball Linux distros
    xdg-open $1
  elif (( $+commands[open] )); then
    open $1
  else
    echo "No file browser found"
  fi
}

open-current-window()
{
  open-window .
}
zle -N open-current-window
