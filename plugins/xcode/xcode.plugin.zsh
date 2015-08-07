#xc function courtesy of http://gist.github.com/subdigital/5420709
function xc {
  local xcode_proj
  xcode_proj=(*.{xcworkspace,xcodeproj}(N))
  if [[ ${#xcode_proj} -eq 0 ]]; then
    echo "No xcworkspace/xcodeproj file found in the current directory."
  else
    echo "Found ${xcode_proj[1]}"
    open "${xcode_proj[1]}"
  fi
}

function xcsel {
  sudo xcode-select --switch "$*"
}

alias xcb='xcodebuild'
alias xcp='xcode-select --print-path'
alias xcdd='rm -rf ~/Library/Developer/Xcode/DerivedData/*'

if [[ -d $(xcode-select -p)/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app ]]; then
  alias simulator='open $(xcode-select -p)/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'
else
  alias simulator='open $(xcode-select -p)/Applications/iOS\ Simulator.app'
fi
