function ua() {
  local usage=\
"Archive files and directories using a given compression algorithm.

Usage:   $0 <format> <files>
Example: $0 tbz PKGBUILD

Supported archive formats are:
7z, bz2, gz, lzma, lzo, rar, tar, tbz (tar.bz2), tgz (tar.gz),
tlz (tar.lzma), txz (tar.xz), tZ (tar.Z), xz, Z, zip, and zst."

  if [[ $# -lt 2 ]]; then
    echo >&2 "$usage"
    return 1
  fi

  local ext="$1"
  local input="$(realpath "$2")"

  shift

  if [[ ! -e "$input" ]]; then
    echo >&2 "$input not found"
    return 1
  fi

  # generate output file name
  local output
  if [[ $# -gt 1 ]]; then
    output="$(basename "${input%/*}")"
  elif [[ -f "$input" ]]; then
    output="$(basename "${input%.[^.]*}")"
  elif [[ -d "$input" ]]; then
    output="$(basename "${input}")"
  fi

  # if output file exists, generate a random name
  if [[ -f "${output}.${ext}" ]]; then
    output=$(mktemp "${output}_XXX") && rm "$output" || return 1
  fi

  # add extension
  output="${output}.${ext}"

  # safety check
  if [[ -f "$output" ]]; then
    echo >&2 "output file '$output' already exists. Aborting"
    return 1
  fi

  case "$ext" in
    7z)           7z u                        "${output}"   "${@}" ;;
    bz2)          bzip2 -vcf                  "${@}" > "${output}" ;;
    gz)           gzip -vcf                   "${@}" > "${output}" ;;
    lzma)         lzma -vc -T0                "${@}" > "${output}" ;;
    lzo)          lzop -vc                    "${@}" > "${output}" ;;
    rar)          rar a                       "${output}"   "${@}" ;;
    tar)          tar -cvf                    "${output}"   "${@}" ;;
    tbz|tar.bz2)  tar -cvjf                   "${output}"   "${@}" ;;
    tgz|tar.gz)   tar -cvzf                   "${output}"   "${@}" ;;
    tlz|tar.lzma) XZ_OPT=-T0 tar --lzma -cvf  "${output}"   "${@}" ;;
    txz|tar.xz)   XZ_OPT=-T0 tar -cvJf        "${output}"   "${@}" ;;
    tZ|tar.Z)     tar -cvZf                   "${output}"   "${@}" ;;
    xz)           xz -vc -T0                  "${@}" > "${output}" ;;
    Z)            compress -vcf               "${@}" > "${output}" ;;
    zip)          zip -rull                   "${output}"   "${@}" ;;
    zst)          zstd -c -T0                 "${@}" > "${output}" ;;
    *) echo >&2 "$usage"; return 1 ;;
  esac
}
