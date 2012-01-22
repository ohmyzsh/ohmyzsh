# Now source global aliases
for i in $DOT_ENV_PATH/global/alias/*.sh ; do
  if [ -r "$i" ]; then
  	. $i
  fi
done
unset i
