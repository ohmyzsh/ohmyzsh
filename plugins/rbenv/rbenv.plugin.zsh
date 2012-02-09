FOUND_RBENV=0
for rbenvdir in "$HOME/.rbenv" "/usr/local/rbenv" "/opt/rbenv" ; do
  if [ -d $rbenvdir/bin -a $FOUND_RBENV -eq 0 ] ; then
    FOUND_RBENV=1
    export RBENV_ROOT=$rbenvdir
    export PATH=${rbenvdir}/bin:$PATH
  fi
done
unset rbenvdir

# If not found above, check for the existence of the rbenv executable anyway.
if [ $FOUND_RBENV -eq 0 ] ; then
  if ( which rbenv > /dev/null 2>&1 ) ; then
    FOUND_RBENV=1
    export RBENV_ROOT=$(rbenv root)
  fi
fi

if [ $FOUND_RBENV -eq 1 ] ; then

  eval "$(rbenv init -)"

  alias rubies="rbenv versions"
  alias gemsets="rbenv gemset list"

  function current_ruby() {
    echo "$(rbenv version-name)"
  }

  function current_gemset() {
    echo "$(rbenv gemset active 2&>/dev/null | sed -e ":a" -e '$ s/\n/+/gp;N;b a' | head -n1)"
  }

  function gems {
    local rbenv_path=$(rbenv prefix)
    gem list $@ | sed \
      -Ee "s/\([0-9\.]+( .+)?\)/$fg[blue]&$reset_color/g" \
      -Ee "s|$(echo $rbenv_path)|$fg[magenta]\$rbenv_path$reset_color|g" \
      -Ee "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
      -Ee "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
  }

  function rbenv_prompt_info() {
    if [[ -n $(current_gemset) ]] ; then
      echo "$(current_ruby)@$(current_gemset)"
    else
      echo "$(current_ruby)"
    fi
  }

else
  alias rubies='ruby -v'
  function gemsets() { echo 'not supported' }
  function rbenv_prompt_info() { echo "system: $(ruby -v | cut -f-2 -d ' ')" }
fi
