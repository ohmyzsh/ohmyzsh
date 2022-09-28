# invoked in worker: _p9k_worker_main <pgid>
function _p9k_worker_main() {
  mkfifo -- $_p9k__worker_file_prefix.fifo || return
  echo -nE - s$_p9k_worker_pgid$'\x1e'     || return
  exec <$_p9k__worker_file_prefix.fifo     || return
  zf_rm -- $_p9k__worker_file_prefix.fifo  || return

  local -i reset
  local req fd
  local -a ready
  local _p9k_worker_request_id
  local -A _p9k_worker_fds       # fd => id$'\x1f'callback
  local -A _p9k_worker_inflight  # id => inflight count

  function _p9k_worker_reply() {
    print -nr -- e${(pj:\n:)@}$'\x1e' || kill -- -$_p9k_worker_pgid
  }

  # usage: _p9k_worker_async <work> <callback>
  function _p9k_worker_async() {
    local fd async=$1
    sysopen -r -o cloexec -u fd <(() { eval $async; } && print -n '\x1e') || return
    (( ++_p9k_worker_inflight[$_p9k_worker_request_id] ))
    _p9k_worker_fds[$fd]=$_p9k_worker_request_id$'\x1f'$2
  }

  trap '' PIPE

  {
    while zselect -a ready 0 ${(k)_p9k_worker_fds}; do
      [[ $ready[1] == -r ]] || return
      for fd in ${ready:1}; do
        if [[ $fd == 0 ]]; then
          local buf=
          [[ -t 0 ]]  # https://www.zsh.org/mla/workers/2020/msg00207.html
          if sysread -t 0 'buf[$#buf+1]'; then
            while [[ $buf != *$'\x1e' ]]; do
              sysread 'buf[$#buf+1]' || return
            done
          else
            (( $? == 4 )) || return
          fi
          for req in ${(ps:\x1e:)buf}; do
            _p9k_worker_request_id=${req%%$'\x1f'*}
            () { eval $req[$#_p9k_worker_request_id+2,-1] }
            (( $+_p9k_worker_inflight[$_p9k_worker_request_id] )) && continue
            print -rn -- d$_p9k_worker_request_id$'\x1e' || return
          done
        else
          local REPLY=
          while true; do
            if sysread -i $fd 'REPLY[$#REPLY+1]'; then
              [[ $REPLY == *$'\x1e' ]] || continue
            else
              (( $? == 5 ))            || return
              break
            fi
          done
          local cb=$_p9k_worker_fds[$fd]
          _p9k_worker_request_id=${cb%%$'\x1f'*}
          unset "_p9k_worker_fds[$fd]"
          exec {fd}>&-
          if [[ $REPLY == *$'\x1e' ]]; then
            REPLY[-1]=""
            () { eval $cb[$#_p9k_worker_request_id+2,-1] }
          fi
          if (( --_p9k_worker_inflight[$_p9k_worker_request_id] == 0 )); then
            unset "_p9k_worker_inflight[$_p9k_worker_request_id]"
            print -rn -- d$_p9k_worker_request_id$'\x1e' || return
          fi
        fi
      done
    done
  } always {
    kill -- -$_p9k_worker_pgid
  }
}

# invoked in master: _p9k_worker_invoke <request-id> <list>
function _p9k_worker_invoke() {
  [[ -n $_p9k__worker_resp_fd ]] || return
  local req=$1$'\x1f'$2$'\x1e'
  if [[ -n $_p9k__worker_req_fd && $+_p9k__worker_request_map[$1] == 0 ]]; then
    _p9k__worker_request_map[$1]=
    print -rnu $_p9k__worker_req_fd -- $req
  else
    _p9k__worker_request_map[$1]=$req
  fi
}

function _p9k_worker_cleanup() {
  # __p9k_intro bugs out here in some cases for some reason.
  emulate -L zsh
  [[ $_p9k__worker_shell_pid == $sysparams[pid] ]] && _p9k_worker_stop
  return 0
}

function _p9k_worker_stop() {
  # See comments in _p9k_worker_cleanup.
  emulate -L zsh
  add-zsh-hook -D zshexit _p9k_worker_cleanup
  [[ -n $_p9k__worker_resp_fd     ]] && zle -F $_p9k__worker_resp_fd
  [[ -n $_p9k__worker_resp_fd     ]] && exec {_p9k__worker_resp_fd}>&-
  [[ -n $_p9k__worker_req_fd      ]] && exec {_p9k__worker_req_fd}>&-
  [[ -n $_p9k__worker_pid         ]] && kill -- -$_p9k__worker_pid 2>/dev/null
  [[ -n $_p9k__worker_file_prefix ]] && zf_rm -f -- $_p9k__worker_file_prefix.fifo
  _p9k__worker_pid=
  _p9k__worker_req_fd=
  _p9k__worker_resp_fd=
  _p9k__worker_shell_pid=
  _p9k__worker_request_map=()
  return 0
}

function _p9k_worker_receive() {
  eval "$__p9k_intro"

  [[ -z $_p9k__worker_resp_fd ]] && return

  {
    (( $# <= 1 )) || return

    local buf resp

    [[ -t $_p9k__worker_resp_fd ]]  # https://www.zsh.org/mla/workers/2020/msg00207.html
    if sysread -i $_p9k__worker_resp_fd -t 0 'buf[$#buf+1]'; then
      while [[ $buf == *[^$'\x05\x1e']$'\x05'# ]]; do
        sysread -i $_p9k__worker_resp_fd 'buf[$#buf+1]' || return
      done
    else
      (( $? == 4 )) || return
    fi

    local -i reset max_reset
    for resp in ${(ps:\x1e:)${buf//$'\x05'}}; do
      local arg=$resp[2,-1]
      case $resp[1] in
        d)
          local req=$_p9k__worker_request_map[$arg]
          if [[ -n $req ]]; then
            _p9k__worker_request_map[$arg]=
            print -rnu $_p9k__worker_req_fd -- $req                                   || return
          else
            unset "_p9k__worker_request_map[$arg]"
          fi
        ;;
        e)
          () { eval $arg }
          (( reset > max_reset )) && max_reset=reset
        ;;
        s)
          [[ -z $_p9k__worker_req_fd ]]                                               || return
          [[ $arg == <1->        ]]                                                   || return
          _p9k__worker_pid=$arg
          sysopen -w -o cloexec -u _p9k__worker_req_fd $_p9k__worker_file_prefix.fifo || return
          local req=
          for req in $_p9k__worker_request_map; do
            print -rnu $_p9k__worker_req_fd -- $req                                   || return
          done
          _p9k__worker_request_map=({${(k)^_p9k__worker_request_map},''})
        ;;
        *)
          return 1
        ;;
      esac
    done

    if (( max_reset == 2 )); then
      _p9k__refresh_reason=worker
      _p9k_set_prompt
      _p9k__refresh_reason=''
    fi
    (( max_reset )) && _p9k_reset_prompt
    return 0
  } always {
    (( $? )) && _p9k_worker_stop
  }
}

function _p9k_worker_start() {
  setopt monitor || return
  {
    [[ -n $_p9k__worker_resp_fd ]] && return

    if [[ -n "$TMPDIR" && ( ( -d "$TMPDIR" && -w "$TMPDIR" ) || ! ( -d /tmp && -w /tmp ) ) ]]; then
      local tmpdir=$TMPDIR
    else
      local tmpdir=/tmp
    fi
    _p9k__worker_file_prefix=$tmpdir/p10k.worker.$EUID.$sysparams[pid].$EPOCHSECONDS

    sysopen -r -o cloexec -u _p9k__worker_resp_fd <(
      exec 0</dev/null
      if [[ -n $_POWERLEVEL9K_WORKER_LOG_LEVEL ]]; then
        exec 2>$_p9k__worker_file_prefix.log
        setopt xtrace
      else
        exec 2>/dev/null
      fi
      builtin cd -q /                    || return
      zmodload zsh/zselect               || return
      ! { zselect -t0 || (( $? != 1 )) } || return
      local _p9k_worker_pgid=$sysparams[pid]
      _p9k_worker_main &
      {
        trap '' PIPE
        while syswrite $'\x05'; do zselect -t 1000; done
        zf_rm -f $_p9k__worker_file_prefix.fifo
        kill -- -$_p9k_worker_pgid
      } &
      exec =true) || return
    _p9k__worker_pid=$sysparams[procsubstpid]
    zle -F $_p9k__worker_resp_fd _p9k_worker_receive
    _p9k__worker_shell_pid=$sysparams[pid]
    add-zsh-hook zshexit _p9k_worker_cleanup
  } always {
    (( $? )) && _p9k_worker_stop
  }
}
