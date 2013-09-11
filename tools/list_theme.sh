#!/bin/zsh
# list_theme is list the feature which theme provides
# usage: list_theme.sh [theme_dir]
# @author Daniel YC Lin <dlin.tw at gmail>
#
# eg.
#   list_theme.sh | tee list
#   cat list | grep git | grep tty  # filter what you want
#   . theme/foo.zsh-theme # try the theme
#   copy foo.zsh-theme bar.zsh-theme my_theme
#   list_theme.sh my_theme  # just list themes in a directory

THEMES_DIR="${1:-$HOME/.oh-my-zsh/themes}"
for f in $THEMES_DIR/*.zsh-theme ; do
  echo -n "$(basename $f .zsh-theme) "
  grep -q '%?'  $f && echo -n "code "
  grep -q '%D'  $f && echo -n "date "
  grep -q 'GIT' $f && echo -n "git "
  grep -q '%!'  $f && echo -n "hist "
  grep -q '%h'  $f && echo -n "hist "
  grep -q '%m'  $f && echo -n "host "
  grep -q '%H'  $f && echo -n "hour "
  grep -q '%j'  $f && echo -n "job "
  grep -q '%L'  $f && echo -n "level "
  grep -q '%y'  $f && echo -n "line "
  grep -q '%M'  $f && echo -n "machine "
  grep -q '%~'  $f && echo -n "path "
  grep -q '%2~'  $f && echo -n "path2 "
  grep -q '%3~'  $f && echo -n "path3 "
  grep -q 'precmd' $f && echo -n "precmd "
  grep -q 'RPROMPT' $f && echo -n "rprompt "
  grep -q '%S'  $f && echo -n "sec "
  grep -q 'SVN' $f && echo -n "svn "
  grep -q '%l'  $f && echo -n "tty "
  grep -q '%n'  $f && echo -n "user "
  grep -q 'VCS' $f && echo -n "vcs "
  grep -q 'vcs_info' $f && echo -n "vcs_info "
  grep -q 'vcs_info_msg' $f && echo -n "vcs_info_msg "
  echo ""
done
# vim:et sw=2 ts=2 ai
