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
# GitHub: https://github.com/akoenig
# Twitter: https://twitter.com/caiifr
#

#
# Grabs all available tasks from the `gulpfile.js`
# in the current directory.
#
function _gulp_completion {
    compls=$(gulp --tasks-simple 2>/dev/null)

    completions=(${=compls})
    compadd -- $completions
}

compdef _gulp_completion gulp
