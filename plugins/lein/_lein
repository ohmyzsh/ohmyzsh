#compdef lein

# Lein ZSH completion function
# Drop this somewhere in your $fpath (like /usr/share/zsh/site-functions)
# and rename it _lein

_lein() {
  if (( CURRENT > 2 )); then
    # shift words so _arguments doesn't have to be concerned with second command
    (( CURRENT-- ))
    shift words
    # use _call_function here in case it doesn't exist
    _call_function 1 _lein_${words[1]}
  else
    _values "lein command" \
      "change[Rewrite project.clj by applying a function.]" \
      "check[Check syntax and warn on reflection.]" \
      "classpath[Print the classpath of the current project.]" \
      "clean[Remove all files from project's target-path.]" \
      "compile[Compile Clojure source into .class files.]" \
      "deploy[Build and deploy jar to remote repository.]" \
      "deps[Download all dependencies.]" \
      "do[Higher-order task to perform other tasks in succession.]" \
      "help[Display a list of tasks or help for a given task.]" \
      "install[Install the current project to the local repository.]" \
      "jar[Package up all the project's files into a jar file.]" \
      "javac[Compile Java source files.]" \
      "new[Generate project scaffolding based on a template.]" \
      "plugin[DEPRECATED. Please use the :user profile instead.]" \
      "pom[Write a pom.xml file to disk for Maven interoperability.]" \
      "release[Perform :release-tasks.]" \
      "repl[Start a repl session either with the current project or standalone.]" \
      "retest[Run only the test namespaces which failed last time around.]" \
      "run[Run a -main function with optional command-line arguments.]" \
      "search[Search remote maven repositories for matching jars.]" \
      "show-profiles[List all available profiles or display one if given an argument.]" \
      "test[Run the project's tests.]" \
      "trampoline[Run a task without nesting the project's JVM inside Leiningen's.]" \
      "uberjar[Package up the project files and dependencies into a jar file.]" \
      "update-in[Perform arbitrary transformations on your project map.]" \
      "upgrade[Upgrade Leiningen to specified version or latest stable.]" \
      "vcs[Interact with the version control system.]" \
      "version[Print version for Leiningen and the current JVM.]" \
      "with-profile[Apply the given task with the profile(s) specified.]"
  fi
}

_lein_plugin() {
  _values "lein plugin commands" \
    "install[Download, package, and install plugin jarfile into ~/.lein/plugins]" \
    "uninstall[Delete the plugin jarfile: \[GROUP/\]ARTIFACT-ID VERSION]"
}


_lein_namespaces() {
  if [ -f "./project.clj" -a -d "$1" ]; then
    _values "lein valid namespaces" \
      $(find "$1" -type f -name "*.clj" -exec awk '/^\(ns */ {gsub("\\)", "", $2); print $2}' '{}' '+')
  fi
}


_lein_run() {
  _lein_namespaces "src/"
}

_lein_test() {
  _lein_namespaces "test/"
}
