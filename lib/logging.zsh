omz_log_msg() {
  [[ ! -d $OMZ ]] && mkdir $OMZ
  echo "$@" >> $OMZ/omz.log
}

omzlog() {
  less $OMZ/omz.log
}
