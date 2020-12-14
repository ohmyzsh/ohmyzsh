autoload -U regexp-replace
zmodload zsh/mathfunc

genpass-apple() {
  # Generates a 128-bit password of 6 pseudowords of 6 characters each
  # EG, xudmec-4ambyj-tavric-mumpub-mydVop-bypjyp
  # Can take a numerical argument for generating extra passwords
  local -i i j num

  [[ $1 =~ '^[0-9]+$' ]] && num=$1 || num=1

  local consonants="$(LC_ALL=C tr -cd b-df-hj-np-tv-xz < /dev/urandom \
    | head -c $((24*$num)))"
  local vowels="$(LC_ALL=C tr -cd aeiouy < /dev/urandom | head -c $((12*$num)))"
  local digits="$(LC_ALL=C tr -cd 0-9 < /dev/urandom | head -c $num)"

  # The digit is placed on a pseudoword edge using $base36. IE, Dvccvc or cvccvD
  local position="$(LC_ALL=C tr -cd 056bchinotuz < /dev/urandom | head -c $num)"
  local -A base36=(0 0 1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 a 10 b 11 c 12 d 13 \
    e 14 f 15 g 16 h 17 i 18 j 19 k 20 l 21 m 22 n 23 o 24 p 25 q 26 r 27 s 28 \
    t 29 u 30 v 31 w 32 x 33 y 34 z 35)

  for i in {1..$num}; do
    local pseudo=""

    for j in {1..12}; do
      # Uniformly iterate through $consonants and $vowels for each $i and $j
      # Creates cvccvccvccvccvccvccvccvccvccvccvccvc for each $num
      pseudo="${pseudo}${consonants:$((24*$i+2*${j}-26)):1}"
      pseudo="${pseudo}${vowels:$((12*$i+${j}-13)):1}"
      pseudo="${pseudo}${consonants:$((24*$i+2*${j}-25)):1}"
    done

    local -i digit_pos=${base36[${position[$i]}]}
    local -i char_pos=$digit_pos

    # The digit and uppercase character must be in different locations
    while [[ $digit_pos == $char_pos ]]; do
      char_pos=$base36[$(LC_ALL=C tr -cd 0-9a-z < /dev/urandom | head -c 1)]
    done

    # Places the digit on a pseudoword edge
    regexp-replace pseudo "^(.{$digit_pos}).(.*)$" \
      '${match[1]}${digits[$i]}${match[2]}'

    # Uppercase a random character (that is not a digit)
    regexp-replace pseudo "^(.{$char_pos})(.)(.*)$" \
      '${match[1]}${(U)match[2]}${match[3]}'

    # Hyphenate each 6-character pseudoword
    regexp-replace pseudo '^(.{6})(.{6})(.{6})(.{6})(.{6})(.{6})$' \
      '${match[1]}-${match[2]}-${match[3]}-${match[4]}-${match[5]}-${match[6]}'

    printf "${pseudo}\n"
  done
}

genpass-monkey() {
  # Generates a 128-bit base32 password as if monkeys banged the keyboard
  # EG, nz5ej2kypkvcw0rn5cvhs6qxtm
  # Can take a numerical argument for generating extra passwords
  local -i i num

  [[ $1 =~ '^[0-9]+$' ]] && num=$1 || num=1

  local pass=$(LC_ALL=C tr -cd '0-9a-hjkmnp-tv-z' < /dev/urandom \
    | head -c $((26*$num)))

  for i in {1..$num}; do
    printf "${pass:$((26*($i-1))):26}\n"
  done
}

genpass-xkcd() {
  # Generates a 128-bit XKCD-style passphrase
  # e.g, 9-mien-flood-Patti-buxom-dozes-ickier-pay-ailed-Foster
  # Can take a numerical argument for generating extra passwords

  if (( ! $+commands[shuf] )); then
    echo >&2 "$0: \`shuf\` command not found. Install coreutils (\`brew install coreutils\` on macOS)."
    return 1
  fi

  if [[ ! -e /usr/share/dict/words ]]; then
    echo >&2 "$0: no wordlist found in \`/usr/share/dict/words\`. Install one first."
    return 1
  fi

  local -i i num

  [[ $1 =~ '^[0-9]+$' ]] && num=$1 || num=1

  # Get all alphabetic words of at most 6 characters in length
  local dict=$(LC_ALL=C grep -E '^[a-zA-Z]{1,6}$' /usr/share/dict/words)

  # Calculate the base-2 entropy of each word in $dict
  # Entropy is e = L * log2(C), where L is the length of the password (here,
  # in words) and C the size of the character set (here, words in $dict).
  # Solve for e = 128 bits of entropy. Recall: log2(n) = log(n)/log(2).
  local -i n=$((int(ceil(128*log(2)/log(${(w)#dict})))))

  for i in {1..$num}; do
    printf "$n-"
    printf "$dict" | shuf -n "$n" | paste -sd '-' -
  done
}
