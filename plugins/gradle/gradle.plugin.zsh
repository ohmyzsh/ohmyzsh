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
    '--rerun-task [Specifies that any task optimization is ignored.]' \
    '-i[Log at the info level]' \
    '-m[Dry run]' \
    '-P[Set a project property]' \
    '-p[Specifies the start directory]' \
    '--profile[Profile the build time]' \
    '-q[Log at the quiet level (only show errors)]' \
    '-v[Print the Gradle version info]' \
    '-x[Specify a task to be excluded]' \
    '-b[Specifies the build file.]' \
    '-c[Specifies the settings file.]' \
    '--continue[Continues task execution after a task failure.]' \
    '-g[Specifies the Gradle user home directory.]' \
    '-I[Specifies an initialization script.]' \
    '--refresh-dependencies[Refresh the state of dependencies.]' \
    '-u[Don''t search in parent directories for a settings.gradle file.]' \
    '*::command:->command' \
    && return 0
}


##############################################################################
# Examine the build.gradle file to see if its timestamp has changed;
# and if so, regenerate the .gradle_tasks cache file
############################################################################
_gradle_does_task_list_need_generating () {
  [[ ! -f .gradletasknamecache ]] || [[ build.gradle -nt .gradletasknamecache ]]
}

##############
# Parse the tasks from `gradle(w) tasks --all` into .gradletasknamecache
# All lines in the output from gradle(w) that are between /^-+$/ and /^\s*$/
# are considered to be tasks. If and when gradle adds support for listing tasks
# for programmatic parsing, this method can be deprecated.
##############
_gradle_parse_tasks () {
  lines_might_be_tasks=false
  task_name_buffer=""
  while read -r line; do
    if [[ $line =~ ^-+$ ]]; then
      lines_might_be_tasks=true
      # Empty buffer, because it contains items that are not tasks
      task_name_buffer=""
    elif [[ $line =~ ^\s*$ ]]; then
      if [[ "$lines_might_be_tasks" = true ]]; then
        # If a newline is found, send the buffer to .gradletasknamecache
        while read -r task; do
          echo $task | awk '/[a-zA-Z0-9:-]+/ {print $1}'
        done <<< "$task_name_buffer"
        # Empty buffer, because we are done with the tasks
        task_name_buffer=""
      fi
      lines_might_be_tasks=false
    elif [[ "$lines_might_be_tasks" = true ]]; then
      task_name_buffer="${task_name_buffer}\n${line}"
    fi
  done <<< "$1"
}

##############################################################################
# Discover the gradle tasks by running "gradle tasks --all"
############################################################################
_gradle_tasks () {
  if [[ -f build.gradle ]]; then
    _gradle_arguments
    if _gradle_does_task_list_need_generating; then
      _gradle_parse_tasks "$(gradle tasks --all)" > .gradletasknamecache
    fi
    compadd -X "==== Gradle Tasks ====" $(cat .gradletasknamecache)
  fi
}

_gradlew_tasks () {
  if [[ -f build.gradle ]]; then
    _gradle_arguments
    if _gradle_does_task_list_need_generating; then
      _gradle_parse_tasks "$(./gradlew tasks --all)" > .gradletasknamecache
    fi
    compadd -X "==== Gradlew Tasks ====" $(cat .gradletasknamecache)
  fi
}


##############################################################################
# Register the completions against the gradle and gradlew commands
############################################################################
compdef _gradle_tasks gradle
compdef _gradlew_tasks gradlew
