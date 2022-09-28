#compdef nvm
# ------------------------------------------------------------------------------
# Copyright (c) 2011 Github zsh-users - http://github.com/zsh-users
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
#  Completion script for nvm (https://github.com/creationix/nvm).
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * Changwoo Park (https://github.com/pismute)
#
# ------------------------------------------------------------------------------

local curcontext="$curcontext" state line  ret=1

local -a _1st_arguments
_1st_arguments=(
  'help:Show this message'
  'install:Download and install a <version>'
  'uninstall:Uninstall a <version>'
  'use:Modify PATH to use <version>'
  'run:Run <version> with <args> as arguments'
  'ls:List installed [versions]'
  'ls-remote:List remote versions available for install'
  'deactivate:Undo effects of NVM on current shell'
  'alias:Set an alias named <name> pointing to <version>. Show all aliases beginning with [<pattern>].'
  'unalias:Deletes the alias named <name>'
  'copy-packages:Install global NPM packages contained in <version> to current version'
  'clear-cache:Clear cache'
  'version:Show current node version'
)

_arguments -C \
  '1: :->cmds' \
  '*: :->args' && ret=0

__nvm_aliases(){
  local aliases
  aliases=""
  if [ -d $NVM_DIR/alias ]; then
    aliases="`cd $NVM_DIR/alias && ls`"
  fi
  echo "${aliases}"
}

__nvm_versions(){
  echo "$(nvm_ls) $(__nvm_aliases)"
}

case $state in
  cmds)
    _describe -t commands 'nvm command' _1st_arguments && ret=0
    ;;

  args)
    case $words[2] in
      (use|run|ls|list|install|uninstall|copy-packages)

        _values 'version' $(__nvm_versions) && ret=0
        ;;

      (alias|unalias)

        _values 'aliases' $(__nvm_aliases) && ret=0
        ;;

      *)
        (( ret )) && _message 'no more arguments'
        ;;

    esac
    ;;
esac

return ret

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
