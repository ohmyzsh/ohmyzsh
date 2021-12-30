# Author:
#   Remco Verhoef <remco@dutchcoders.io>
#   https://gist.github.com/nl5887/a511f172d3fb3cd0e42d
#   Modified to use tar command instead of zip
#

transfer() {
  # check arguments
  if [[ $# -eq 0 ]]; then
  cat <<EOF
Error: no arguments specified.

Usage: transfer [file/folder] [options]

Examples:
  transfer /tmp/test.md
  transfer /tmp/test.md -ca
  cat /tmp/test.md | transfer test.md
  cat /tmp/test.md | transfer test.md -ca

Options:
  -ca  Encrypt file with symmetric cipher and create ASCII armored output
EOF
  return 1
  fi

  if (( ! $+commands[curl] )); then
    echo "Error: curl is not installed"
    return 1
  fi

  local tmpfile tarfile item basename

  # get temporarily filename, output is written to this file show progress can be showed
  tmpfile=$(mktemp -t transferXXX)

  # upload stdin or file
  item="$1"

  # crypt file with symmetric cipher and create ASCII armored output
  local crypt=0
  if [[ "$2" = -ca ]]; then
    crypt=1
    if (( ! $+commands[gpg] )); then
      echo "Error: gpg is not installed"
      return 1
    fi
  fi

  if ! tty -s; then
    # transfer from pipe
    if (( crypt )); then
      gpg -aco - | curl -X PUT --progress-bar -T - "https://transfer.sh/$item" >> $tmpfile
    else
      curl --progress-bar --upload-file - "https://transfer.sh/$item" >> $tmpfile
    fi
  else
    basename=$(basename "$item" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

    if [[ ! -e $item ]]; then
      echo "File $item doesn't exist."
      return 1
    fi

    if [[ -d $item ]]; then
      # tar directory and transfer
      tarfile=$(mktemp -t transferXXX.tar.gz)
      cd $(dirname $item) || {
        echo "Error: Could not change to directory $(dirname $item)"
        return 1
      }

      tar -czf $tarfile $(basename $item)
      if (( crypt )); then
        gpg -cao - "$tarfile" | curl --progress-bar -T "-" "https://transfer.sh/$basename.tar.gz.gpg" >> $tmpfile
      else
        curl --progress-bar --upload-file "$tarfile" "https://transfer.sh/$basename.tar.gz" >> $tmpfile
      fi
      rm -f $tarfile
    else
      # transfer file
      if (( crypt )); then
        gpg -cao - "$item" | curl --progress-bar -T "-" "https://transfer.sh/$basename.gpg" >> $tmpfile
      else
        curl --progress-bar --upload-file "$item" "https://transfer.sh/$basename" >> $tmpfile
      fi
    fi
  fi

  # cat output link
  cat $tmpfile
  # add newline
  echo

  # cleanup
  rm -f $tmpfile
}
