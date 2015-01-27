function cabal_sandbox_info() {
    cabal_files=(*.cabal(N))
    if [ $#cabal_files -gt 0 ]; then
        if [ -f cabal.sandbox.config ]; then
            echo "%{$fg[green]%}sandboxed%{$reset_color%}"
        else
            echo "%{$fg[red]%}not sandboxed%{$reset_color%}"
        fi
    fi
}

function _cabal_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "bench:Run the benchmark, if any (configure with UserHooks)"
          "build:Make this package ready for installation"
          "check:Check the package for common mistakes"
          "clean:Clean up after a build"
          "copy:Copy teh files into the install locations"
          "configure:Prepare to build the package"
          "fetch:Downloads packages for later installation"
          "haddock:Generate HAddock HTML documentation"
          "help:Help about commands"
          "hscolour:Generate HsColour colourised code, in HTML format"
          "info:Display detailed information about a particular package"
          "init:Interactively create a .cabal file"
          "install:Installs a list of packages"
          "list:List packages matching a search string"
          "register:Register this package with the compiler"
          "report:Upload build reports to a remote server"
          "sdist:Generate a source distribution file (.tar.gz)"
          "test:Run the test suite, if any (configure with UserHooks)"
          "unpack:Unpacks packages for user inspection"
          "update:Updates list of known packages"
          "upload:Uploads source packages to Hackage"
        )
        _describe -t subcommands 'cabal subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _cabal_commands cabal
