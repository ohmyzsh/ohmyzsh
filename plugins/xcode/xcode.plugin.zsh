#xc function courtesy of http://gist.github.com/subdigital/5420709
function xc {
  xcode_proj=`find . -name "*.xc*" -d 1 | sort -r | head -1`
  if [[ `echo -n $xcode_proj | wc -m` == 0 ]]
  then
    echo "No xcworkspace/xcodeproj file found in the current directory."
  else
    echo "Found $xcode_proj" 
    open "$xcode_proj" 
  fi
}

function xcsel {
  sudo xcode-select --switch "$*"
}

alias xcb='xcodebuild'
alias xcp='xcode-select --print-path'
alias simulator='open $(xcode-select  -p)/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app'
