#compdef -P (|./)launch_trial.sh

__launch_trial_list_tests()
{
  tests=($(./launch_trial.sh --list-tests))
  _describe -t tests 'Select test to run' tests
}

_launch_trial()
{
  typeset -A opt_args
  local context state line curcontext="$curcontext"

  local ret=1

  _arguments -C : \
    '(- 1 *)--help[show usage]'\
    '(- 1 *)--htmlcov[generate html coverage report in htmlcov surbdirectory]'\
    '(- 1 *)--list-tests[list all tests]'\
    ':projects:__launch_trial_list_tests' \
    && ret=0

  return $ret
}

_launch_trial "$@"
return $?

