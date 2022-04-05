# ------------------------------------------------------------------------------
#          FILE:  sfffe.plugin.zsh
#   DESCRIPTION:  search file for FE
#        AUTHOR:  yleo77 (ylep77@gmail.com)
#       VERSION:  0.1
#       REQUIRE:  ack
# ------------------------------------------------------------------------------

<<<<<<< HEAD
if [ ! -x $(which ack) ]; then
    echo  \'ack\' is not installed!
    exit -1
=======
if (( ! $+commands[ack] )); then
    echo "'ack' is not installed!"
    return
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
fi

ajs() {
    ack "$@" --type js
}

acss() {
    ack "$@" --type css
}

fjs() {
    find ./ -name "$@*" -type f | grep '\.js'
}

fcss() {
    find ./ -name "$@*" -type f | grep '\.css'
}
