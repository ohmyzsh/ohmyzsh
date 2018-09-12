#compdef mix
#autoload

# Elixir mix zsh completion

local -a _1st_arguments
_1st_arguments=(
    'app.start:Start all registered apps'
    'archive:List all archives'
    'archive.build:Archive this project into a .ez file'
    'archive.install:Install an archive locally'
    'archive.uninstall:Uninstall archives'
    'clean:Delete generated application files'
    'cmd:Executes the given command'
    'compile:Compile source files'
    'compile.protocols:Consolidates all protocols in all paths'
    'deps:List dependencies and their status'
    "deps.clean:Remove the given dependencies' files"
    'deps.compile:Compile dependencies'
    'deps.get:Get all out of date dependencies'
    'deps.unlock:Unlock the given dependencies'
    'deps.update:Update the given dependencies'
    'do:Executes the tasks separated by comma'
    'ecto.create:Create Ecto database'
    'ecto.drop:Drop the storage for the given repository'
    'ecto.dump:Dumps the current environment’s database structure'
    'ecto.gen.migration:Generates a migration'
    'ecto.gen.repo:Generates a new repository'
    'ecto.load:Loads the current environment’s database structure'
    'ecto.migrate:Runs Ecto migration'
    'ecto.migrations:Displays the up / down migration status'
    'ecto.rollback:Reverts applied migrations'
    'escript.build:Builds an escript for the project'
    'help:Print help information for tasks'
    'hex:Print hex help information'
    'hex.config:Read or update hex config'
    'hex.docs:Publish docs for package'
    'hex.info:Print hex information'
    'hex.key:Hex API key tasks'
    'hex.outdated:Shows outdated hex deps for the current project'
    'hex.owner:Hex package ownership tasks'
    'hex.publish:Publish a new package version'
    'hex.search:Search for package names'
    'hex.user:Hex user tasks'
    'loadconfig:Loads and persists the given configuration'
    'local:List local tasks'
    'local.hex:Install hex locally'
    'local.phoenix:Updates Phoenix locally'
    'local.phx:Updates the Phoenix project generator locally'
    'local.rebar:Install rebar locally'
    'new:Create a new Elixir project'
    'phoenix.digest:Digests and compress static files'
    'phoenix.gen.channel:Generates a Phoenix channel'
    'phoenix.gen.html:Generates controller, model and views for an HTML based resource'
    'phoenix.gen.json:Generates a controller and model for a JSON based resource'
    'phoenix.gen.model:Generates an Ecto model'
    'phoenix.gen.secret:Generates a secret'
    'phoenix.new:Creates a new Phoenix v1.2.1 application'
    'phoenix.routes:Prints all routes'
    'phoenix.server:Starts applications and their servers'
    'phx.digest:Digests and compresses static files'
    'phx.digest.clean:Removes old versions of static assets.'
    'phx.gen.channel:Generates a Phoenix channel'
    'phx.gen.context:Generates a context with functions around an Ecto schema'
    'phx.gen.embedded:Generates an embedded Ecto schema file'
    'phx.gen.html:Generates controller, views, and context for an HTML resource'
    'phx.gen.json:Generates controller, views, and context for a JSON resource'
    'phx.gen.presence:Generates a Presence tracker'
    'phx.gen.schema:Generates an Ecto schema and migration file'
    'phx.gen.secret:Generates a secret'
    'phx.new:Creates a new Phoenix v1.3.0 application'
    'phx.new.ecto:Creates a new Ecto project within an umbrella project'
    'phx.new.web:Creates a new Phoenix web project within an umbrella project'
    'phx.routes:Prints all routes'
    'phx.server:Starts applications and their servers'
    'run:Run the given file or expression'
    "test:Run a project's tests"
    '--help:Describe available tasks'
    '--version:Prints the Elixir version information'
)

__task_list ()
{
    local expl
    declare -a tasks

    tasks=(app.start archive archive.build archive.install archive.uninstall clean cmd compile compile.protocols deps deps.clean deps.compile deps.get deps.unlock deps.update do escript.build help hex hex.config hex.docs hex.info hex.key hex.outdated hex.owner hex.publish hex.search hex.user loadconfig local local.hex local.rebar new phoenix.digest phoenix.gen.channel phoenix.gen.html phoenix.gen.json phoenix.gen.model phoenix.gen.secret phoenix.new phoenix.routes phoenix.server phx.digest phx.digest.clean phx.gen.channel phx.gen.context phx.gen.embedded phx.gen.html phx.gen.json phx.gen.presence phx.gen.schema phx.gen.secret phx.new phx.new.ecto phx.new.web phx.routes phx.server run test)

    _wanted tasks expl 'help' compadd $tasks
}

local expl

local curcontext="$curcontext" state line
typeset -A opt_args

_arguments -C \
    ':command:->command' \
    '*::options:->options'

case $state in
  (command)
      _describe -t commands "mix subcommand" _1st_arguments
      return
  ;;

  (options)
    case $line[1] in
      (help)
         _arguments ':feature:__task_list'
         ;;
      (test)
         _files
         ;;
      (run)
         _files
         ;;
    esac
  ;;
esac
