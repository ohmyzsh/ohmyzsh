#compdef coffee
# ------------------------------------------------------------------------------
# Copyright (c) 2011 Github zsh-users - https://github.com/zsh-users
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the zsh-users nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ZSH-USERS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for Coffee.js v0.6.11 (https://coffeescript.org)
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Mario Fernandez (https://github.com/sirech)
#  * Dong Weiming (https://github.com/dongweiming)
#
# ------------------------------------------------------------------------------

local curcontext="$curcontext" state line ret=1 version opts first second third
typeset -A opt_args
version=(${(f)"$(_call_program version $words[1] --version)"})
version=${${(z)${version[1]}}[3]}
first=$(echo $version|cut -d '.' -f 1)
second=$(echo $version|cut -d '.' -f 2)
third=$(echo $version|cut -d '.' -f 3)
if (( $first < 2 )) &&  (( $second < 7 )) && (( $third < 3 ));then
  opts+=('(-l --lint)'{-l,--lint}'[pipe the compiled JavaScript through JavaScript Lint]'
         '(-r --require)'{-r,--require}'[require a library before executing your script]:library')
fi


_arguments -C \
  '(- *)'{-h,--help}'[display this help message]' \
  '(- *)'{-v,--version}'[display the version number]' \
  $opts \
  '(-b --bare)'{-b,--bare}'[compile without a top-level function wrapper]' \
  '(-e --eval)'{-e,--eval}'[pass a string from the command line as input]:Inline Script' \
  '(-i --interactive)'{-i,--interactive}'[run an interactive CoffeeScript REPL]' \
  '(-j --join)'{-j,--join}'[concatenate the source CoffeeScript before compiling]:Destination JS file:_files -g "*.js"' \
  '(--nodejs)--nodejs[pass options directly to the "node" binary]' \
  '(-c --compile)'{-c,--compile}'[compile to JavaScript and save as .js files]' \
  '(-o --output)'{-o,--output}'[set the output directory for compiled JavaScript]:Output Directory:_files -/' \
  '(-n -t -p)'{-n,--nodes}'[print out the parse tree that the parser produces]' \
  '(-n -t -p)'{-p,--print}'[print out the compiled JavaScript]' \
  '(-n -t -p)'{-t,--tokens}'[print out the tokens that the lexer/rewriter produce]' \
  '(-s --stdio)'{-s,--stdio}'[listen for and compile scripts over stdio]' \
  '(-w --watch)'{-w,--watch}'[watch scripts for changes and rerun commands]' \
  '*:script or directory:_files' && ret=0

return ret

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
