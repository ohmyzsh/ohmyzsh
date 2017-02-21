function _stack_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "build:Build the package(s) in this directory/configuration"
          "install:Shortcut for \'build --copy-bins\'"
          "uninstall:DEPRECATED\: This command performs no actions, and is present for documentation only"
          "test:Shortcut for \'build --test\'"
          "bench:Shortcut for \'build --bench\'"
          "haddock:Shortcut for \'build --haddock\'"
          "new:Create a new project from a template. Run \`stack templates\' to see available templates."
          "templates:List the templates available for \`stack new\'."
          "init:Create stack project config from cabal or hpack package specifications"
          "solver:Add missing extra-deps to stack project config"
          "setup:Get the appropriate ghc for your project"
          "path:Print out handy path information"
          "unpack:Unpack one or more packages locally"
          "update:Update the package index"
          "upgrade:Upgrade to the latest stack"
          "upload:Upload a package to Hackage"
          "sdist:Create source distribution tarballs"
          "dot:Visualize your project's dependency graph using Graphviz dot"
          "ghc:Run ghc"
          "hoogle:Run hoogle in the context of the current Stack config"
          "exec:Execute a command"
          "ghci:Run ghci in the context of project(s) (experimental)"
          "repl:Run ghci in the context of package(s) (experimental) (alias for \'ghci\')"
          "runghc:Run runghc"
          "runhaskell:Run runghc (alias for \'runghc\')"
          "eval:Evaluate some haskell code inline. Shortcut for \'stack exec ghc -- -e CODE\'"
          "clean:Clean the local packages"
          "list-dependencies:List the dependencies"
          "query:Query general build information (experimental)"
          "ide:IDE-specific commands"
          "docker:Subcommands specific to Docker use"
          "config:Subcommands specific to modifying stack.yaml files"
          "image:Subcommands specific to imaging"
          "hpc:Subcommands specific to Haskell Program Coverage"
        )
        _describe -t subcommands 'stack subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _stack_commands stack
