# Completion
fpath+=("${rvm_path}/scripts/zsh/Completion")

typeset -g -A _comps
autoload -Uz _rvm
_comps[rvm]=_rvm

# Aliases
alias rubies='rvm list rubies'
alias rvms='rvm gemset'
alias gemsets='rvms list'


# rb{version} utilities
# From `rvm list known`
typeset -A rubies
rubies=(
  18  'ruby-1.8.7'
  19  'ruby-1.9.3'
  20  'ruby-2.0.0'
  21  'ruby-2.1'
  22  'ruby-2.2'
  23  'ruby-2.3'
  24  'ruby-2.4'
  25  'ruby-2.5'
  26  'ruby-2.6'
  27  'ruby-2.7'
  30  'ruby-3.0'
  31  'ruby-3.1'
  32  'ruby-3.2'
)

for v in ${(k)rubies}; do
  version="${rubies[$v]}"
  functions[rb${v}]="rvm use ${version}\${1+"@\$1"}"
  functions[_rb${v}]="compadd \$(ls -1 \"\${rvm_path}/gems\" | grep '^${version}@' | sed -e 's/^${version}@//' | awk '{print $1}')"
  compdef _rb$v rb$v
done
unset rubies v version


function rvm-update {
  rvm get head
}

# TODO: Make this usable w/o rvm.
function gems {
  local current_ruby=`rvm-prompt i v p`
  local current_gemset=`rvm-prompt g`

  gem list $@ | sed -E \
    -e "s/\([0-9, \.]+( .+)?\)/$fg[blue]&$reset_color/g" \
    -e "s|$(echo $rvm_path)|$fg[magenta]\$rvm_path$reset_color|g" \
    -e "s/$current_ruby@global/$fg[yellow]&$reset_color/g" \
    -e "s/$current_ruby$current_gemset$/$fg[green]&$reset_color/g"
}
