function _realdir () {

  TARGET_FILE=$1

  cd `dirname $TARGET_FILE`
  TARGET_FILE=`basename $TARGET_FILE`

  # Iterate down a (possible) chain of symlinks
  while [ -L "$TARGET_FILE" ]
  do
      TARGET_FILE=`readlink $TARGET_FILE`
      cd `dirname $TARGET_FILE`
      TARGET_FILE=`basename $TARGET_FILE`
  done

  # Compute the canonicalized name by finding the physical path
  # for the directory we're in and appending the target file.
  PHYS_DIR=`pwd -P`
  RESULT=$PHYS_DIR # get asolute dir
  # RESULT=$PHYS_DIR/$TARGET_FILE #get absolute path
  echo $RESULT
}

function rm () {
  local files
  local trash=~/.Trash/
  test ! -d $trash && mkdir $trash
  for files in "$@"; do
    # ignore any arguments
    if [[ "$files" = -* ]]; then :
    else
      local dst=${files##*/}
      local filePath
      
      # append the time if necessary
      while [ -e $trash$dst ]; do
        dst=$dst_$(date +%H-%M-%S)
      done

      # if the file is in dustbin or is dustbin itself ,remove it permanently
      filePath=`_realdir $files`
      if test $trash -ef $filePath -o $trash -ef $files
      then
        \env rm -r $files
      else
        \env mv $files $trash$dst
      fi
    fi
  done
}
