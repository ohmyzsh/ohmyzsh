# pbcopy is expected to be available on Mac OSX
if type pbcopy &> /dev/null; then
  alias copy="pbcopy"
  alias paste="pbpaste"

# xsel is expected to be available on most modern XWindows based Linux distro
elif type xsel &> /dev/null; then
  alias copy="xsel --clipboard --input"
  alias paste="xsel --clipboard --output"

# xclip is expected to be available on Linux distros that do not ship with xsel
elif type xclip &> /dev/null; then
  alias copy="xclip --selection clipboard"
  alias paste="xclip --selection clipboard -o"

else
 echo 'No clipboard util found!'
 echo 'Please install one of the following utils:'
 echo '\tpbcopy'
 echo '\txsel'
 echo '\txclip'
 return 1
fi
