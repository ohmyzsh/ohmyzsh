#compdef heroku

# Heroku Autocomplete plugin for Oh-My-Zsh
# Requires: The Heroku client gem (https://github.com/heroku/heroku)
# Author: Ali B. (http://awhitebox.com)

local -a _1st_arguments
_1st_arguments=(
  "account\:confirm_billing":"Confirm that your account can be billed at the end of the month"
  "addons":"list installed addons"
  "addons\:list":"list all available addons"
  "addons\:add":"install an addon"
  "addons\:upgrade":"upgrade an existing addon"
  "addons\:downgrade":"downgrade an existing addon"
  "addons\:remove":"uninstall an addon"
  "addons\:open":"open an addon's dashboard in your browser"
  "apps":"list your apps"
  "apps\:info":"show detailed app information"
  "apps\:create":"create a new app"
  "apps\:rename":"rename the app"
  "apps\:open":"open the app in a web browser"
  "apps\:destroy":"permanently destroy an app"
  "auth\:login":"log in with your heroku credentials"
  "auth\:logout":"clear local authentication credentials"
  "config":"display the config vars for an app"
  "config\:add":"add one or more config vars"
  "config\:remove":"remove a config var"
  "db\:push":"push local data up to your app"
  "db\:pull":"pull heroku data down into your local database"
  "domains":"list custom domains for an app"
  "domains\:add":"add a custom domain to an app"
  "domains\:remove":"remove a custom domain from an app"
  "domains\:clear":"remove all custom domains from an app"
  "help":"list available commands or display help for a specific command"
  "keys":"display keys for the current user"
  "keys\:add":"add a key for the current user"
  "keys\:remove":"remove a key from the current user"
  "keys\:clear":"remove all authentication keys from the current user"
  "logs":"display recent log output"
  "logs\:cron":"DEPRECATED: display cron logs from legacy logging"
  "logs\:drains":"manage syslog drains"
  "maintenance\:on":"put the app into maintenance mode"
  "maintenance\:off":"take the app out of maintenance mode"
  "pg\:info":"display database information"
  "pg\:ingress":"allow direct connections to the database from this IP for one minute"
  "pg\:promote":"sets DATABASE as your DATABASE_URL"
  "pg\:psql":"open a psql shell to the database"
  "pg\:reset":"delete all data in DATABASE"
  "pg\:unfollow":"stop a replica from following and make it a read/write database"
  "pg\:wait":"monitor database creation, exit when complete"
  "pgbackups":"list captured backups"
  "pgbackups\:url":"get a temporary URL for a backup"
  "pgbackups\:capture":"capture a backup from a database id"
  "pgbackups\:restore":"restore a backup to a database"
  "pgbackups\:destroy":"destroys a backup"
  "plugins":"list installed plugins"
  "plugins\:install":"install a plugin"
  "plugins\:uninstall":"uninstall a plugin"
  "ps\:dynos":"scale to QTY web processes"
  "ps\:workers":"scale to QTY background processes"
  "ps":"list processes for an app"
  "ps\:restart":"restart an app process"
  "ps\:scale":"scale processes by the given amount"
  "releases":"list releases"
  "releases\:info":"view detailed information for a release"
  "rollback":"roll back to an older release"
  "run":"run an attached process"
  "run\:rake":"remotely execute a rake command"
  "run\:console":"open a remote console session"
  "sharing":"list collaborators on an app"
  "sharing\:add":"add a collaborator to an app"
  "sharing\:remove":"remove a collaborator from an app"
  "sharing\:transfer":"transfer an app to a new owner"
  "ssl":"list certificates for an app"
  "ssl\:add":"add an ssl certificate to an app"
  "ssl\:remove":"remove an ssl certificate from an app"
  "ssl\:clear":"remove all ssl certificates from an app"
  "stack":"show the list of available stacks"
  "stack\:migrate":"prepare migration of this app to a new stack"
  "version":"show heroku client version"
)

_arguments '*:: :->command'

if (( CURRENT == 1 )); then
  _describe -t commands "heroku command" _1st_arguments
  return
fi

local -a _command_args
case "$words[1]" in
  apps:info)
    _command_args=(
      '(-r|--raw)'{-r,--raw}'[output info as raw key/value pairs]' \
    )
    ;;
  apps:create)
    _command_args=(
      '(-a|--addons)'{-a,--addons}'[a list of addons to install]' \
      '(-r|--remote)'{-r,--remote}'[the git remote to create, default "heroku"]' \
      '(-s|--stack)'{-s,--stack}'[the stack on which to create the app]' \
    )
    ;;
  config)
    _command_args=(
      '(-s|--shell)'{-s,--shell}'[output config vars in shell format]' \
    )
    ;;
  db:push)
    _command_args=(
      '(-c|--chunksize)'{-c,--chunksize}'[specify the number of rows to send in each batch]' \
      '(-d|--debug)'{-d,--debug}'[enable debugging output]' \
      '(-e|--exclude)'{-e,--exclude}'[exclude the specified tables from the push]' \
      '(-f|--filter)'{-f,--filter}'[only push certain tables]' \
      '(-r|--resume)'{-r,--resume}'[resume transfer described by a .dat file]' \
      '(-t|--tables)'{-t,--tables}'[only push the specified tables]' \
    )
    ;;
  db:pull)
    _command_args=(
      '(-c|--chunksize)'{-c,--chunksize}'[specify the number of rows to send in each batch]' \
      '(-d|--debug)'{-d,--debug}'[enable debugging output]' \
      '(-e|--exclude)'{-e,--exclude}'[exclude the specified tables from the pull]' \
      '(-f|--filter)'{-f,--filter}'[only pull certain tables]' \
      '(-r|--resume)'{-r,--resume}'[resume transfer described by a .dat file]' \
      '(-t|--tables)'{-t,--tables}'[only pull the specified tables]' \
    )
    ;;
  keys)
    _command_args=(
      '(-l|--long)'{-l,--long}'[display extended information for each key]' \
    )
    ;;
  logs)
    _command_args=(
      '(-n|--num)'{-n,--num}'[the number of lines to display]' \
      '(-p|--ps)'{-p,--ps}'[only display logs from the given process]' \
      '(-s|--source)'{-s,--source}'[only display logs from the given source]' \
      '(-t|--tail)'{-t,--tail}'[continually stream logs]' \
    )
    ;;
  pgbackups:capture)
    _command_args=(
      '(-e|--expire)'{-e,--expire}'[if no slots are available to capture, delete the oldest backup to make room]' \
    )
    ;;
  stack)
    _command_args=(
      '(-a|--all)'{-a,--all}'[include deprecated stacks]' \
    )
    ;;
  esac

_arguments \
  $_command_args \
  '(--app)--app[the app name]' \
  '(--remote)--remote[the remote name]' \
  &&  return 0

