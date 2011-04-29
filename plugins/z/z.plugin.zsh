# Copyright (c) 2011 goolic under the WTFPL license
# Using the z function created by rupa deadwyler on https://github.com/rupa/z


source $ZSH/plugins/z/z.sh

function precmd () {
   z --add "$(pwd -P)"
 }
