() {
  # %x: name of file containing code being executed
  local fortunes_dir="${${(%):-%x}:h}/fortunes"

  # Aliases
  alias chuck="fortune -a $fortunes_dir"
  alias chuck_cow="chuck | cowthink"

  # Automatically generate or update Chuck's compiled fortune data file
  if [[ "$fortunes_dir/chucknorris" -ot "$fortunes_dir/chucknorris.dat" ]]; then
    return
  fi

  # For some reason, Cygwin puts strfile in /usr/sbin, which is not on the path by default
  local strfile="${commands[strfile]:-/usr/sbin/strfile}"
  if [[ ! -x "$strfile" ]]; then
    echo "[oh-my-zsh] chucknorris depends on strfile, which is not installed" >&2
    echo "[oh-my-zsh] strfile is often provided as part of the 'fortune' package" >&2
    return
  fi

  # Generate the compiled fortune data file
  $strfile "$fortunes_dir/chucknorris" "$fortunes_dir/chucknorris.dat" >/dev/null
}
