if [ -x rbenv ] ; then
  alias rubies='rbenv versions'
  alias gemsets='rbenv gemset list'

  current_ruby=$(rbenv active | cut -f1 -d ' ')
  current_gemset=$(rbenv gemset active 2&>/dev/null | grep -v 'no active gemsets')

  function gems {
    local rbenv_path=$(rbenv prefix)
    gem list $@ | sed \
      -Ee "s/\([0-9\.]+( .+)?\)/$fg[blue]&$reset_color/g" \
      -Ee "s|$(echo $rbenv_path)|$fg[magenta]\$rbenv_path$reset_color|g" \
      -Ee "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
      -Ee "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
  }

  function rbenv_prompt_info() {
    if [[ -n $gemset ]] ; then
      echo "${ruby_version}@${gemset}"
    else
      echo "${ruby_version}"
    fi
  }
else
  alias rubies='ruby -v'
  function gemsets() { echo 'not supported' }
  function rbenv_prompt_info() { echo '' }
fi
