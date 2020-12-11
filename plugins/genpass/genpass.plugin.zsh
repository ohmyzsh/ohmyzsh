autoload -U regexp-replace
zmodload zsh/mathfunc

gen-apple-pass() {
  [[ $1 =~ '^[0-9]+$' ]] && local num=$1 || local num=1

  local i j
  local c="$(LC_ALL=C tr -cd b-df-hj-np-tv-xz < /dev/urandom | head -c $((24*$num)))"
  local v="$(LC_ALL=C tr -cd aeiouy < /dev/urandom | head -c $((12*$num)))"
  local n="$(LC_ALL=C tr -cd 0-9 < /dev/urandom | head -c $num)"
  local p="$(LC_ALL=C tr -cd 056bchinotuz < /dev/urandom | head -c $num)"
  typeset -A base36=(0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 a 10 b 11 c 12 \
    d 13 e 14 f 15 g 16 h 17 i 18 j 19 k 20 l 21 m 22 n 23 o 24 p 25 q 26 r 27 \
    s 28 t 29 u 30 v 31 w 32 x 33 y 34 z 35)

  for i in {1.."$num"}; do
    local pseudo=""

    for j in {1..12}; do
      # uniformly iterate through $c and $v for each $i and $j
      pseudo="${pseudo}${c:$((24*$i+2*${j}-26)):1}"   # consonant
      pseudo="${pseudo}${v:$((12*$i+${j}-13)):1}"     # vowel
      pseudo="${pseudo}${c:$((24*$i+2*${j}-25)):1}"   # consonant
    done

    local digit_pos=$base36[$p[$i]]
    local char_pos=$digit_pos

    while [[ "$digit_pos" -eq "$char_pos" ]]; do
      char_pos=$base36[$(LC_ALL=C tr -cd 0-9a-z < /dev/urandom | head -c 1)]
    done

    regexp-replace pseudo "^(.{$digit_pos}).(.*)$" \
      '${match[1]}${n[$i]}${match[2]}'
    regexp-replace pseudo "^(.{$char_pos})(.)(.*)$" \
      '${match[1]}${(U)match[2]}${match[3]}'
    regexp-replace pseudo '^(.{6})(.{6})(.{6})(.{6})(.{6})(.{6})$' \
      '${match[1]}-${match[2]}-${match[3]}-${match[4]}-${match[5]}-${match[6]}'

    printf "${pseudo}\n"
  done
}

gen-monkey-pass() {
  [[ $1 =~ '^[0-9]+$' ]] && local num=$1 || local num=1

  local i
  local pass=$(LC_ALL=C tr -cd '0-9a-hjkmnp-tv-z' < /dev/urandom | head -c $((26*$num)))

  for i in {1.."$num"}; do
    printf "${pass:$((26*($i-1))):26}\n"
  done
}

gen-xkcd-pass() {
  [[ $1 =~ '^[0-9]+$' ]] && local num=$1 || local num=1

  local i
  local dict=$(grep -E '^[a-zA-Z]{,6}$' /usr/share/dict/words)
  local n=$((int(ceil(128*log(2)/log(${(w)#dict})))))

  for i in {1.."$num"}; do
    printf "$n-"
    printf "$dict" | shuf -n "$n" | paste -sd '-'
  done
}
