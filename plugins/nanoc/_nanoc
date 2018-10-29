#compdef nanoc
#autoload

# requires the 'nanoc' gem to be installed

local -a _1st_arguments
_1st_arguments=(
  'check:run issue checks'
  'compile:compile items of this site'
  'create-site:create a site'
  'deploy:deploy the compiled site'
  'help:show help'
  'prune:remove files not managed by nanoc from the output directory'
  'shell:open a shell on the Nanoc environment'
  'show-data:show data in this site'
  'show-plugins:show all available plugins'
  'show-rules:describe the rules for each item'
  'view:start the web server that serves static files'
)

local expl
local -a pkgs installed_pkgs

_arguments \
  '(--color)--color[enable color]' \
  '(--debug)--debug[enable debugging]' \
  '(--env)--env[set environment]' \
  '(--help)--help[show the help message and quit]' \
  '(--no-color)--no-color[disable color]' \
  '(--verbose)--verbose[make output more detailed]' \
  '(--version)--version[show version information and quit]' \
  '(--warn)--warn[enable warnings]' \
  '*:: :->subcmds' && return 0

case "$state" in
  subcmds)
    case $words[1] in
      check)
        _arguments \
          '(--preprocess)--preprocess[run preprocessor]'
      ;;

      compile)
        _arguments \
          '(--diff)--diff[generate diff]'
      ;;

      compile)
        _arguments \
          '(--diff)--diff[generate diff]'
      ;;

      create-site)
        _arguments \
          '(--force)--force[force creation of new site]'
      ;;

      deploy)
        _arguments \
          '(--target)--target[specify the location to deploy to (default: `default`)]' \
          '(--no-check)--no-check[do not run the issue checks marked for deployment]' \
          '(--list)--list[list available locations to deploy to]' \
          '(--list-deployers)--list-deployers[list available deployers]' \
          '(--dry-run)--dry-run[show what would be deployed]'
      ;;

      prune)
        _arguments \
          '(--yes)--yes[confirm deletion]' \
          '(--dry-run)--dry-run[print files to be deleted instead of actually deleting them]'
      ;;

      shell)
        _arguments \
          '(--preprocess)--preprocess[run preprocessor]'
      ;;

      view)
        _arguments \
          '(--handler)--handler[specify the handler to use (webrick/mongrel/...)]' \
          '(--host)--host[specify the host to listen on (default: 127.0.0.1)]' \
          '(--port)--port[specify the port to listen on (default: 3000]' \
          '(--live-reload)--live-reload[reload on changes]'
      ;;
    esac
  ;;
esac

if (( CURRENT == 1 )); then
  _describe -t commands "nanoc subcommand" _1st_arguments
  return
fi
