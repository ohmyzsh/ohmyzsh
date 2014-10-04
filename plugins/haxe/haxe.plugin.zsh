export HXCOMPLETEVERSION="0.1.0"

# Aliases
alias   hl='haxelib'
compdef hl=haxelib
alias   hli='haxelib install'
compdef _haxelib hli=haxelib-install
alias   hlr='haxelib run'
compdef _haxelib hlr=haxelib-run
alias	hll='haxelib list'
compdef _haxelib hll=haxelib-list

alias   hlinvalidate='rm -f /tmp/haxelib_*' #invalidates completion cache.