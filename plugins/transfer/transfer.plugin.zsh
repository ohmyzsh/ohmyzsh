# Author:
#   Remco Verhoef <remco@dutchcoders.io>
#   https://gist.github.com/nl5887/a511f172d3fb3cd0e42d
#   Modified to use tar command instead of zip
#
usage() {
  cat <<EOF
Error: no arguments specified.

Usage: transfer [options] <file/folder>

Examples:
  transfer /tmp/test.md
  transfer -c /tmp/test.md
  transfer -d /tmp/test.md
  transfer -q /tmp/test.md
  transfer -m 10 /tmp/test.md

  cat /tmp/test.md | transfer test.md
  cat /tmp/test.md | transfer -c test.md
  cat /tmp/test.md | transfer -d test.md
  cat /tmp/test.md | transfer -q test.md
  cat /tmp/test.md | transfer -m 10 test.md

Options:
  -c   Encrypt file with symmetric cipher and create ASCII armored output
  -m   Sets the maximum number of downloads
  -d   Display the code to delete the file
  -q   Run without progress bar
EOF
}

transfer() {
  # check arguments
  if [[ $# -eq 0 ]]; then
    usage;
    return 1
  fi

  if (( ! $+commands[curl] )); then
    echo "Error: curl is not installed"
    return 1
  fi

  local tmpfile tarfile item basename

  local TRANSFER_URL=$(echo ${TRANSFER_CUSTOM_URL:-https://transfer.sh} | sed 's/\/$//g')

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

  local maxDownloads=""
  local displayDeleteCode=0
  local isNewVersion=0
  local progress="--progress-bar"

  while getopts ":m:dcf:q" flag; do
    isNewVersion=1

    case "$flag" in
      c)
        crypt=1
        if (( ! $+commands[gpg] )); then
          echo "Error: gpg is not installed"
          return 1
        fi
        ;;
      m)
        maxDownloads="Max-Downloads: ${OPTARG}"
        ;;
      d)
        displayDeleteCode=1
        ;;
      f)
        item=${OPTARG}
        ;;
      q)
        progress="-s"
        ;;
    esac
  done

  # Maintains compatibility with previous modification
  if [[ $isNewVersion -eq 1 ]]; then
    item="$@[-1]"
  fi

  
  if ! tty -s; then
    # transfer from pipe
    if (( crypt )); then
      gpg -aco - | curl -X PUT --dump-header "$tmpfile.dump" -H "$maxDownloads" "$progress" -T - "${TRANSFER_URL}/$item" >> $tmpfile
    else
      curl --dump-header "$tmpfile.dump" -H "$maxDownloads" "$progress" --upload-file - "${TRANSFER_URL}/$item" >> $tmpfile
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
        gpg -cao - "$tarfile" | curl --dump-header "$tmpfile.dump" -H "$maxDownloads" "$progress" -T "-" "${TRANSFER_URL}/$basename.tar.gz.gpg" >> $tmpfile
      else
        curl --dump-header "$tmpfile.dump" -H "$maxDownloads" "$progress" --upload-file "$tarfile" "${TRANSFER_URL}/$basename.tar.gz" >> $tmpfile
      fi
      rm -f $tarfile
    else
      # transfer file
      if (( crypt )); then
        gpg -cao - "$item" | curl --dump-header "$tmpfile.dump" -H "$maxDownloads" "$progress" -T "-" "${TRANSFER_URL}/$basename.gpg" >> $tmpfile
      else
        curl --dump-header "$tmpfile.dump" -H "$maxDownloads" "$progress" --upload-file "$item" "${TRANSFER_URL}/$basename" >> $tmpfile
      fi
    fi
  fi

  if [[ $displayDeleteCode -eq 1 ]]; then
    deleteCode="$(grep x-url-delete $tmpfile.dump | rev | cut -f1 -d'/' | rev)"
    echo "Delete Code: ${deleteCode}"
    echo "URL: $(cat $tmpfile)"
  else
    # cat output link
    cat $tmpfile
  fi

  # add newline
  echo

  # cleanup
  rm -f $tmpfile
  rm -f $tmpfile.dump
}