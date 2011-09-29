alias rubies='rbenv versions'
alias gemsets='rbenv gemset list'

# TODO: Make this usable w/o rbenv.
function gems {
  local current_ruby=`rbenv active | cut -f1 -d ' '`
  local current_gemset=`rbenv gemset active | grep -v 'no active gemsets'`

  gem list $@ | sed \
    -Ee "s/\([0-9\.]+( .+)?\)/$fg[blue]&$reset_color/g" \
    -Ee "s|$(echo $rvm_path)|$fg[magenta]\$rvm_path$reset_color|g" \
    -Ee "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
    -Ee "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
}

function rbenv_prompt_info() {
  ruby_version=$(rbenv version | cut -f1 -d ' ') || return
  gemset=$(rbenv gemset active 2&>/dev/null | grep -v 'no active gemsets')
  if [[ -n $gemset ]] ; then
    echo "${ruby_version}@${gemset}"
  else
    echo "${ruby_version}"
  fi
}
