ua() { # compress a file or folder
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
    echo "Please give a valid file or directory name!"
  fi

  if [ -f "${name}.${type}" ]; then
    name=$(mktemp "./${name}_XXX.${type}") && rm "$name"
  fi

  if [ "$#" -ge 1 ]; then
    shift
  fi
  case "$type" in
    tar)          tar     -cvf            "${name}.tar"       "${@}" ;;
    tbz|tar.bz)   tar     -cvjf           "${name}.tar.bz2"   "${@}"  ;;
    tbz2|tar.bz2) tar     -cvjf           "${name}.tar.bz2"   "${@}" ;;
    txz|tar.xz)   XZ_OPT=-T0 tar -cvJf     "${name}.tar.xz"    "${@}" ;;
    tgz|tar.gz)   tar      -cvzf           "${name}.tar.gz"    "${@}" ;;
    tlz|tar.lzma) XZ_OPT=-T0 tar --lzma -cvf "${name}.tar.gz"  "${@}" ;;
    tZ|tar.Z)     tar      -cvZf           "${name}.tar.Z"     "${@}" ;;
    zip)          zip      -rull          "${name}.zip"       "${@}" ;;
    7z|7zip)      7z       u              "${name}.7z"        "${@}" ;;
    zst)          zstd     -c -T0         "${name}.zst"       "${@}" ;;
    rar)          rar      a              "${name}.rar"       "${@}" ;;
    lzo)          lzop     -vc            "${@}"            > "${name}.lzo" ;;
    gz|gzip)      gzip     -vcf           "${@}"            > "${name}.gz" ;;
    bz|bzip)      bzip2    -vcf           "${@}"            > "${name}.bz" ;;
    bz2|bzip2)    bzip2    -vcf           "${@}"            > "${name}.bz2" ;;
    Z|compress)   compress -vcf           "${@}"            > "${name}.Z" ;;
    xz)           xz       -vc -T0        "${@}"            > "${name}.xz" ;;
    lzma)         lzma     -vc -T0        "${@}"            > "${name}.lzma" ;;
    *)  echo "$0:      archive files or directory using a given compression algorithm."
        echo "Usage:   $0 <archive type> <files>"
        echo "Example: $0 tbz2 PKGBUILD"
        echo "Supported archive types are:"
        echo "tar, tbz2, txz, tgz, tZ, gz, bz2, Z,"
        echo "zip, 7z, zst, rar, lzo, xz, and lzma."                   ;;
  esac
}
