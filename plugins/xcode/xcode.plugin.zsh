alias xcb='xcodebuild'
alias xcdd='rm -rf ~/Library/Developer/Xcode/DerivedData/*'
alias xcp='xcode-select --print-path'
alias xcsel='sudo xcode-select --switch'

# original author: @subdigital
# source: http://gist.github.com/subdigital/5420709
function xc {
  local xcode_proj
  xcode_proj=(*.{xcworkspace,xcodeproj}(N))

  if [[ ${#xcode_proj} -eq 0 ]]; then
    echo "No xcworkspace/xcodeproj file found in the current directory."
    return 1
  else
    echo "Found ${xcode_proj[1]}"
    open "${xcode_proj[1]}"
  fi
}

# "XCode-SELect by Version" - select Xcode by just version number
# Uses naming convention:
#  - different versions of Xcode are named Xcode-<version>.app or stored
#     in a folder named Xcode-<version>
#  - the special version name "-" refers to the "default" Xcode.app with no suffix
function xcselv {
  emulate -L zsh
  local version=$1
  local apps_dirs apps_dir apps app
  apps_dirs=( $HOME/Applications /Applications )
  for apps_dir ($apps_dirs); do
    if [[ $version == "-" ]]; then
      apps=( $apps_dir/Xcode.app $apps_dir/Xcode/Xcode.app )
    else
      apps=( $apps_dir/Xcode-$version.app $apps_dir/Xcode-$version/Xcode.app )
    fi
    for app ($apps); do
      if [[ -e "$app" ]]; then
        echo "selecting Xcode $version: $app"
        xcsel "$app"
        return
      fi
    done
  done
  echo "xcselv: Xcode version $version not found"
  return 1
}

function simulator {
  local devfolder
  devfolder="$(xcode-select -p)"

  # Xcode ≤ 5.x
  if [[ -d "${devfolder}/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" ]]; then
    open "${devfolder}/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app"
  # Xcode ≥ 6.x
  else
    open "${devfolder}/Applications/iOS Simulator.app"
  fi
}
