# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  nodeversion=`node --version`
  dashlocation=`echo $nodeversion | sed -n "s/-.*//p" | wc -c`;

  if [[ $dashlocation -eq 0 ]]; then
    open "http://nodejs.org/docs/${nodeversion}/api/all.html#$1";
  else
    open "http://nodejs.org/docs/${nodeversion:0:$dashlocation - 1}/api/all.html#$1";
  fi
}
