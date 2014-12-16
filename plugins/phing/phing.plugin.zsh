_phing () {
  if [ -f build.xml ]; then
    PHING_TARGETS=$(phing -l|grep -v "\[property\]"|grep -v "Buildfile"|sed 1d|grep -v ":$" |grep -v "^\-*$"|awk '{print $1}')
    compadd $(echo $PHING_TARGETS)
  fi
}

compdef _phing phing
