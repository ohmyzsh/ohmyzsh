#
# Requires https://www.bruji.com/bwana/
#
if [[ -e /Applications/Bwana.app ]] ||
    ( system_profiler -detailLevel mini SPApplicationsDataType | grep -q Bwana )
then
  function man() {
    open "man:$1"
  }
else
  echo "Bwana lets you read man files in Safari through a man: URI scheme" 
  echo "To use it within Zsh, install it from https://www.bruji.com/bwana/"
fi
