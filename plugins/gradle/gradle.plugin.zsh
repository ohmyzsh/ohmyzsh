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
    '-b[Specifies the build file]' \
    '-c[Specifies the settings file]' \
    '-d[Log at the debug level]' \
    '-g[Specifies the Gradle user home directory]' \
    '-h[Shows a help message]' \
    '-i[Set log level to INFO]' \
    '-m[Runs the build with all task actions disabled]' \
    '-p[Specifies the start directory for Gradle]' \
    '-q[Log errors only]' \
    '-s[Print out the stacktrace also for user exceptions]' \
    '-t[Continuous mode. Automatically re-run build after changes]' \
    '-u[Don''t search in parent directories for a settings.gradle file]' \
    '-v[Prints Gradle version info]' \
    '-x[Specify a task to be excluded]' \
    '-D[Set a system property]' \
    '-I[Specifies an initialization script]' \
    '-P[Sets a project property of the root project]' \
    '-S[Print out the full (very verbose) stacktrace]' \
    '--build-file[Specifies the build file]' \
    '--configure-on-demand[Only relevant projects are configured]' \
    '--console[Type of console output to generate (plain, auto, or rich)]' \
    '--continue[Continues task execution after a task failure]' \
    '--continuous[Continuous mode. Automatically re-run build after changes]' \
    '--daemon[Use the Gradle Daemon]' \
    '--debug[Log at the debug level]' \
    '--dry-run[Runs the build with all task actions disabled]' \
    '--exclude-task[Specify a task to be excluded]' \
    '--full-stacktrace[Print out the full (very verbose) stacktrace]' \
    '--gradle-user-home[Specifies the Gradle user home directory]' \
    '--gui[Launches the Gradle GUI app (Deprecated)]' \
    '--help[Shows a help message]' \
    '--include-build[Run the build as a composite, including the specified build]' \
    '--info[Set log level to INFO]' \
    '--init-script[Specifies an initialization script]' \
    '--max-workers[Set the maximum number of workers that Gradle may use]' \
    '--no-daemon[Do not use the Gradle Daemon]' \
    '--no-rebuild[Do not rebuild project dependencies]' \
    '--no-search-upwards[Don''t search in parent directories for a settings.gradle file]' \
    '--offline[Build without accessing network resources]' \
    '--parallel[Build projects in parallel]' \
    '--profile[Profile build time and create report]' \
    '--project-cache-dir[Specifies the project-specific cache directory]' \
    '--project-dir[Specifies the start directory for Gradle]' \
    '--project-prop[Sets a project property of the root project]' \
    '--quiet[Log errors only]' \
    '--recompile-scripts[Forces scripts to be recompiled, bypassing caching]' \
    '--refresh-dependencies[Refresh the state of dependencies]' \
    '--rerun-task[Specifies that any task optimization is ignored]' \
    '--settings-file[Specifies the settings file]' \
    '--stacktrace[Print out the stacktrace also for user exceptions]' \
    '--status[Print Gradle Daemon status]' \
    '--stop[Stop all Gradle Daemons]' \
    '--system-prop[Set a system property]' \
    '--version[Prints Gradle version info]' \
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
# Parse the tasks from `gradle(w) tasks --all` and return them to the calling function.
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
        # If a newline is found, echo the buffer to the calling function
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


##############
# Gradle tasks from subprojects are allowed to be executed without specifying
# the subproject; that task will then be called on all subprojects.
# gradle(w) tasks --all only lists tasks per subproject, but when autocompleting
# we often want to be able to run a specific task on all subprojects, e.g.
# "gradle clean".
# This function uses the list of tasks from "gradle tasks --all", and for each
# line grabs everything after the last ":" and combines that output with the original
# output. The combined list is returned as the result of this function.
##############
_gradle_parse_and_extract_tasks () {
  # All tasks
  tasks=$(_gradle_parse_tasks "$1")
  # Task name without sub project(s) prefix
  simple_tasks=$(echo $tasks | awk 'BEGIN { FS = ":" } { print $NF }')
  echo "$tasks\n$simple_tasks"
}

##############################################################################
# Discover the gradle tasks by running "gradle tasks --all"
############################################################################
_gradle_tasks () {
  if [[ -f build.gradle ]]; then
    _gradle_arguments
    if _gradle_does_task_list_need_generating; then
      _gradle_parse_and_extract_tasks "$(gradle tasks --all)" > .gradletasknamecache
    fi
    compadd -X "==== Gradle Tasks ====" $(cat .gradletasknamecache)
  fi
}

_gradlew_tasks () {
  if [[ -f build.gradle ]]; then
    _gradle_arguments
    if _gradle_does_task_list_need_generating; then
      _gradle_parse_and_extract_tasks "$(./gradlew tasks --all)" > .gradletasknamecache
    fi
    compadd -X "==== Gradlew Tasks ====" $(cat .gradletasknamecache)
  fi
}


##############################################################################
# Register the completions against the gradle and gradlew commands
############################################################################
compdef _gradle_tasks gradle
compdef _gradlew_tasks gradlew
