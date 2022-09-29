#!/bin/sh
#
# This script does not have a stable API.

_gitstatus_install_daemon_found() {
  local installed="$1"
  shift
  [ $# = 0 ] || "$@" "$daemon" "$version" "$installed"
}

_gitstatus_install_main() {
  if [ -n "${ZSH_VERSION:-}" ]; then
    emulate -L sh -o no_unset
  else
    set -u
  fi

  local argv1="$1"
  shift

  local no_check= no_install= uname_s= uname_m= gitstatus_dir= dl_status= e=
  local opt= OPTARG= OPTIND=1

  while getopts ':s:m:d:p:e:fnh' opt "$@"; do
    case "$opt" in
      h)
        command cat <<\END
Usage: install [-s KERNEL] [-m ARCH] [-d DIR] [-p CMD] [-e ERRFD] [-f|-n] [-- CMD [ARG]...]

If positional arguments are specified, call this on success:

  CMD [ARG]... DAEMON VERSION INSTALLED

DAEMON is path to gitstatusd. VERSION is a glob pattern for the
version this daemon should support; it's supposed to be passed as
-G to gitstatusd. INSTALLED is 1 if gitstatusd has just been
downloaded and 0 otherwise.

Options:

  -s KERNEL  use this instead of lowercase `uname -s`
  -m ARCH    use this instead of lowercase `uname -m`
  -d DIR     use this instead of `dirname "$0"`
  -p CMD     eval this every second while downloading gitstatusd
  -e ERRFD   write error messages to this file descriptor
  -f         download gitstatusd even if there is one locally
  -n         do not download gitstatusd (fail instead)
END
        return
      ;;
      n)
        if [ -n "$no_install" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        no_install=1
      ;;
      f)
        if [ -n "$no_check" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        no_check=1
      ;;
      d)
        if [ -n "$gitstatus_dir" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        if [ -z "$OPTARG" ]; then
          >&2 echo "[error] incorrect value of -$opt: $OPTARG"
          return 1
        fi
        gitstatus_dir="$OPTARG"
      ;;
      p)
        if [ -n "$dl_status" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        if [ -z "$OPTARG" ]; then
          >&2 echo "[error] incorrect value of -$opt: $OPTARG"
          return 1
        fi
        dl_status="$OPTARG"
      ;;
      e)
        if [ -n "$e" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        if [ -z "$OPTARG" ]; then
          >&2 echo "[error] incorrect value of -$opt: $OPTARG"
          return 1
        fi
        e="$OPTARG"
      ;;
      m)
        if [ -n "$uname_m" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        if [ -z "$OPTARG" ]; then
          >&2 echo "[error] incorrect value of -$opt: $OPTARG"
          return 1
        fi
        uname_m="$OPTARG"
      ;;
      s)
        if [ -n "$uname_s" ]; then
          >&2 echo "[gitstatus] error: duplicate option: -$opt"
          return 1
        fi
        if [ -z "$OPTARG" ]; then
          >&2 echo "[error] incorrect value of -$opt: $OPTARG"
          return 1
        fi
        uname_s="$OPTARG"
      ;;
      \?) >&2 echo "[gitstatus] error: invalid option: -$OPTARG"           ; return 1;;
      :)  >&2 echo "[gitstatus] error: missing required argument: -$OPTARG"; return 1;;
      *)  >&2 echo "[gitstatus] internal error: unhandled option: -$opt"   ; return 1;;
    esac
  done

  shift "$((OPTIND - 1))"

  : "${e:=2}"
  : "${gitstatus_dir:=$argv1}"

  if [ -n "$no_check" -a -n "$no_install" ]; then
    >&2 echo "[gitstatus] error: incompatible options: -f, -n"
    return 1
  fi

  if [ -z "$uname_s" ]; then
    uname_s="$(command uname -s)" || return
    uname_s="$(printf '%s' "$uname_s" | command tr '[A-Z]' '[a-z]')" || return
  fi
  if [ -z "$uname_m" ]; then
    uname_m="$(command uname -m)" || return
    uname_m="$(printf '%s' "$uname_m" | command tr '[A-Z]' '[a-z]')" || return
  fi

  local daemon="${GITSTATUS_DAEMON:-}"
  local cache_dir="${GITSTATUS_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/gitstatus}"

  if [ -z "$no_check" ]; then
    if [ -n "${daemon##/*}" ]; then
      >&2 echo "[gitstatus] error: GITSTATUS_DAEMON is not absolute path: $daemon"
      return 1
    fi
    if [ -z "$daemon" -a -e "$gitstatus_dir"/usrbin/gitstatusd ]; then
      daemon="$gitstatus_dir"/usrbin/gitstatusd
    fi
    if [ -n "$daemon" ]; then
      local gitstatus_version= libgit2_version=
      if ! . "$gitstatus_dir"/build.info; then
        >&2 echo "[gitstatus] internal error: failed to source build.info"
        return 1
      fi
      if [ -z "$gitstatus_version" ]; then
        >&2 echo "[gitstatus] internal error: empty gitstatus_version in build.info"
        return 1
      fi
      local version="$gitstatus_version"
      _gitstatus_install_daemon_found 0 "$@"
      return
    fi
  fi

  while IFS= read -r line; do
    line="${line###*}"
    [ -n "$line" ] || continue

    local uname_s_glob= uname_m_glob= file= version= sha256=
    eval "$line" || return

    if [ -z "$uname_s_glob" -o \
         -z "$uname_m_glob" -o \
         -z "$file"         -o \
         -z "$version"      -o \
         -z "$sha256" ]; then
      >&2 echo "[gitstatus] internal error: invalid install.info line: $line"
      return 1
    fi

    case "$uname_s" in
      $uname_s_glob) ;;
      *) continue;;
    esac
    case "$uname_m" in
      $uname_m_glob) ;;
      *) continue;;
    esac

    # Found a match. The while loop will terminate during this iteration.

    if [ -z "$no_check" ]; then
      # Check if a suitable gitstatusd already exists.
      local daemon="$gitstatus_dir"/usrbin/"$file"
      if [ ! -e "$daemon" ]; then
        daemon="$cache_dir"/"$file"
        [ -e "$daemon" ] || daemon=
      fi
      if [ -n "$daemon" ]; then
        _gitstatus_install_daemon_found 0 "$@"
        return
      fi
    fi

    # No suitable gitstatusd exists. Need to download.

    if [ -n "$no_install" ]; then
      >&2 echo "[gitstatus] error: no gitstatusd found and installation is disabled"
      return 1
    fi

    local daemon="$cache_dir"/"$file"

    if [ -n "${cache_dir##/*}" ]; then
      >&2 echo "[gitstatus] error: GITSTATUS_CACHE_DIR is not absolute: $cache_dir"
      return 1
    fi
    if [ ! -d "$cache_dir" ] && ! mkdir -p -- "$cache_dir" || [ ! -w "$cache_dir" ]; then
      local dir="$cache_dir"
      while true; do
        if [ -e "$dir" ]; then
          if [ ! -d "$dir" ]; then
            >&"$e" printf 'Not a directory: \033[4;31m%s\033[0m\n' "$dir"
            >&"$e" printf '\n'
            >&"$e" printf 'Delete it, then restart your shell.\n'
          elif [ ! -w "$dir" ]; then
            >&"$e" printf 'Directory is not writable: \033[4;31m%s\033[0m\n' "$dir"
            >&"$e" printf '\n'
            >&"$e" printf 'Make it writable, then restart your shell.\n'
          fi
          break
        fi
        if [ "$dir" = / ] || [ "$dir" = . ]; then
          break
        fi
        dir="$(dirname -- "$dir")"
      done
      return 1
    fi

    if [ -n "${TMPDIR-}" -a '(' '(' -d "${TMPDIR-}" -a -w "${TMPDIR-}" ')' -o '!' '(' -d /tmp -a -w /tmp ')' ')' ]; then
      local tmp="$TMPDIR"
    else
      local tmp=/tmp
    fi
    if ! command -v mktemp >/dev/null 2>&1 ||
       ! tmpdir="$(command mktemp -d "$tmp"/gitstatus-install.XXXXXXXXXX)"; then
      tmpdir="$tmp/gitstatus-install.tmp.$$"
      if ! mkdir -p -- "$tmpdir"; then
        if [ "$tmp" = /tmp ]; then
          local label='directory'
        else
          local label='directory (\033[1mTMPDIR\033[m)'
        fi
        if [ ! -e "$tmp" ]; then
          >&"$e" printf 'Temporary '"$label"' does not exist: \033[4;31m%s\033[0m\n' "$tmp"
          >&"$e" printf '\n'
          >&"$e" printf 'Create it, then restart your shell.\n'
        elif [ ! -d "$tmp" ]; then
          >&"$e" printf 'Not a '"$label"': \033[4;31m%s\033[0m\n' "$tmp"
          >&"$e" printf '\n'
          >&"$e" printf 'Make it a directory, then restart your shell.\n'
        elif [ ! -w "$tmp" ]; then
          >&"$e" printf 'Temporary '"$label"' is not writable: \033[4;31m%s\033[0m\n' "$tmp"
          >&"$e" printf '\n'
          >&"$e" printf 'Make it writable, then restart your shell.\n'
        fi
        return 1
      fi
    fi

    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
      >&"$e" printf 'Please install \033[32mcurl\033[0m or \033[32mwget\033[0m, then restart your shell.\n'
      return 1
    fi

    (
      run_cmd() {
        command -v "$1" >/dev/null 2>/dev/null || return 127
        local trapped= pid die ret
        trap 'trapped=1' $sig
        # The only reason for suppressing stderr is that `curl -f` cannot be silenced:
        # `-s` doesn't work despite what the docs say.
        command "$@" 2>/dev/null &
        ret="$?"
        if [ "$ret" = 0 ]; then
          pid="$!"
          die="trap - $sig; kill -- $pid 2>/dev/null; wait -- $pid 2>/dev/null; exit 1"
          trap "$die" $sig
          [ -z "$trapped" ] || eval "$die"
          wait -- "$pid" 2>/dev/null
          ret="$?"
        fi
        trap - $sig
        [ -z "$trapped" ] || exit
        return "$ret"
      }

      check_sha256() {
        local data_file="$tmpdir"/"$1".tar.gz
        local hash_file="$tmpdir"/"$1".tar.gz.sha256
        local hash=
        {
          command -v shasum >/dev/null 2>/dev/null                            &&
            run_cmd shasum -b -a 256 -- "$data_file" >"$hash_file" </dev/null &&
            IFS= read -r hash <"$hash_file"                                   &&
            hash="${hash%% *}"                                                &&
            [ ${#hash} -eq 64 ]
        } || {
          command -v sha256sum >/dev/null 2>/dev/null                         &&
            run_cmd sha256sum -b -- "$data_file" >"$hash_file" </dev/null     &&
            IFS= read -r hash <"$hash_file"                                   &&
            hash="${hash%% *}"                                                &&
            [ ${#hash} -eq 64 ]
        } || {
          # Note: sha256 can be from hashalot. It's incompatible.
          # Thankfully, it produces shorter output.
          command -v sha256 >/dev/null 2>/dev/null &&
            run_cmd sha256 -- "$data_file" >"$hash_file" </dev/null &&
            IFS= read -r hash <"$hash_file" &&
            hash="${hash##* }" &&
            [ ${#hash} -eq 64 ]
        } || {
          hash=
        }
        [ "$1" = 1 -a -z "$hash" -o "$hash" = "$sha256" ]
      }

      local url1="https://github.com/romkatv/gitstatus/releases/download/$version/$file.tar.gz"
      local url2="https://gitee.com/romkatv/gitstatus/raw/release-$version/release/$file.tar.gz"
      local sig='INT QUIT TERM ILL PIPE'

      fetch() {
        if [ "$1" != 1 ] && command -v sleep >/dev/null 2>/dev/null; then
          if ! run_cmd sleep "$1"; then
            echo -n >"$tmpdir"/"$1".status
            return 1
          fi
        fi
        local cmd part url ret
        for cmd in 'curl -kfsSL' 'wget -qO-' 'curl -q -kfsSL' 'wget --no-config -qO-'; do
          part=0
          while true; do
            if [ "$part" = 2 ]; then
              ret=1
              break
            elif [ "$part" = 0 ]; then
              url="$2"
            else
              url="$2"."$part"
            fi
            run_cmd $cmd -- "$url" >>"$tmpdir"/"$1".tar.gz
            ret="$?"
            [ "$ret" = 0 ] || break
            check_sha256 "$1" && break
            part=$((part+1))
          done
          [ "$ret" = 0 ] && break
          run_cmd rm -f -- "$tmpdir"/"$1".tar.gz && continue
          ret="$?"
          break
        done
        echo -n >"$tmpdir"/"$1".status
        return "$ret"
      }

      local trapped=
      trap 'trapped=1' $sig
      fetch 1 "$url1" &
      local pid1="$!"
      fetch 2 "$url2" &
      local pid2="$!"

      local die="trap - $sig; kill -- $pid1 $pid2 2>/dev/null; wait -- $pid1 $pid2 2>/dev/null; exit 1"
      trap "$die" $sig
      [ -z "$trapped" ] || eval "$die"

      local n=
      while true; do
        [ -z "$dl_status" ] || eval "$dl_status" || eval "$die"
        if command -v sleep >/dev/null 2>/dev/null; then
          command sleep 1
        elif command -v true >/dev/null 2>/dev/null; then
          command true
        fi
        if [ -n "$pid1" -a -e "$tmpdir"/1.status ]; then
          wait -- "$pid1" 2>/dev/null
          local ret="$?"
          pid1=
          if [ "$ret" = 0 ]; then
            if [ -n "$pid2" ]; then
              kill -- "$pid2" 2>/dev/null
              wait -- "$pid2" 2>/dev/null
            fi
            n=1
            break
          elif [ -z "$pid2" ]; then
            break
          else
            die="trap - $sig; kill -- $pid2 2>/dev/null; wait -- $pid2 2>/dev/null; exit 1"
            trap "$die" $sig
          fi
        elif [ -n "$pid2" -a -e "$tmpdir"/2.status ]; then
          wait -- "$pid2" 2>/dev/null
          local ret="$?"
          pid2=
          if [ "$ret" = 0 ]; then
            if [ -n "$pid1" ]; then
              kill -- "$pid1" 2>/dev/null
              wait -- "$pid1" 2>/dev/null
            fi
            n=2
            break
          elif [ -z "$pid1" ]; then
            break
          else
            die="trap - $sig; kill -- $pid1 2>/dev/null; wait -- $pid1 2>/dev/null; exit 1"
            trap "$die" $sig
          fi
        fi
      done

      trap - $sig

      if [ -z "$n" ]; then
        >&"$e" printf 'Failed to download \033[32m%s\033[0m from any mirror:\n' "$file"
        >&"$e" printf '\n'
        >&"$e" printf '  1. \033[4m%s\033[0m\n' "$url1"
        >&"$e" printf '  2. \033[4m%s\033[0m\n' "$url2"
        >&"$e" printf '\n'
        >&"$e" printf 'Check your internet connection, then restart your shell.\n'
        exit 1
      fi

      command tar -C "$tmpdir" -xzf "$tmpdir"/"$n".tar.gz || exit

      local tmpfile
      if ! command -v mktemp >/dev/null 2>&1 ||
         ! tmpfile="$(command mktemp "$cache_dir"/gitstatusd.XXXXXXXXXX)"; then
        tmpfile="$cache_dir"/gitstatusd.tmp.$$
      fi

      command mv -f -- "$tmpdir"/"$file" "$tmpfile" || exit
      command mv -f -- "$tmpfile" "$cache_dir"/"$file" && exit
      command rm -f -- "$cache_dir"/"$file"
      command mv -f -- "$tmpfile" "$cache_dir"/"$file" && exit
      command rm -f -- "$tmpfile"
      exit 1
    )

    local ret="$?"
    command rm -rf -- "$tmpdir"
    [ "$ret" = 0 ] || return

    _gitstatus_install_daemon_found 1 "$@"
    return
  done <"$gitstatus_dir"/install.info

  >&"$e" printf 'There is no prebuilt \033[32mgitstatusd\033[0m for \033[1m%s\033[0m.\n' "$uname_s $uname_m"
  >&"$e" printf '\n'
  >&"$e" printf 'See: \033[4mhttps://github.com/romkatv/gitstatus#compiling\033[0m\n'
  return 1
}

if [ -z "${0##*/*}" ]; then
  _gitstatus_install_main "${0%/*}" "$@"
else
  _gitstatus_install_main . "$@"
fi
