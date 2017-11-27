# Alias sorted alphabetically

alias y="yarn "
alias ya="yarn add"
alias ycc="yarn cache clean"
alias yh="yarn help"
alias yo="yarn outdated"
alias yui="yarn upgrade-interactive"

_yarn ()
{
    local -a _1st_arguments _dopts _dev _production
    local expl
    typeset -A opt_args

    _dopts=(
        '(--force)--force[This refetches all packages, even ones that were previously installed.]'
    )

    _installopts=(
        '(--flat)--flat[Only allow one version of a package. On the first run this will prompt you to choose a single version for each package that is depended on at multiple version ranges.]'
        '(--har)--har[Outputs an HTTP archive from all the network requests performed during the installation.]'
        '(--no-lockfile)--no-lockfile[Don’t read or generate a yarn.lock lockfile.]'
        '(--pure-lockfile)--pure-lockfile[Don’t generate a yarn.lock lockfile.]'
    )

    _dev=('(--dev)--dev[Save installed packages into the project"s package.json devDependencies]')

    _production=('(--production)--production[Do not install project devDependencies]')

    _1st_arguments=(
      'help:Display help information about yarn' \
      'init:Initialize for the development of a package.' \
      'add:Add a package to use in your current package.' \
      'install:Install all the dependencies listed within package.json in the local node_modules folder.' \
      'publish:Publish a package to a package manager.' \
      'remove:Remove a package that will no longer be used in your current package.' \
      'cache:Clear the local cache. It will be populated again the next time yarn or yarn install is run.' \
      'clean:Frees up space by removing unnecessary files and folders from dependencies.' \
      'check:Verifies that versions of the package dependencies in the current project’s package.json matches that of yarn’s lock file.' \
      'ls:List all installed packages.' \
      'global:Makes binaries available to use on your operating system.' \
      'info:<package> [<field>] - fetch information about a package and return it in a tree format.' \
      'outdated:Checks for outdated package dependencies.' \
      'run:Runs a defined package script.' \
      'self-update:Updates Yarn to the latest version.' \
      'upgrade:Upgrades packages to their latest version based on the specified range.' \
      'why:<query> - Show information about why a package is installed.'
    )
    _arguments \
    '*:: :->subcmds' && return 0

    if (( CURRENT == 1 )); then
        _describe -t commands "yarn subcommand" _1st_arguments
        return
    fi

    case "$words[1]" in
        add)
        _arguments \
        $_dopts \
        $_dev \
        $_production
        ;;
        install)
        _arguments \
        $_installopts \
        $_dopts \
        $_dev \
        $_no_color \
        $_production
        ;;
        update)
        _arguments \
        $_dopts
        ;;
        remove)
        _arguments \
        $_dopts
        ;;
        *)
        _arguments \
        ;;
    esac

}

compdef _yarn yarn
