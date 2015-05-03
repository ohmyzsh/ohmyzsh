# ------------------------------------------------------------------------------
#          FILE:  plugin-helper.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin helper.
#        AUTHOR:  Khas Mek (Boushh@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

local rc=~/.zshrc
local orn=$(echo -e '\033[33m')
local red=$(echo -e '\033[31m')
local rst=$(echo -e '\033[0m')
local no_plugin=$red"\n  Plugin not found!\n"$rst

function print_enabled_plugins()
{
  print "$plugins" | tr " " "\n" | sort
  print  $orn"\n  Above are the currently enabled plugins."$rst
}
alias phpep='print_enabled_plugins'

function print_all_plugins()
{
  ls $ZSH/plugins
  print $orn"\n  Above are the current options."$rst
}
alias phpap='print_all_plugins'

function print_all_readmes()
{
  for readme in $(find $ZSH/plugins -iname "README*"); do
    print $readme | awk -F/ '{print $(NF-1)}'
  done
  print  $orn"\n  Above are the current plugins with a README file."$rst
}
alias phpar='print_all_readmes'

function print_readme()
{
  if [[ -n $1 ]]; then
    if [[ $(find $ZSH/plugins/$1 -iname "README*" | wc -l) -eq 0 ]]; then
      print $red"\n  Plugin $1 has no readme file!" $rst
    else
      for readme in $(find $ZSH/plugins/$1 -iname "README*"); do
        if [[ -n $(command -v pandoc) ]]; then
          pandoc -s -f markdown_github -t man "$readme" \
            | groff -T utf8 -man - \
            | less
        else
          less "$readme"
        fi
      done
    fi
  else
    print $red"\n  Please specify a plugin to view the README of!\n"$rst
    print_all_readmes
  fi
}
alias phpr='print_readme'

function print_aliases()
{
  if [[ -n $1 ]]; then
    for plugin in $(echo "$@"); do
      print $orn"\n  --$plugin--\n"$rst
      grep -r '^alias' $ZSH/plugins/$plugin/ --include \*.zsh \
        | awk '{$1=""; print}' \
        | sed -e "s/^ /$orn/g" -e "s/=/$rst\ =\ /g" \
        | sort
    done
  else
    print $red"\n  Please specify a plugin to view the alises of!"$rst
  fi
}
alias phpa='print_aliases'

function enable_plugin()
{
  if [[ -n $1 ]]; then
    if [[ -d $ZSH/plugins/$1 ]]; then
      sed -i "/^plugins=/s/)$/ $1&/" $rc
      print $orn"\n  Re-sourcing $rc"$rst
      source $rc
    else
      print $no_plugin
      print_all_plugins
    fi
  else
    print $red"\n  Please specify a plugin to enable!\n"$rst
    print_all_plugins
  fi
}
alias phep='enable_plugin'

function disable_plugin()
{
  if [[ -n $1 ]]; then
    if [[ -n $(grep -E "^plugins=.*[( ]$1[ )]" $rc) ]]; then
      local line_number=$(grep -En "^plugins=.*[( ]$1[ )]" $rc | cut -f 1 -d:)
      sed -i -e "${line_number}s/\([( ]\)$1\([ )]\)/\1\2/g" \
        -e "${line_number}s/  */ /g" \
        -e "${line_number}s/( /(/g" \
        -e "${line_number}s/ )/)/g" $rc
      print $orn"\n  Re-sourcing $rc"$rst
      source $rc
    else
      print $no_plugin
      print_enabled_plugins
    fi
  else
    print $red"\n  Please specify a plugin to disable!\n"$rst
    print_enabled_plugins
  fi
}
alias phdp='disable_plugin'

