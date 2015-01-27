_homebrew-installed() {
  type brew &> /dev/null
}

_rbenv-from-homebrew-installed() {
  brew --prefix rbenv &> /dev/null
}

FOUND_RBENV=0
rbenvdirs=("$HOME/.rbenv" "/usr/local/rbenv" "/opt/rbenv" "/usr/local/opt/rbenv")
if _homebrew-installed && _rbenv-from-homebrew-installed ; then
    rbenvdirs=($(brew --prefix rbenv) "${rbenvdirs[@]}")
fi

for rbenvdir in "${rbenvdirs[@]}" ; do
  if [ -d $rbenvdir/bin -a $FOUND_RBENV -eq 0 ] ; then
    FOUND_RBENV=1
    if [[ $RBENV_ROOT = '' ]]; then
      RBENV_ROOT=$rbenvdir
    fi
    export RBENV_ROOT
    export PATH=${rbenvdir}/bin:$PATH
    eval "$(rbenv init --no-rehash - zsh)"

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
      gem list $@ | sed -E \
        -e "s/\([0-9a-z, \.]+( .+)?\)/$fg[blue]&$reset_color/g" \
        -e "s|$(echo $rbenv_path)|$fg[magenta]\$rbenv_path$reset_color|g" \
        -e "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
        -e "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
    }

    function rbenv_prompt_info() {
      if [[ -n $(current_gemset) ]] ; then
        echo "$(current_ruby)@$(current_gemset)"
      else
        echo "$(current_ruby)"
      fi
    }
  fi
done
unset rbenvdir

if [ $FOUND_RBENV -eq 0 ] ; then
  alias rubies='ruby -v'
  function gemsets() { echo 'not supported' }
  function rbenv_prompt_info() { echo "system: $(ruby -v | cut -f-2 -d ' ')" }
fi
