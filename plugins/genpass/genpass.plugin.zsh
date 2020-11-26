autoload -U regexp-replace
zmodload zsh/mathfunc

gen-apple-pass() {
    [[ $1 =~ '^[0-9]+$' ]] && local num=$1 || local num=1
    local c="$(tr -cd b-df-hj-np-tv-xz < /dev/urandom | head -c $((24*$num)))"
    local v="$(tr -cd aeiouy < /dev/urandom | head -c $((12*$num)))"
    local d="$(tr -cd 0-9 < /dev/urandom | head -c $num)"
    local p="$(tr -cd 056bchinotuz < /dev/urandom | head -c $num)"
    typeset -A base36=(0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 a 10 b 11 c 12 d 13 e 14 f 15 g 16 h 17 i 18
                       j 19 k 20 l 21 m 22 n 23 o 24 p 25 q 26 r 27 s 28 t 29 u 30 v 31 w 32 x 33 y 34 z 35)
    for i in {1.."$num"}; do
        unset pseudo
        for j in {1..12}; do
            # uniformly iterating through the large $c and $v strings for each $i and each $j
            pseudo="${pseudo}${c:$((-26+24*$i+2*$j)):1}${v:$((-13+12*$i+$j)):1}${c:$((-25+24*$i+2*$j)):1}"
        done
        local digit_pos=$base36[$p[$i]]
        local char_pos=$digit_pos
        while [[ "$digit_pos" -eq "$char_pos" ]]; do
            char_pos=$base36[$(tr -cd 0-9a-z < /dev/urandom | head -c 1)]
        done
        regexp-replace pseudo "^(.{$digit_pos}).(.*)$" '${match[1]}${d[$i]}${match[2]}'
        regexp-replace pseudo "^(.{$char_pos})(.)(.*)$" '${match[1]}${(U)match[2]}${match[3]}'
        regexp-replace pseudo '^(.{6})(.{6})(.{6})(.{6})(.{6})(.{6})$' \
                              '${match[1]}-${match[2]}-${match[3]}-${match[4]}-${match[5]}-${match[6]}'
        printf "${pseudo}\n"
    done
}
gen-monkey-pass() {
    [[ $1 =~ '^[0-9]+$' ]] && local num=$1 || local num=1
    local pass=$(tr -cd '0-9a-hjkmnp-tv-z' < /dev/urandom | head -c $((26*$num)))
    for i in {1.."$num"}; do
        printf "${pass:$((26*($i-1))):26}\n" # add newline
    done
}
gen-xkcd-pass() {
    [[ $1 =~ '^[0-9]+$' ]] && local num=$1 || local num=1
    local dict=$(grep -E '^[a-zA-Z]{,6}$' /usr/share/dict/words)
    local words=$((int(ceil(128*log(2)/log(${(w)#dict})))))
    for i in {1.."$num"}; do
        printf "$words-"
        printf "$dict" | shuf --random-source=/dev/urandom -n "$words" | paste -sd '-'
    done
}
