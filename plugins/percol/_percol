#compdef percol

local context state line
typeset -A opt_args

_arguments : \
    '1:input file name:_files' \
    '(--help -h)'{--help,-h}'[show this help message and exit]' \
    '--tty=[path to the TTY]:tty:{compadd $(find /dev/pts -print)}' \
    '--rcfile=[path to the settings file]:rc.py:_files -g \*\.py' \
    '--encoding=[encoding for input and output]:encoding:' \
    '--query=[pre-input query]:query:' \
    '--match-method=[specify matching method for query.]:match method:((string\:normal\ match regex\:regular\ expression migemo\:migemo))' \
    '--caret-position=[position of the caret]:caret position:' \
    '--initial-index=[position of the initial index of the selection]:initial index:(first last)' \
    '--peep[exit immediately without doing anything]'
