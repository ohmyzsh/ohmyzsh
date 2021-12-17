alias bi="bower install"
alias bisd="bower install --save-dev"
alias bis="bower install --save"
alias bl="bower list"
alias bs="bower search"

_bower_installed_packages () {
    bower_package_list=$(bower ls --no-color 2>/dev/null| awk 'NR>3{print p}{p=$0}'| cut -d ' ' -f 2|sed 's/#.*//')
}
_bower ()
{
    local -a _1st_arguments _no_color _dopts _save_dev _force_latest _production
    local expl
    typeset -A opt_args

    _no_color=('--no-color[Do not print colors (available in all commands)]')

    _dopts=(
        '(--save)--save[Save installed packages into the project"s bower.json dependencies]'
        '(--force)--force[Force fetching remote resources even if a local copy exists on disk]'
    )

    _save_dev=('(--save-dev)--save-dev[Save installed packages into the project"s bower.json devDependencies]')

    _force_latest=('(--force-latest)--force-latest[Force latest version on conflict]')

    _production=('(--production)--production[Do not install project devDependencies]')

    _1st_arguments=(
    'cache-clean:Clean the Bower cache, or the specified package caches' \
    'help:Display help information about Bower' \
    'info:Version info and description of a particular package' \
    'init:Interactively create a bower.json file' \
    'install:Install a package locally' \
    'link:Symlink a package folder' \
    'lookup:Look up a package URL by name' \
    'register:Register a package' \
    'search:Search for a package by name' \
    'uninstall:Remove a package' \
    'update:Update a package' \
    {ls,list}:'[List all installed packages]'
    )
    _arguments \
    $_no_color \
    '*:: :->subcmds' && return 0

    if (( CURRENT == 1 )); then
        _describe -t commands "bower subcommand" _1st_arguments
        return
    fi

    case "$words[1]" in
        install)
        _arguments \
        $_dopts \
        $_save_dev \
        $_force_latest \
        $_no_color \
        $_production
        ;;
        update)
        _arguments \
        $_dopts \
        $_no_color \
        $_force_latest
        _bower_installed_packages
        compadd "$@" $(echo $bower_package_list)
        ;;
        uninstall)
        _arguments \
        $_no_color \
        $_dopts
        _bower_installed_packages
        compadd "$@" $(echo $bower_package_list)
        ;;
        *)
        _arguments \
        $_no_color \
        ;;
    esac

}

compdef _bower bower
