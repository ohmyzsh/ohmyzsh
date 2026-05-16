# ------------------------------------------------------------------------------
#          FILE:  sfffe.plugin.zsh
#   DESCRIPTION:  search file for FE
#        AUTHOR:  yleo77 (ylep77@gmail.com)
#       VERSION:  0.1
#       REQUIRE:  ack
# ------------------------------------------------------------------------------

if (( ! $+commands[ack] )); then
    echo "'ack' is not installed!"
    return
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
