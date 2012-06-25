function _lein_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
            "classpath:Print the classpath of the current project"
            "clean:Remove compiled class files and jars from project"
            "compile:Compile Clojure source into .class files"
            "deploy:Build jar and deploy to remote repository"
            "deps:Download :dependencies and put them in :library-path"
            "help:Display a list of tasks or help for a given task"
            "install:Install current project or download specified project"
            "interactive:Enter an interactive task shell. Aliased to 'int'"
            "jar:Package up all the project's files into a jar file"
            "javac:Compile Java source files"
            "new:Create a new project skeleton"
            "plugin:Manage user-level plugins"
            "pom:Write a pom.xml file to disk for Maven interop"
            "repl:Start a repl session either with the current project or standalone"
            "retest:Run only the test namespaces which failed last time around"
            "run:Run the project's -main function"
            "search:Search remote maven repositories for matching jars"
            "test:Run the project's tests"
            "test!:Run a project's tests after cleaning and fetching dependencies"
            "trampoline:Run a task without nesting the project's JVM inside Leiningen's"
            "uberjar:Package up the project files and all dependencies into a jar file"
            "upgrade:Upgrade"
            "version:Print version for Leiningen and the current JVM"
         )
        _describe -t subcommands 'leiningen subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _lein_commands lein
