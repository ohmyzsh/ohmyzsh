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

alias xcb='xcodebuild'
alias xcs='xcode-select --print-path'
