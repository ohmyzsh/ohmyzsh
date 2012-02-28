##
# function keys plugin: defines easy hooks you can implement or override
# to respond to F1-F12 keys

#F1
eval "f1() {zle push-line;LBUFFER+='fkey_f1';zle accept-line}"
zle -N f1
bindkey '^[OP' f1
#F2
eval "f2() {zle push-line;LBUFFER+='fkey_f2';zle accept-line}"
zle -N f2
bindkey '^[OQ' f2
#F3
eval "f3() {zle push-line;LBUFFER+='fkey_f3';zle accept-line}"
zle -N f3
bindkey '^[OR' f3
#F4
eval "f4() {zle push-line;LBUFFER+='fkey_f4';zle accept-line}"
zle -N f4
bindkey '^[OS' f4
#F5
eval "f5() {zle push-line;LBUFFER+='fkey_f5';zle accept-line}"
zle -N f5
bindkey '^[[15~' f5
#F6
eval "f6() {zle push-line;LBUFFER+='fkey_f6';zle accept-line}"
zle -N f6
bindkey '^[[17~' f6
#F7
eval "f7() {zle push-line;LBUFFER+='fkey_f7';zle accept-line}"
zle -N f7
bindkey '^[[18~' f7
#F8
eval "f8() {zle push-line;LBUFFER+='fkey_f8';zle accept-line}"
zle -N f8
bindkey '^[[19~' f8
#F9
eval "f9() {zle push-line;LBUFFER+='fkey_f9';zle accept-line}"
zle -N f9
bindkey '^[[20~' f9
#F10
eval "f10() {zle push-line;LBUFFER+='fkey_f10';zle accept-line}"
zle -N f10
bindkey '^[[21~' f10
#F11
eval "f11() {zle push-line;LBUFFER+='fkey_f11';zle accept-line}"
zle -N f11
bindkey '^[[23~' f11
#F12
eval "f12() {zle push-line;LBUFFER+='fkey_f12';zle accept-line}"
zle -N f12
bindkey '^[[24~' f12

function fkey_f1 {
         _undefined_fkey
}
function fkey_f2 {
         _undefined_fkey
}
function fkey_f3 {
         _undefined_fkey
}
function fkey_f4 {
         _undefined_fkey
}
function fkey_f5 {
         _undefined_fkey
}
function fkey_f6 {
         _undefined_fkey
}
function fkey_f7 {
         _undefined_fkey
}
function fkey_f8 {
         _undefined_fkey
}
function fkey_f9 {
         _undefined_fkey
}
function fkey_f10 {
         _undefined_fkey
}
function fkey_f11 {
         _undefined_fkey
}
function fkey_f12 {
         _undefined_fkey
}
function _undefined_fkey {
         echo "Undefined key action"
}


