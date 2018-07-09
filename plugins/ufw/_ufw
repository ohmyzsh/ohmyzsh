#compdef ufw
#autoload

typeset -A opt_args

function _ufw_delete_rules {
  if ufw status &> /dev/null ; then
    ufw status numbered \
      | perl -n -e'/\[ +(\d+)\] +([^ ].+)/ && print "\"$1\[$2\]\" "'
  fi
}

function _ufw_app_profiles {
  grep -rhoP "(?<=\[)[^\]]+" /etc/ufw/applications.d/ \
    | awk '{ print "\""$0"\""}' \
    | tr '\n' ' '
}

local -a _1st_arguments
_1st_arguments=(
  'allow:add allow rule'
  'app:Application profile commands'
  'default:set default policy'
  'delete:delete RULE'
  'deny:add deny rule'
  'disable:disables the firewall'
  'enable:enables the firewall'
  'insert:insert RULE at NUM'
  'limit:add limit rule'
  'logging:set logging to LEVEL'
  'reject:add reject rule'
  'reload:reloads firewall'
  'reset:reset firewall'
  'show:show firewall report'
  'status:show firewall status'
  'version:display version information'
)

local context state line curcontext="$curcontext"

_arguments -C \
  '(--dry-run)--dry-run[dry run]' \
  '1:: :->cmds' \
  '2:: :->subcmds' \
  '3:: :->subsubcmds' \
&& return 0

local rules

case "$state" in
  (cmds)
    _describe -t commands "ufw commands" _1st_arguments
    return 0
    ;;
  (subcmds)
    case "$line[1]" in
      (app)
        _values 'app' \
          'list[list application profiles]' \
          'info[show information on PROFILE]' \
          'update[update PROFILE]' \
          'default[set default application policy]' \
        && ret=0
        ;;
      (status)
        _values 'status' \
          'numbered[show firewall status as numbered list of RULES]' \
          'verbose[show verbose firewall status]' \
        && ret=0
        ;;
      (logging)
        _values 'logging' \
          'on' 'off' 'low' 'medium' 'high' 'full' \
        && ret=0
        ;;
      (default)
        _values 'default' \
          'allow' 'deny' 'reject' \
        && ret=0
        ;;
      (show)
        _values 'show' \
          'raw' 'builtins' 'before-rules' 'user-rules' 'after-rules' 'logging-rules' 'listening' 'added' \
        && ret=0
        ;;
      (delete)
        rules="$(_ufw_delete_rules)"
        if [[ -n "$rules" ]] ; then
          _values 'delete' \
            ${(Q)${(z)"$(_ufw_delete_rules)"}} \
          && ret=0
        fi
        ;;
    esac
    ;;
  (subsubcmds)
    case "$line[1]" in
      (app)
        case "$line[2]" in
          (info|update)
            _values 'profiles' \
              ${(Q)${(z)"$(_ufw_app_profiles)"}} \
            && ret=0
            ;;
        esac
        ;;
      (default)
        _values 'default-direction' \
          'incoming' 'outgoing' \
        && ret=0
        ;;
    esac
esac

return
