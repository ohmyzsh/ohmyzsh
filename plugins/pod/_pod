#compdef pod
#autoload
# setopt XTRACE VERBOSE
# vim: ft=zsh sw=2 ts=2 et


# -----------------------------------------------------------------------------
#          FILE:  _pod
#   DESCRIPTION:  Cocoapods (0.33.1) autocomplete plugin for Oh-My-Zsh
#                 https://cocoapods.org
#                 Generated with `pod --completion-script
#        AUTHOR:  Alexandre Joly (alexandre.joly@mekanics.ch)
#        GITHUB:  https://github.com/mekanics
#       TWITTER:  @jolyAlexandre
#       VERSION:  0.0.5
# -----------------------------------------------------------------------------

local -a _subcommands
local -a _options

case "$words[2]" in
  help)
    case "$words[3]" in
      *) # pod help
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod help options" _options
      ;;
    esac
  ;;
  ipc)
    case "$words[3]" in
      list)
        case "$words[4]" in
          *) # pod ipc list
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod ipc list options" _options
          ;;
        esac
      ;;
      podfile)
        case "$words[4]" in
          *) # pod ipc podfile
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod ipc podfile options" _options
          ;;
        esac
      ;;
      repl)
        case "$words[4]" in
          *) # pod ipc repl
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod ipc repl options" _options
          ;;
        esac
      ;;
      spec)
        case "$words[4]" in
          *) # pod ipc spec
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod ipc spec options" _options
          ;;
        esac
      ;;
      update-search-index)
        case "$words[4]" in
          *) # pod ipc update-search-index
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod ipc update-search-index options" _options
          ;;
        esac
      ;;
      *) # pod ipc
        _subcommands=(
          "list:Lists the specifications known to CocoaPods."
          "podfile:Converts a Podfile to YAML."
          "repl:The repl listens to commands on standard input."
          "spec:Converts a podspec to JSON."
          "update-search-index:Updates the search index."
        )
        _describe -t commands "pod ipc subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod ipc options" _options
      ;;
    esac
  ;;
  init)
    case "$words[3]" in
      *) # pod init
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod init options" _options
      ;;
    esac
  ;;
  install)
    case "$words[3]" in
      *) # pod install
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--no-clean:Leave SCM dirs like \`.git\` and \`.svn\` intact after downloading"
          "--no-integrate:Skip integration of the Pods libraries in the Xcode project(s)"
          "--no-repo-update:Skip running \`pod repo update\` before install"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod install options" _options
      ;;
    esac
  ;;
  lib)
    case "$words[3]" in
      create)
        case "$words[4]" in
          *) # pod lib create
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod lib create options" _options
          ;;
        esac
      ;;
      lint)
        case "$words[4]" in
          *) # pod lib lint
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--no-clean:Lint leaves the build directory intact for inspection"
              "--no-subspecs:Lint skips validation of subspecs"
              "--only-errors:Lint validates even if warnings are present"
              "--quick:Lint skips checks that would require to download and build the spec"
              "--silent:Show nothing"
              "--subspec=NAME:Lint validates only the given subspec"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod lib lint options" _options
          ;;
        esac
      ;;
      *) # pod lib
        _subcommands=(
          "create:Creates a new Pod"
          "lint:Validates a Pod"
        )
        _describe -t commands "pod lib subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod lib options" _options
      ;;
    esac
  ;;
  list)
    case "$words[3]" in
      new)
        case "$words[4]" in
          *) # pod list new
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--update:Run \`pod repo update\` before listing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod list new options" _options
          ;;
        esac
      ;;
      *) # pod list
        _subcommands=(
          "new:Lists pods introduced in the master spec-repo since the last check"
        )
        _describe -t commands "pod list subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--update:Run \`pod repo update\` before listing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod list options" _options
      ;;
    esac
  ;;
  outdated)
    case "$words[3]" in
      *) # pod outdated
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--no-repo-update:Skip running \`pod repo update\` before install"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod outdated options" _options
      ;;
    esac
  ;;
  plugins)
    case "$words[3]" in
      create)
        case "$words[4]" in
          *) # pod plugins create
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod plugins create options" _options
          ;;
        esac
      ;;
      list)
        case "$words[4]" in
          *) # pod plugins list
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod plugins list options" _options
          ;;
        esac
      ;;
      search)
        case "$words[4]" in
          *) # pod plugins search
            _options=(
              "--full:Search by name, author, and description"
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod plugins search options" _options
          ;;
        esac
      ;;
      *) # pod plugins
        _subcommands=(
          "create:Creates a new plugin"
          "list:List all known plugins"
          "search:Search for known plugins"
        )
        _describe -t commands "pod plugins subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod plugins options" _options
      ;;
    esac
  ;;
  push)
    case "$words[3]" in
      *) # pod push
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod push options" _options
      ;;
    esac
  ;;
  repo)
    case "$words[3]" in
      add)
        case "$words[4]" in
          *) # pod repo add
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--shallow:Create a shallow clone (fast clone, but no push capabilities)"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod repo add options" _options
          ;;
        esac
      ;;
      lint)
        case "$words[4]" in
          *) # pod repo lint
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--only-errors:Lint presents only the errors"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod repo lint options" _options
          ;;
        esac
      ;;
      push)
        case "$words[4]" in
          *) # pod repo push
            _options=(
              "--allow-warnings:Allows pushing even if there are warnings"
              "--help:Show help banner of specified command"
              "--local-only:Does not perform the step of pushing REPO to its remote"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod repo push options" _options
          ;;
        esac
      ;;
      remove)
        case "$words[4]" in
          *) # pod repo remove
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod repo remove options" _options
          ;;
        esac
      ;;
      update)
        case "$words[4]" in
          *) # pod repo update
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod repo update options" _options
          ;;
        esac
      ;;
      *) # pod repo
        _subcommands=(
          "add:Add a spec repo."
          "lint:Validates all specs in a repo."
          "push:Push new specifications to a spec-repo"
          "remove:Remove a spec repo"
          "update:Update a spec repo."
        )
        _describe -t commands "pod repo subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod repo options" _options
      ;;
    esac
  ;;
  search)
    case "$words[3]" in
      *) # pod search
        _options=(
          "--full:Search by name, summary, and description"
          "--help:Show help banner of specified command"
          "--ios:Restricts the search to Pods supported on iOS"
          "--no-ansi:Show output without ANSI codes"
          "--osx:Restricts the search to Pods supported on OS X"
          "--stats:Show additional stats (like GitHub watchers and forks)"
          "--verbose:Show more debugging information"
          "--web:Searches on cocoapods.org"
        )
        _describe -t options "pod search options" _options
      ;;
    esac
  ;;
  setup)
    case "$words[3]" in
      *) # pod setup
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--no-shallow:Clone full history so push will work"
          "--push:Use this option to enable push access once granted"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod setup options" _options
      ;;
    esac
  ;;
  spec)
    case "$words[3]" in
      cat)
        case "$words[4]" in
          *) # pod spec cat
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--show-all:Pick from all versions of the given podspec"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod spec cat options" _options
          ;;
        esac
      ;;
      create)
        case "$words[4]" in
          *) # pod spec create
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod spec create options" _options
          ;;
        esac
      ;;
      edit)
        case "$words[4]" in
          *) # pod spec edit
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--show-all:Pick which spec to edit from all available versions of the given podspec"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod spec edit options" _options
          ;;
        esac
      ;;
      lint)
        case "$words[4]" in
          *) # pod spec lint
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--no-clean:Lint leaves the build directory intact for inspection"
              "--no-subspecs:Lint skips validation of subspecs"
              "--only-errors:Lint validates even if warnings are present"
              "--quick:Lint skips checks that would require to download and build the spec"
              "--silent:Show nothing"
              "--subspec=NAME:Lint validates only the given subspec"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod spec lint options" _options
          ;;
        esac
      ;;
      which)
        case "$words[4]" in
          *) # pod spec which
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--show-all:Print all versions of the given podspec"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod spec which options" _options
          ;;
        esac
      ;;
      *) # pod spec
        _subcommands=(
          "cat:Prints a spec file."
          "create:Create spec file stub."
          "edit:Edit a spec file."
          "lint:Validates a spec file."
          "which:Prints the path of the given spec."
        )
        _describe -t commands "pod spec subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod spec options" _options
      ;;
    esac
  ;;
  trunk)
    case "$words[3]" in
      add-owner)
        case "$words[4]" in
          *) # pod trunk add-owner
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod trunk add-owner options" _options
          ;;
        esac
      ;;
      me)
        case "$words[4]" in
          clean-sessions)
            case "$words[5]" in
              *) # pod trunk me clean-sessions
                _options=(
                  "--all:Removes all your sessions, except for the current one"
                  "--help:Show help banner of specified command"
                  "--no-ansi:Show output without ANSI codes"
                  "--silent:Show nothing"
                  "--verbose:Show more debugging information"
                )
                _describe -t options "pod trunk me clean-sessions options" _options
              ;;
            esac
          ;;
          *) # pod trunk me
            _subcommands=(
              "clean-sessions:Remove sessions"
            )
            _describe -t commands "pod trunk me subcommands" _subcommands
            _options=(
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod trunk me options" _options
          ;;
        esac
      ;;
      push)
        case "$words[4]" in
          *) # pod trunk push
            _options=(
              "--allow-warnings:Allows push even if there are lint warnings"
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod trunk push options" _options
          ;;
        esac
      ;;
      register)
        case "$words[4]" in
          *) # pod trunk register
            _options=(
              "--description=DESCRIPTION:An arbitrary description to easily identify your session later on."
              "--help:Show help banner of specified command"
              "--no-ansi:Show output without ANSI codes"
              "--silent:Show nothing"
              "--verbose:Show more debugging information"
            )
            _describe -t options "pod trunk register options" _options
          ;;
        esac
      ;;
      *) # pod trunk
        _subcommands=(
          "add-owner:Add an owner to a pod"
          "me:Display information about your sessions"
          "push:Publish a podspec"
          "register:Manage sessions"
        )
        _describe -t commands "pod trunk subcommands" _subcommands
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod trunk options" _options
      ;;
    esac
  ;;
  try)
    case "$words[3]" in
      *) # pod try
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod try options" _options
      ;;
    esac
  ;;
  update)
    case "$words[3]" in
      *) # pod update
        _options=(
          "--help:Show help banner of specified command"
          "--no-ansi:Show output without ANSI codes"
          "--no-clean:Leave SCM dirs like \`.git\` and \`.svn\` intact after downloading"
          "--no-integrate:Skip integration of the Pods libraries in the Xcode project(s)"
          "--no-repo-update:Skip running \`pod repo update\` before install"
          "--silent:Show nothing"
          "--verbose:Show more debugging information"
        )
        _describe -t options "pod update options" _options
      ;;
    esac
  ;;
  *) # pod
    _subcommands=(
      "help:Show help for the given command."
      "ipc:Inter-process communication"
      "init:Generate a Podfile for the current directory."
      "install:Install project dependencies"
      "lib:Develop pods"
      "list:List pods"
      "outdated:Show outdated project dependencies"
      "plugins:Show available CocoaPods plugins"
      "push:Temporary alias for the \`pod repo push\` command"
      "repo:Manage spec-repositories"
      "search:Searches for pods"
      "setup:Setup the CocoaPods environment"
      "spec:Manage pod specs"
      "trunk:Interact with the CocoaPods API (e.g. publishing new specs)"
      "try:Try a Pod!"
      "update:Update outdated project dependencies"
    )
    _describe -t commands "pod subcommands" _subcommands
    _options=(
      "--completion-script:Print the auto-completion script"
      "--help:Show help banner of specified command"
      "--no-ansi:Show output without ANSI codes"
      "--silent:Show nothing"
      "--verbose:Show more debugging information"
      "--version:Show the version of the tool"
    )
    _describe -t options "pod options" _options
  ;;
esac
