let _mpdscribble_missing_warned
let _mpc_missing_warned
alias m=mpc
for _ in 1; do
  pidof mpdscribble > /dev/null
  test "$?" = 0 && break
  _pth=$(which mpdscribble) > /dev/null
  _exists_mpdscribble=$?
  test ${_exists_mpdscribble} -eq 0 && let _mpdscribble_missing_warned=0
  test ${_exists_mpdscribble} -ne 0 \
	  && test 1 -le "${_mpdscribble_missing_warned}" \
	  &&  break
  if [ ${_exists_mpdscribble} -ne 0 ]; then
    echo "mpdscribble missing"
    let _mpdscribble_missing_warned+=1
    export _mpdscribble_missing_warned
    break
  fi
  _exists_mpc=$?
  test ${_exists_mpc} -eq 0 && let _mpc_missing_warned=0
  test ${_exists_mpc} -ne 0 && test 1 -le "${_mpc_missing_warned}" &&  break
  if [ ${_exists_mpc} -ne 0 ]; then
    echo "mpc missing"
    let _mpc_missing_warned+=1
    export _mpc_missing_warned
    unalias m
    break
  fi
  test -z "${_p}" && $_pth
  unset _pmpd
  unset _exists_mpdscribble
  unset _pth
  unset _mpdscribble_missing_warned
  unset _mpc_missing_warned
done
