_phing () {
  if [ -f build.xml ]; then
    compadd $(phing -l|grep -v "\[property\]"|grep -v "Buildfile"|sed 1d|grep -v ":$" |grep -v "^\-*$"|grep -v "Warning:"|awk '{print $1}')
  fi
}

compdef _phing phing
