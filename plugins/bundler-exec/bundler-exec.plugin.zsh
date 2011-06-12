# This plugin is based on https://github.com/gma/bundler-exec
# modify the BUNDLED_COMMANDS if needed

bundled_commands=(cucumber heroku rackup rails rake rspec ruby shotgun spec spork)

## Functions

_bundler-installed()
{
    which bundle > /dev/null 2>&1
}

_within-bundled-project()
{
    local check_dir=$PWD
    while [ "$(dirname $check_dir)" != "/" ]; do
        [ -f "$check_dir/Gemfile" ] && return
        check_dir="$(dirname $check_dir)"
    done
    false
}

_run-with-bundler()
{
    local command="$1"
    shift
    if _bundler-installed && _within-bundled-project; then
        bundle exec $command "$@"
    else
      $command "$@"
    fi
}

## Main program
for cmd in $bundled_commands; do
   alias $cmd="_run-with-bundler $cmd"
done
