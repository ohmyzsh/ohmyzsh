function _lein_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "change:Rewrite project.clj by applying a function."
          "check:Check syntax and warn on reflection."
          "classpath:Print the classpath of the current project."
          "clean:Remove all files from project's target-path."
          "cljsbuild:Compile ClojureScript source into a JavaScript file."
          "compile:Compile Clojure source into .class files."
          "deploy:Build and deploy jar to remote repository."
          "deps:Download all dependencies."
          "do:Higher-order task to perform other tasks in succession."
          "figwheel:Autocompile ClojureScript and serve the changes over a websocket (+ plus static file server)."
          "help:Display a list of tasks or help for a given task."
          "install:Install the current project to the local repository."
          "jar:Package up all the project's files into a jar file."
          "javac:Compile Java source files."
          "minify-assets"
          "new:Generate project scaffolding based on a template."
          "plugin:DEPRECATED. Please use the :user profile instead."
          "pom:Write a pom.xml file to disk for Maven interoperability."
          "release:Perform :release-tasks."
          "repl:Start a repl session either with the current project or standalone."
          "retest:Run only the test namespaces which failed last time around."
          "run:Run a -main function with optional command-line arguments."
          "search:Search remote maven repositories for matching jars."
          "show-profiles:List all available profiles or display one if given an argument."
          "test:Run the project's tests."
          "trampoline:Run a task without nesting the project's JVM inside Leiningen's."
          "uberjar:Package up the project files and dependencies into a jar file."
          "update-in:Perform arbitrary transformations on your project map."
          "upgrade:Upgrade Leiningen to specified version or latest stable."
          "vcs:Interact with the version control system."
          "version:Print version for Leiningen and the current JVM."
          "with-profile:Apply the given task with the profile(s) specified."
        )
        _describe -t subcommands 'leiningen subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _lein_commands lein
