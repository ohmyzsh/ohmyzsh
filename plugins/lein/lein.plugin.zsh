function _lein_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "check:check syntax and warn on reflection."
          "classpath:print the classpath of the current project"
          "clean:remove compiled files and dependencies from project"
          "compile:ahead-of-time compile the project"
          "deploy:build jar and deploy to remote repository"
          "deps:download and install all dependencies"
          "do:Higher-order task to perform other tasks in succession."
          "help:display a list of tasks or help for a given task"
          "install:install the project and its dependencies in your local repository"
          "int:enter an interactive task shell"
          "interactive:enter an interactive task shell"
          "jack-in:jack in to a clojure slime session from emacs."
          "jar:create a jar file containing the compiled .class files"
          "javac:compile java source files"
          "keygen:Generate an SSH key pair for authentication with Clojars.org"
          "new:create a new project skeleton"
          "plugin:manage user-level plugins"
          "pom:write a pom.xml file to disk for maven interop"
          "pprint:Pretty-print a representation of the project map."
          "push:push a jar to the Clojars.org repository over scp"
          "repl:start a repl session either with the current project or standalone"
          "retest:run only the test namespaces which failed last time around"
          "run:run the project's -main function"
          "search:search remote maven repositories for matching jars"
          "show-profiles:list all available profiles or display one if given an argument."
          "swank:launch swank server for Emacs to connect"
          "test:run the project's tests"
          "test!:run a project's tests after cleaning and fetching dependencies"
          "trampoline:run a task without nesting the project's JVM inside Leiningen's."
          "uberjar:Create a jar including the contents of each of deps"
          "update-in:perform arbitrary transformations on your project map."
          "upgrade:upgrade leiningen to the latest stable release"
          "version:print leiningen's version"
          "with-profile:apply the given task with the profile(s) specified."
        )
        _describe -t subcommands 'leiningen subcommands' subcommands && ret=0
        ;;
      *) _files
    esac

    return ret
}

compdef _lein_commands lein