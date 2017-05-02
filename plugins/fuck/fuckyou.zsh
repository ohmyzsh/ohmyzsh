#!/usr/bin/env zsh

function swagdatstring() {
        local chars=" -_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        local flipped=" -_ɐqɔpǝɟɓɥıɾʞlɯuodbɹsʇnʌʍxʎz∀𐐒ƆᗡƎℲ⅁HIſ⋊⅂WNOԀΌᴚS⊥∩ΛMX⅄Z⇂ᄅƐㄣގ9ㄥ860"
        local newstring=''

        for ((i = ${#1}; i > 0; i--)); do
                newstring+=${flipped[${chars[(i)${1[$i]}*]}]}
        done
        echo $newstring
}

function fuck() {
        if [ $# -le 1 ]; then
                print "Usage: fuck you [process]"
                return 0
        fi

        if [ pkill -9 $@[2]]; then
                print "\n(╯°□°）╯︵ " $(swagdatstring $@[2]) "\n"
        else
                print "\n(；￣Д￣) . o O( It’s not very effective... )\n"
        fi
}
