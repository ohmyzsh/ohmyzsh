#compdef -P (|./)launch_trial.sh

__test_programs()
{
  tests=($(./launch_trial.sh --list-test-programs))
  _describe -t tests 'Select test program:' tests
}

__test_program_and_class()
{
  _arguments -C : \
    '2: :__test_programs' \
    '3: :__test_programs' 
}

_launch_trial()
{
  typeset -A opt_args
  local context state line curcontext="$curcontext"

  local ret=1

  _arguments -C : \
    '(- 1 *)--help[show usage]' \
    '(- 1 *)--htmlcov[generate html coverage report in htmlcov surbdirectory]' \
    '(- 1 *)--list-test-programs[list all test programs]' \
    '(- 1 *)--list-test-classes[list test classes for a given test program]:programs:__test_programs' \
    '(- 1 *)--list-test-methods[list all test method of a given test class]:class:__test_program_and_class' \
    ':projects:__test_programs' \
    && ret=0

  return $ret
}

_launch_trial "$@"
return $?

