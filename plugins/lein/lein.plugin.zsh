function _lein_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "clean:remove compiled files and dependencies from project"
          "compile:ahead-of-time compile the project"
          "deps:download and install all dependencies"
          "help:display a list of tasks or help for a given task"
          "install:install the project and its dependencies in your local repository"
          "jar:create a jar file containing the compiled .class files"
          "new:create a new project skeleton"
          "pom:write a pom.xml file to disk for maven interop"
          "test:run the project's tests"
          "uberjar:Create a jar including the contents of each of deps"
          "upgrade:upgrade leiningen to the latest stable release"
          "version:print leiningen's version"
        )
        _describe -t subcommands 'leiningen subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _lein_commands lein
