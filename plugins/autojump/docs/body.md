KNOWN ISSUES
------------

-   autojump does not support directories that begin with `-`.

-   For bash users, autojump keeps track of directories by modifying
    `$PROMPT_COMMAND`. Do not overwrite `$PROMPT_COMMAND`:

        export PROMPT_COMMAND="history -a"

    Instead append to the end of the existing \$PROMPT\_COMMAND:

        export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a"

REPORTING BUGS
--------------

For any questions or issues please visit:

    https://github.com/wting/autojump/issues

AUTHORS
-------

autojump was originally written by Joël Schaerer, and currently maintained by
William Ting. More contributors can be found in `AUTHORS`.

COPYRIGHT
---------

Copyright © 2016 Free Software Foundation, Inc. License GPLv3+: GNU  GPL version
3 or later <http://gnu.org/licenses/gpl.html>. This is free software: you are
free to change and redistribute it. There is NO WARRANTY, to the extent
permitted by law.
