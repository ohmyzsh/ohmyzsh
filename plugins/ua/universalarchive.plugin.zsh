alias ua='universalarchive'
alias ax='universalarchive tar.xz '

# exclusively POSIX shell syntax is used

universalarchive() { # compress a file or folder
  local file
  local parent
  local name

  local type="$1"
  local input="$2"

  if [ -f "$input" ]; then
    if [ "$#" -eq 2 ]; then
      name="${input%.[^.]*}"
    else
      file="$(realpath "$input")" 
      parent="${file%/*}" 
      name="${parent##*/}"
    fi
  elif [ -d "$input" ]; then
    name="${input%/*}"
  else
    echo "universalarchive(): archive a file or directory."
    echo "Usage:   ua <archive type> <files>"
    echo "Error: Please give a valid file or directory name!"
  fi

  if [ -f "${name}.${type}" ]; then
    name=$(mktemp --dry-run "./${name}_XXX.${type}")
  fi

  case "$type" in
    tar)          shift; tar      cvf            "${name}.tar"       "${@%%}" ;;
    tbz|tar.bz)   shift; tar      cvjf           "${name}.tar.bz2"   "${@%}"  ;;
    tbz2|tar.bz2) shift; tar      cvjf           "${name}.tar.bz2"   "${@%%}" ;;
    txz|tar.xz)   shift; env XZ_OPT=-T0 tar cvJf "${name}.tar.xz"    "${@%%}" ;;
    tgz|tar.gz)   shift; tar      cvzf           "${name}.tar.gz"    "${@%%}" ;;
    tZ|tar.Z)     shift; tar      cvZf           "${name}.tar.Z"     "${@%%}" ;;
    gz|gzip)      shift; gzip     -vcf           "${@%%}"          > "${name}.gz" ;;
    bz|bzip)      shift; bzip2    -vcf           "${@%%}"          > "${name}.bz" ;;
    bz2|bzip2)    shift; bzip2    -vcf           "${@%%}"          > "${name}.bz2" ;;
    Z|compress)   shift; compress -vcf           "${@%%}"          > "${name}.Z" ;;
    zip)          shift; zip      -rull          "${name}.zip"       "${@%%}" ;;
    7z|7zip)      shift; 7z       u              "${name}.7z"        "${@%%}" ;;
    rar)          shift; rar      a              "${name}.rar"       "${@%%}" ;;
    lzo)          shift; lzop     -vc            "${@%%}"          > "${name}.lzo" ;;
    xz)           shift; xz       -vc -T0        "${@%%}"          > "${name}.xz" ;;
    lzma)         shift; lzma     -vc            "${@%%}"          > "${name}.lzma" ;;
    *)  echo "universalarchive(): archive a file or directory."
        echo "Usage:   ua <archive type> <files>"
        echo "Example: ua tbz2 PKGBUILD"
        echo "Please specify archive type and files."
        echo "Valid archive types are:"
        echo "tar, tbz2, txz, tgz, tZ, gz, bz2, Z,"
        echo "zip, 7z, rar, lzo, xz, and lzma."                   ;;
  esac
}
