alias vv='vvvenv'

vvvenv() {
  result=${PWD##*/}
  DIRECTORY=${HOME}/v/${result}
  printf $DIRECTORY'\n'
  if [ -d $DIRECTORY ]; then
    echo 'Activating '$result '\n'
    source $DIRECTORY'/bin/activate'
  else
    printf 'Creating new virtual environment\n'
    virtualenv --python=python3 $DIRECTORY && source $DIRECTORY/bin/activate
  fi
}
