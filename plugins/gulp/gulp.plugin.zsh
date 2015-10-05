#!/usr/bin/env zsh

#
# gulp-autocompletion-zsh
#
# Autocompletion for your gulp.js tasks
#
# Copyright(c) 2014 André König <andre.koenig@posteo.de>
# MIT Licensed
#

#
# André König
# Github: https://github.com/akoenig
# Twitter: https://twitter.com/caiifr
#

#
# Grabs all available tasks from the `gulpfile.js`
# in the current directory.
#
function $$gulp_completion {
    compls=$(gulp --tasks-simple >/dev/null | sort)

    completions=(${=compls})
    compadd -- $completions
}

compdef $$gulp_completion gulp
