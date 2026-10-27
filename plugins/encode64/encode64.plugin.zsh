encode64() {
  if (( $# == 0 )); then
    base64
  else
    printf '%s' "$1" | base64
  fi
}

encodefile64() {
  if [[ $# -ne 1 || ! -f $1 || ! -r $1 ]]; then
    print -u2 -r -- 'Usage: encodefile64 <file>'
    return 1
  fi

  local out="${1}.txt"

  # `base64 < file` is the only portable form: GNU coreutils accepts a FILE
  # operand but not `-o`, while BSD/macOS base64 accepts neither the operand
  # (it needs `-i`, which on GNU means `--ignore-garbage`) nor `-o`.
  if ! base64 < "$1" > "$out"; then
    # Only remove a writable regular file: that can only be the partial output
    # our redirection just created. A failed `>` can also mean `$out` already
    # existed and was never touched (not writable, or a directory), and removing
    # that would delete data this plugin did not write.
    if [[ -f "$out" && -w "$out" ]]; then
      command rm -f -- "$out"
    fi
    return 1
  fi

  print -r -- "$1's content encoded in base64 and saved as $out"
}

decode64() {
  if (( $# == 0 )); then
    base64 --decode
  else
    printf '%s' "$1" | base64 --decode
  fi
}
alias e64=encode64
alias ef64=encodefile64
alias d64=decode64
