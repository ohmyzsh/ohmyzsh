omz_log_msg() {
  [[ ! -d $OMZ ]] && mkdir $OMZ
  echo "$@" >> $OMZ/omz.log >&2
}

omzlog() {
  less $OMZ/omz.log
}
