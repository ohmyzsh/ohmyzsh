rbenvdir=$HOME/.rbenv/bin
if [ -d $rbenvdir ] ; then
  export PATH=$rbenvdir:$PATH
  eval "$(rbenv init -)"

  alias rubies="rbenv versions"
  alias gemsets="rbenv gemset list"

  function current_ruby() {
    echo "$(rbenv version | cut -f1 -d ' ')"
  }

  function current_gemset() {
    echo "$(rbenv gemset active 2&>/dev/null | grep -v 'no active gemsets')"
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
