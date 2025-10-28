#compdef fail2ban-client

_fail2ban_jails() {
  # Récupère la liste des jails actifs
  if [[ $EUID -eq 0 ]]; then
    fail2ban-client status 2>/dev/null | awk '/Jail list/ { sub(/^.*:[ \t]*/, ""); gsub(/[ \t]+/, ""); split($0, a, /,/); for (i in a) if (a[i]) print a[i] }'
  else
    sudo fail2ban-client status 2>/dev/null | awk '/Jail list/ { sub(/^.*:[ \t]*/, ""); gsub(/[ \t]+/, ""); split($0, a, /,/); for (i in a) if (a[i]) print a[i] }'
  fi
}

_fail2ban-client() {
  local curcontext="$curcontext" state line cmdpos
  typeset -A opt_args

  cmdpos=${words[(i)fail2ban-client]}

  _arguments \
    '1:cmd:(start restart reload stop unban banned status ping set get add echo help version)' \
    '*::arg:->args'

  if [[ "$state" = args ]]; then
    local -a jails

    case $line[1] in
      set)
        if (( CURRENT - cmdpos == 1 )); then
          jails=($(_fail2ban_jails))
          _describe 'jail' jails
        elif (( CURRENT - cmdpos == 2 )); then
          _values 'action' \
            'idle' 'ignoreself' 'addignoreip' 'delignoreip' 'ignorecommand' 'ignorecache' \
            'addlogpath' 'dellogpath' 'logencoding' 'addjournalmatch' 'deljournalmatch' \
            'addfailregex' 'delfailregex' 'addignoreregex' 'delignoreregex' 'findtime' \
            'bantime' 'datepattern' 'usedns' 'attempt' 'banip' 'unbanip' 'maxretry' \
            'maxmatches' 'maxlines' 'addaction' 'delaction' 'action'
        elif (( CURRENT - cmdpos > 2 )); then
          case $line[3] in
            idle) _values 'option' 'on' 'off' ;;
            ignoreself) _values 'option' 'true' 'false' ;;
            addlogpath) (( CURRENT - cmdpos == 4 )) && _values 'option' 'tail' ;;
            unbanip) (( CURRENT - cmdpos == 3 )) && _values 'option' '--report-absent' ;;
            action)
              if (( CURRENT - cmdpos == 3 )); then
                _message "nom de l'action (ACT)"
              elif (( CURRENT - cmdpos == 4 )); then
                _values 'action property' \
                  'actionstart' 'actionstop' 'actioncheck' 'actionban' 'actionunban' 'timeout'
              fi
              ;;
          esac
        fi
        ;;

      get)
        if (( CURRENT - cmdpos == 1 )); then
          jails=($(_fail2ban_jails))
          _describe 'jail' jails
        elif (( CURRENT - cmdpos == 2 )); then
          _values 'property' \
            'banned' 'logpath' 'logencoding' 'journalmatch' 'ignoreself' 'ignoreip' \
            'ignorecommand' 'failregex' 'ignoreregex' 'findtime' 'bantime' 'datepattern' \
            'usedns' 'banip' 'maxretry' 'maxmatches' 'maxlines' 'actions' 'action' \
            'actionproperties' 'actionmethods'
        elif (( CURRENT - cmdpos > 2 )); then
          case $line[3] in
            action)
              if (( CURRENT - cmdpos == 3 )); then
                _message "nom de l'action (ACT)"
              elif (( CURRENT - cmdpos == 4 )); then
                _values 'action property' \
                  'actionstart' 'actionstop' 'actioncheck' 'actionban' 'actionunban' 'timeout'
              fi
              ;;
            actionproperties|actionmethods)
              (( CURRENT - cmdpos == 3 )) && _message "nom de l'action (ACT)"
              ;;
            banip)
              (( CURRENT - cmdpos == 3 )) && _values 'option' '--with-time'
              ;;
          esac
        fi
        ;;

      status|restart|start|stop)
        if (( CURRENT - cmdpos == 1 )); then
          jails=($(_fail2ban_jails))
          _describe 'jail' jails
        elif (( CURRENT - cmdpos == 2 )) && [[ $line[1] == "status" ]]; then
          _values 'flavor' 'extended'
        fi
        ;;

      reload)
        if (( CURRENT - cmdpos == 1 )); then
          jails=($(_fail2ban_jails))
          _values 'option' '--all'
          _describe 'jail' jails
        fi
        ;;

      unban)
        (( CURRENT - cmdpos == 1 )) && _values 'option' '--all'
        ;;

      add)
        if (( CURRENT - cmdpos == 1 )); then
          _message 'nom du jail à ajouter'
        elif (( CURRENT - cmdpos == 2 )); then
          _values 'backend' 'auto' 'pyinotify' 'systemd' 'gamin' 'polling'
        fi
        ;;
    esac
  fi
}

compdef _fail2ban-client fail2ban-client
