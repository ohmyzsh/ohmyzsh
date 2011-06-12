# This plugin is based on https://github.com/gma/bundler-exec
# modify the BUNDLED_COMMANDS if needed

bundled_commands=(cucumber heroku rackup rails rake rspec ruby shotgun spec spork)

## Functions

bundler-installed()
{
    which bundle > /dev/null 2>&1
}

within-bundled-project()
{
    local dir="$(pwd)"
    while [ "$(dirname $dir)" != "/" ]; do
        [ -f "$dir/Gemfile" ] && return
        dir="$(dirname $dir)"
    done
    false
}

run-with-bundler()
{
    local command="$1"
    shift
    if bundler-installed && within-bundled-project; then
        bundle exec $command "$@"
    else
        $command "$@"
    fi
}

## Main program
for cmd in $bundled_commands; do
   alias $cmd="run-with-bundler $cmd"
done
