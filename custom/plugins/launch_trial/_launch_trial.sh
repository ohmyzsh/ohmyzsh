#compdef -P (|./)launch_trial.sh

__test_programs()
{
  tests=($(./launch_trial.sh --list-test-programs))
  _describe -t tests 'Select test program:' tests
}

__test_classes()
{
  testprogram="$words[2]"
  #echo "EXECUTING ./launch_trial.sh --list-test-classes $testprogram"
  classes=($(./launch_trial.sh --list-test-classes $testprogram))
  # echo "CLASSES= $classes"
  _describe -t classes 'Select class:' classes
}

__test_cases()
{
  testprogram="$words[2]"
  testclass="$words[3]"
  cases=($(./launch_trial.sh --list-test-cases $testprogram.$testclass))
  _describe -t cases 'Select test case:' cases
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
    '(- 1 *)--list-test-cases[list all test cases of a given test class]:class:__test_program_and_class' \
    ':project:__test_programs' \
    ':class:__test_classes' \
    ':testcase:__test_cases' \
    && ret=0

  return $ret
}

_launch_trial "$@"
return $?

