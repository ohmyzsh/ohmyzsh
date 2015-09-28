#!zsh
##############################################################################
# A descriptive listing of core Gradle commands 
############################################################################
function _gradle_core_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "properties:Display all project properties"
          "tasks:Calculate and display all tasks"
          "dependencies:Calculate and display all dependencies"
          "projects:Discover and display all sub-projects"
          "build:Build the project"
          "help:Display help"
        )
        _describe -t subcommands 'gradle subcommands' subcommands && ret=0
    esac

    return ret
}

function _gradle_arguments() {
    _arguments -C \
    '-a[Do not rebuild project dependencies]' \
    '-h[Help]' \
    '-D[System property]' \
    '-d[Log at the debug level]' \
    '--gui[Launches the Gradle GUI app]' \
    '--stop[Stop the Gradle daemon]' \
    '--daemon[Use the Gradle daemon]' \
    '--no-daemon[Do not use the Gradle daemon]' \
    '--no-opt[Do not perform any task optimization]' \
    '-i[Log at the info level]' \
    '-m[Dry run]' \
    '-P[Set a project property]' \
    '--profile[Profile the build time]' \
    '-q[Log at the quiet level (only show errors)]' \
    '-v[Print the Gradle version info]' \
    '-x[Specify a task to be excluded]' \
    '*::command:->command' \
    && return 0
}


##############################################################################
# Are we in a directory containing a build.gradle file?
############################################################################
function in_gradle() {
    if [[ -f build.gradle ]]; then
        echo 1
    fi
}

############################################################################## Examine the build.gradle file to see if its
# timestamp has changed, and if so, regen
# the .gradle_tasks cache file
############################################################################
_gradle_does_task_list_need_generating () {
  [ ! -f .gradletasknamecache ] && return 0;
  [ build.gradle -nt .gradletasknamecache ] && return 0;
  return 1;
}


##############################################################################
# Discover the gradle tasks by running "gradle tasks --all"
############################################################################
_gradle_tasks () {
  if [ in_gradle ]; then
    _gradle_arguments
    if _gradle_does_task_list_need_generating; then
     gradle tasks --all | grep "^[ ]*[a-zA-Z0-9:]*\ -\ " | sed "s/ - .*$//" | sed "s/[\ ]*//" > .gradletasknamecache
    fi
    compadd -X "==== Gradle Tasks ====" `cat .gradletasknamecache`
  fi
}

_gradlew_tasks () {
  if [ in_gradle ]; then
    _gradle_arguments
    if _gradle_does_task_list_need_generating; then
     ./gradlew tasks --all | grep "^[ ]*[a-zA-Z0-9:]*\ -\ " | sed "s/ - .*$//" | sed "s/[\ ]*//" > .gradletasknamecache
    fi
    compadd -X "==== Gradlew Tasks ====" `cat .gradletasknamecache`
  fi
}


##############################################################################
# Register the completions against the gradle and gradlew commands
############################################################################
compdef _gradle_tasks gradle
compdef _gradlew_tasks gradlew


##############################################################################
# Open questions for future improvements:
# 1) Should 'gradle tasks' use --all or just the regular set?
# 2) Should gradlew use the same approach as gradle?
# 3) Should only the " - " be replaced with a colon so it can work
#     with the richer descriptive method of _arguments?
#     gradle tasks | grep "^[a-zA-Z0-9]*\ -\ " | sed "s/ - /\:/"
#############################################################################
