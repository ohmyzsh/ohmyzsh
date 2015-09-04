#xc function courtesy of http://gist.github.com/subdigital/5420709
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

alias xcsel='sudo xcode-select --switch'
alias xcb='xcodebuild'
alias xcp='xcode-select --print-path'
alias xcdd='rm -rf ~/Library/Developer/Xcode/DerivedData/*'

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
