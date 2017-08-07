function _stack_package_name() {
  grep "^name: [^ ]*" *.cabal | sed "s/name: *//" | sed "s/--.*//"
}

function _stack_exes() {
  grep "^executable [^ ]*" *.cabal | sed "s/executable //" | sed "s/--.*//"
}

function _stack_tests() {
  PACK_NAME="$(_stack_package_name)"
  grep "^test-suite [^ ]*" *.cabal | sed "s/test-suite //" | sed "s/--.*//" | sed "s/\(.*\)/$PACK_NAME:\1/"
}

function _stack_commands() {
    local ret=1

    _arguments \
    '1: :->subcommand'\
    '2: :->options'\
    '*: :->flags' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "build:Build the project(s) in this directory/configuration"
          "install:Build executables and install to a user path"
          "test:Build and test the project(s) in this directory/configuration"
          "bench:Build and benchmark the project(s) in this directory/configuration"
          "haddock:Generate haddocks for the project(s) in this directory/configuration"
          "new:Create a brand new project"
          "init:Initialize a stack project based on one or more stack packages"
          "solver:Use a dependency solver to try and determine missing extra-deps"
          "setup:Get the appropriate ghc for your project"
          "path:Print out handy path information"
          "unpack:Unpack one or more packages locally"
          "update:Update the package index"
          "upgrade:Upgrade to the latest stack (experimental)"
          "upload:Upload a package to Hackage"
          "dot:Visualize your project's dependency graph using Graphviz dot"
          "exec:Execute a command"
          "ghc:Run ghc"
          "ghci:Run ghci in the context of project(s)"
          "ide:Run ide-backend-client with the correct arguments"
          "runghc:Run runghc"
          "clean:Clean the local packages"
          "docker:Subcommands specific to Docker use"
        )
        _describe -t subcommands 'stack subcommands' subcommands && ret=0
        ;;
      options)
        case $words[2] in
          'exec')
            compadd "$@" `_stack_exes`
            ;;
          'test')
            compadd "$@" `_stack_tests`
            ;;
          *)
            _files
        esac
        ;;
      *)
        case $words[2] in
          *)
            _files
        esac
    esac
    return ret
}

compdef _stack_commands stack
