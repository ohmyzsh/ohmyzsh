function _lein_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "classpath:print the classpath of the current project"
          "clean:remove compiled files and dependencies from project"
          "compile:ahead-of-time compile the project"
          "deploy:build jar and deploy to remote repository"
          "deps:download and install all dependencies"
          "help:display a list of tasks or help for a given task"
          "install:install the project and its dependencies in your local repository"
          "int:enter an interactive task shell"
          "interactive:enter an interactive task shell"
          "jack-in:jack in to a clojure slime session from emacs."
          "jar:create a jar file containing the compiled .class files"
          "javac:compile java source files"
          "new:create a new project skeleton"
          "plugin:manage user-level plugins"
          "pom:write a pom.xml file to disk for maven interop"
          "repl:start a repl session either with the current project or standalone"
          "retest:run only the test namespaces which failed last time around"
          "run:run the project's -main function"
          "search:search remote maven repositories for matching jars"
          "swank:launch swank server for Emacs to connect"
          "test:run the project's tests"
          "test!:run a project's tests after cleaning and fetching dependencies"
          "trampoline:run a task without nesting the project's JVM inside Leiningen's."
          "uberjar:Create a jar including the contents of each of deps"
          "upgrade:upgrade leiningen to the latest stable release"
          "version:print leiningen's version"
        )
        _describe -t subcommands 'leiningen subcommands' subcommands && ret=0
        ;;
      *) _files
    esac

    return ret
}

compdef _lein_commands lein
