################################################################################
# Zsh-z - jump around with Zsh - A native Zsh version of rupa/z without awk,
# sort, date, or sed
#
# https://github.com/agkozak/zsh-z
#
# Copyright (c) 2018-2026 Alexandros Kozak
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Zsh-z maintains a jump-list of the directories you actually use.
#
# INSTALL:
#   * put something like this in your .zshrc:
#       source /path/to/zsh-z.plugin.zsh
#   * cd around for a while to build up the database
#
# USAGE:
#   * z foo       cd to the most frecent directory matching foo
#   * z foo bar   cd to the most frecent directory matching both foo and bar
#                   (e.g. /foo/bat/bar/quux)
#   * z -r foo    cd to the highest ranked directory matching foo
#   * z -t foo    cd to most recently accessed directory matching foo
#   * z -l foo    List matches instead of changing directories
#   * z -e foo    Echo the best match without changing directories
#   * z -c foo    Restrict matches to subdirectories of PWD
#   * z -x        Remove a directory (default: PWD) from the database
#   * z -xR       Remove a directory (default: PWD) and its subdirectories from
#                   the database
#
# ENVIRONMENT VARIABLES:
#
#   ZSHZ_CASE -> if `ignore', pattern matching is case-insensitive; if `smart',
#     pattern matching is case-insensitive only when the pattern is all
#     lowercase
#   ZSHZ_CD -> the directory-changing command that is used (default: builtin cd)
#   ZSHZ_CMD -> name of command (default: z)
#   ZSHZ_COMPLETION -> completion method (default: 'frecent'; 'legacy' for
#     alphabetic sorting)
#   ZSHZ_DATA -> name of datafile (default: ~/.z)
#   ZSHZ_DEBUG -> if set, turn on debugging aids: WARN_CREATE_GLOBAL while the
#     command runs and per-function warnings (functions -W) at load time
#     (default: unset)
#   ZSHZ_ECHO -> if 1, print the directory name after jumping to it (default: 0)
#   ZSHZ_EXCLUDE_DIRS -> array of directories to exclude from your database
#     (default: empty)
#   ZSHZ_KEEP_DIRS -> array of directories that should not be removed from the
#     database, even if they are not currently available (default: empty)
#   ZSHZ_LOCK_TIMEOUT -> seconds to wait for the lockfile before giving up
#     (default: 1)
#   ZSHZ_MAX_SCORE -> maximum combined score the database entries can have
#     before beginning to age (default: 9000)
#   ZSHZ_NO_RESOLVE_SYMLINKS -> '1' prevents symlink resolution
#   ZSHZ_OWNER -> your username (if you want use Zsh-z while using sudo -s)
#   ZSHZ_TILDE -> if 1, display ~ in place of the full $HOME path in output
#     (default: 0)
#   ZSHZ_TRAILING_SLASH -> if 1, a query ending in / matches at the end of a
#     directory path (default: 0)
#   ZSHZ_UNCOMMON -> if 1, do not jump to "common directories," but rather drop
#     subdirectories based on what the search string was (default: 0)
################################################################################

# Minimalistic solution to allow this plugin to keep running under sh/bash/ksh
# emulation while continuing to use Zsh-only syntax features. `emulate zsh -c'
# evaluates its argument as code, so the script's own path -- `${(%):-%N}' --
# must be `${(q)}'-quoted; otherwise an install directory containing spaces or
# other shell-special characters (common on Cygwin/MSYS2 and macOS, where a
# home directory can be "C:\Users\John Smith" or "/Users/John Smith") would be
# word-split and the plugin would silently fail to re-source.
if [[ -o KSH_ARRAYS || -o SH_WORD_SPLIT ]]; then
  emulate zsh -c "source ${(q)${(%):-%N}}"
  return $?
fi

autoload -Uz is-at-least

if ! is-at-least 4.3.11; then
  print "Zsh-z requires Zsh v4.3.11 or higher." >&2
  return 1 2> /dev/null || exit 1
fi

############################################################
# The help message
#
# Globals:
#   ZSHZ_CMD
############################################################
_zshz_usage() {
  print "Usage: ${ZSHZ_CMD:-${_Z_CMD:-z}} [OPTION]... [ARGUMENT]
Jump to a directory that you have visited frequently or recently, or a bit of both, based on the partial string ARGUMENT.

With no ARGUMENT, list the directory history in ascending rank.

  --add Add a directory to the database
  -c    Only match subdirectories of the current directory
  -e    Echo the best match without going to it
  -h    Display this help and exit
  -l    List all matches without going to them
  -r    Match by rank
  -t    Match by recent access
  -x    Remove a directory from the database (by default, the current directory)
  -xR   Remove a directory and its subdirectories from the database (by default, the current directory)" |
    fold -s -w $(( COLUMNS > 0 ? COLUMNS : 80 )) >&2
}

############################################################
# Canonicalize a path in the manner of `:A' -- normalize it
# lexically as `:a' does, then resolve symlinks -- without
# requiring any of the path to exist.
#
# `${x:A}' itself cannot be trusted with a missing path on
# Zsh 4.3.11: when the top-level component of $x does not
# exist (`/gone/sub'), the realpath machinery segfaults the
# shell (upstream bug, 4.3.11 only; deeper missing
# components are handled correctly on every version). So
# apply `:A' only to the deepest ancestor of the path that
# exists -- `:A' on an existing path is safe everywhere --
# and reattach the missing components verbatim. That
# reproduces `:A' exactly: `:A' resolves the symlinks in the
# existing prefix and carries the nonexistent tail
# unchanged, and the tail cannot contain live symlinks
# precisely because it does not exist. (A broken symlink
# stops the ancestor walk without being resolved -- `-e'
# fails on one -- which also matches `:A', which leaves
# broken symlinks unresolved.)
#
# Arguments:
#   $1 The path to canonicalize
#
# Returns the canonical path in $REPLY.
############################################################
_zshz_realpath() {
  local dir=${1:a}
  local -a tail

  # `:h' at its fixed point (`/', or `//' where the OS treats that as
  # distinct) can climb no higher; if even that much of the path does not
  # exist, settle for the lexical normalization rather than hand `:A'
  # something dangerous.
  while [[ ! -e $dir && $dir != "${dir:h}" ]]; do
    tail=( "${dir:t}" "${tail[@]}" )
    dir=${dir:h}
  done
  [[ -e $dir ]] && dir=${dir:A}

  # `typeset -g': REPLY belongs to the caller by design. A plain assignment
  # would trip WARN_NESTED_VAR under `ZSHZ_DEBUG', since _zshz_realpath is a
  # top-level function and thus one of the ones `functions -W' marks.
  if (( ${#tail} )); then
    typeset -g REPLY=${dir%/}/${(j:/:)tail}
  else
    typeset -g REPLY=$dir
  fi
}

# Load zsh/datetime module, if necessary
(( ${+EPOCHSECONDS} )) || zmodload zsh/datetime

# Global associative array for internal use
typeset -gA ZSHZ

# Fallback utilities in case Zsh lacks zsh/files (as is the case with MobaXterm)
ZSHZ[CHMOD]='chmod'
ZSHZ[CHOWN]='chown'
ZSHZ[MV]='mv'
ZSHZ[RM]='rm'

# Try to load zsh/files. zf_chown, zf_mv, and zf_rm are usually present in Zsh
# 4.3.11. zf_chmod only became available in Zsh 5.0, so we load it separately
# below. If zsh/files is not available at all, we silently fall back to the
# external utilities chmod, chown, mv, and rm.
if [[ ${builtins[zf_chown]-} != 'defined' ||
      ${builtins[zf_mv]-}    != 'defined' ||
      ${builtins[zf_rm]-}    != 'defined' ]]; then
  zmodload -F zsh/files b:zf_chown b:zf_mv b:zf_rm &> /dev/null
fi

[[ ${builtins[zf_chmod]-} == 'defined' ]] ||
    zmodload -F zsh/files b:zf_chmod &> /dev/null

# Use zsh/files, if it is available.
[[ ${builtins[zf_chmod]-} == 'defined' ]] && ZSHZ[CHMOD]='zf_chmod'
[[ ${builtins[zf_chown]-} == 'defined' ]] && ZSHZ[CHOWN]='zf_chown'
[[ ${builtins[zf_mv]-} == 'defined' ]] && ZSHZ[MV]='zf_mv'
[[ ${builtins[zf_rm]-} == 'defined' ]] && ZSHZ[RM]='zf_rm'

# Load zsh/system, if necessary
[[ ${modules[zsh/system]-} == 'loaded' ]] || zmodload zsh/system &> /dev/null

# Make sure ZSHZ_EXCLUDE_DIRS has been declared so that other scripts can
# simply append to it
(( ${+ZSHZ_EXCLUDE_DIRS} )) || typeset -gUa ZSHZ_EXCLUDE_DIRS

# Determine if zsystem flock is available
zsystem supports flock &> /dev/null && ZSHZ[USE_FLOCK]=1

# Windows only: how many times to retry a datafile rename that fails.
#
# On Cygwin and MSYS2, rename() fails with EBUSY or EACCES whenever another
# process holds the tempfile or the datafile open without FILE_SHARE_DELETE --
# which is precisely what a virus scanner or the search indexer does to a file
# in the moments after it is created. Since the write path below creates the
# tempfile and renames it over the datafile microseconds later, that window is
# wide open. The rename's stderr is discarded there, so a scan that lands in
# the window silently loses an `--add' or a `-x': no message, no delay, just a
# directory that never made it into the database. The condition clears in
# milliseconds, so make a few more attempts before giving up.
#
# Everywhere else a failed rename means something real -- ENOSPC, EPERM, a
# cross-device move -- that retrying cannot fix and would only add latency to,
# so ZSHZ[MV_RETRIES] stays unset and the loops below make a single attempt,
# exactly as before.
#
# zsh/zselect provides the sub-second delay between attempts without forking
# /bin/sleep, whose fractional-seconds support is not portable in any case.
# MobaXterm's cut-down Cygwin does not ship zsh/zselect, so there
# ZSHZ[MV_RETRY_DELAY] stays unset and the retries happen back to back -- still
# worth making, since the scanner's handle is often gone by the next attempt.
#
# Four retries at 50ms is deliberately modest rather than generous. The rename
# runs while the lockfile is held, so every millisecond spent retrying is a
# millisecond other writers spend waiting, and they give up after
# ZSHZ_LOCK_TIMEOUT (1s by default) -- silently, since their adds are
# best-effort too. A budget that outlasts a large fraction of that timeout
# would trade one process's lost write for several others'. Measured on MSYS2
# against a handle held open with FILE_SHARE_READ, this recovers renames
# blocked for up to ~0.3s, comfortably more than a scan of a file this small
# takes.
if [[ $OSTYPE == (cygwin|msys) ]]; then
  ZSHZ[MV_RETRIES]=4
  [[ ${modules[zsh/zselect]-} == 'loaded' ]] || zmodload zsh/zselect &> /dev/null
  # In hundredths of a second, per `zselect -t'
  [[ ${builtins[zselect]-} == 'defined' ]] && ZSHZ[MV_RETRY_DELAY]=5
fi

############################################################
# The Zsh-z Command
#
# Globals:
#   ZSHZ
#   ZSHZ_CASE
#   ZSHZ_CD
#   ZSHZ_COMPLETION
#   ZSHZ_DATA
#   ZSHZ_DEBUG
#   ZSHZ_EXCLUDE_DIRS
#   ZSHZ_KEEP_DIRS
#   ZSHZ_LOCK_TIMEOUT
#   ZSHZ_MAX_SCORE
#   ZSHZ_OWNER
#
# Arguments:
#   $* Command options and arguments
############################################################
zshz() {

  # Don't use `emulate -L zsh' - it breaks PUSHD_IGNORE_DUPS
  setopt LOCAL_OPTIONS NO_KSH_ARRAYS NO_SH_WORD_SPLIT EXTENDED_GLOB UNSET
  (( ZSHZ_DEBUG )) && setopt LOCAL_OPTIONS WARN_CREATE_GLOBAL

  local REPLY
  local -a lines

  # Allow the user to specify a custom datafile in $ZSHZ_DATA (or legacy $_Z_DATA)
  local custom_datafile="${ZSHZ_DATA:-$_Z_DATA}"

  # $_zshz_quiet_add marks the automatic bookkeeping add that _zshz_precmd
  # runs in a `&!' fork before every prompt (_zshz_precmd declares it `local',
  # so it is visible here only through that one call). A fork cannot
  # record anything in the parent shell, so it has no way to warn just once:
  # an unusable $ZSHZ_DATA would otherwise put the same diagnostic on the
  # terminal at every prompt for the life of the shell. Stay quiet on that
  # path and leave the complaining to the entry points the user actually
  # invoked -- including a hand-typed `z --add', which is not marked and so
  # still reports.
  local quiet
  [[ -n ${_zshz_quiet_add-} ]] && quiet=1

  # If a datafile was provided as a standalone file without a directory path
  # print a warning and return
  if [[ -n ${custom_datafile} && ${custom_datafile} != */* ]]; then
    (( quiet )) ||
      print "ERROR: You configured a custom Zsh-z datafile (${custom_datafile}), but have not specified its directory." >&2
    return 1
  fi

  # Refuse a symlinked datafile while $ZSHZ_OWNER is set, rather than
  # following it. That variable means root is acting for an unprivileged user
  # -- the documented `sudo -s' setup -- and the resolution just below
  # deliberately dereferences a link, so in that configuration Zsh-z would
  # write the database wherever a name inside the user's own home points, with
  # root's authority. Nothing has to be raced: the link is planted before the
  # privileged shell ever starts. Unprivileged use crosses no such boundary and
  # keeps the dereference, which is what makes pointing `.z' at synced storage
  # work.
  #
  # Every component, not just the last. Resolution walks the whole path, so a
  # symlinked *parent* redirects it just as effectively: with `link' -> `/etc'
  # inside a user's home, a datafile of `~/link/passwd' resolves to
  # `/etc/passwd' and root rewrites it.
  #
  # Judged by who owns each link rather than by its mere presence. Symlinked
  # system directories are ordinary -- `/home' -> `/usr/home' on the BSDs,
  # `/var' -> `/private/var' on macOS -- and refusing those would break Zsh-z
  # under $ZSHZ_OWNER on those systems for nothing. Those are root's; what this
  # has to reject is a link an unprivileged owner could have planted. `zstat
  # -L' reports the link's own owner rather than its target's, which is the
  # distinction `-O' cannot make.
  if [[ -n ${ZSHZ_OWNER:-${_Z_OWNER}} ]]; then
    local _zshz_df=${custom_datafile:-$HOME/.z}
    [[ $_zshz_df == /* ]] || _zshz_df="$PWD/$_zshz_df"
    zmodload -F zsh/stat b:zstat 2> /dev/null
    local _zshz_pfx _zshz_part _zshz_luid
    for _zshz_part in ${(s:/:)_zshz_df}; do
      [[ -n $_zshz_part ]] || continue
      _zshz_pfx+="/$_zshz_part"
      [[ -L $_zshz_pfx ]] || continue
      # Without zsh/stat there is no way to tell whose link this is, so refuse
      # it rather than guess: this path is privileged by definition.
      _zshz_luid=''
      (( ${+builtins[zstat]} )) &&
        _zshz_luid=$(zstat -L +uid "$_zshz_pfx" 2> /dev/null)
      if [[ $_zshz_luid != 0 ]]; then
        (( quiet )) ||
          print "ERROR: Zsh-z will not follow the symlink ${_zshz_pfx} on the way to its datafile while ZSHZ_OWNER is set." >&2
        return 1
      fi
    done
  fi

  # If the user specified a datafile, use that or default to ~/.z
  # If the datafile is a symlink, it gets dereferenced (except under
  # $ZSHZ_OWNER, refused just above). Canonicalized with
  # _zshz_realpath rather than a bare `:A', which would segfault Zsh 4.3.11
  # on a $ZSHZ_DATA pointing into a missing top-level directory -- at every
  # prompt, since this line runs in the backgrounded precmd add.
  _zshz_realpath "${custom_datafile:-$HOME/.z}"
  local datafile=$REPLY
  # Clear REPLY as soon as it is captured: the matching machinery below
  # relies on it staying empty until a common root or best match is put in
  # it (_zshz_find_common_root only assigns REPLY when it finds a root), so
  # a datafile path left in REPLY here would surface as a bogus match.
  REPLY=''

  # If the datafile is a directory, print a warning and return
  if [[ -d $datafile ]]; then
    (( quiet )) ||
      print "ERROR: Zsh-z's datafile (${datafile}) is a directory." >&2
    return 1
  fi

  # Make sure that the datafile exists before attempting to read it or lock it
  # for writing. Create it with 0600 permissions from the first instant (umask
  # in a subshell) rather than chmodding it afterward: this creation runs
  # before the lock is taken, and on Cygwin/MSYS2 a concurrent writer's rename
  # passes through a window in which the datafile is unlinked or delete-
  # pending, so any second syscall on the path (chmod) -- or even the creating
  # open itself -- can fail spuriously. Append mode (>>) creates the file
  # without truncating one that a concurrent writer has just renamed into
  # place. The first attempt is silent; if the file still does not exist
  # afterward (so no concurrent writer supplied it), retry loudly so that real
  # failures (directory permissions, read-only filesystem) reach the user.
  [[ -f $datafile ]] || {
    mkdir -p "${datafile:h}" &&
      ( umask 077; : >> "$datafile" ) 2> /dev/null ||
      [[ -f $datafile ]] ||
      ( umask 077; : >> "$datafile" )
    # When $ZSHZ_OWNER is set (e.g. under `sudo -s'), hand the freshly created
    # file off to that user immediately, so a query-only invocation can't leave
    # behind a root-owned .z that the normal-user shell can't read. `-h' so a
    # symlink that appeared since the check above is retitled itself rather
    # than dereferenced onto its target.
    local _owner=${ZSHZ_OWNER:-${_Z_OWNER}}
    [[ -n $_owner ]] &&
      ${ZSHZ[CHOWN]} -h "${_owner}:$(id -ng "${_owner}")" "$datafile"
  }

  # If the datafile still does not exist, the loud retry above has already
  # said why; nothing below -- reading, locking, writing -- can succeed
  # without it, and each failure would add its own noise. Bailing out here
  # matters most on Zsh 4.3.11, where the failed `$(< $datafile)' reads
  # below are fatal to a non-interactive shell.
  [[ -f $datafile ]] || return 1

  # Bail if we don't own the datafile and $ZSHZ_OWNER is not set
  [[ -z ${ZSHZ_OWNER:-${_Z_OWNER}} && -f $datafile && ! -O $datafile ]] &&
    return

  ############################################################
  # Add a path to or remove one from the datafile
  #
  # Globals:
  #   ZSHZ
  #   ZSHZ_EXCLUDE_DIRS
  #   ZSHZ_LOCK_TIMEOUT
  #   ZSHZ_NO_RESOLVE_SYMLINKS
  #   ZSHZ_OWNER
  #
  # Arguments:
  #   $1 Which action to perform (--add/--remove)
  #   $2 The path to add
  ############################################################
  _zshz_add_or_remove_path() {
    local action=$1
    shift

    if [[ $action == '--add' ]]; then

      # These $HOME / $ZSHZ_EXCLUDE_DIRS guards mirror the ones in
      # _zshz_precmd, but they are not redundant: precmd filters $PWD as an
      # early-out (skip the background fork), whereas --add is now a public
      # entry point and must enforce the same policies as the precmd function.
      # Keep both in sync.

      # Don't add $HOME
      [[ $* == $HOME ]] && return

      # Don't track directory trees excluded in $ZSHZ_EXCLUDE_DIRS
      local exclude
      for exclude in ${(@)ZSHZ_EXCLUDE_DIRS:-${(@)_Z_EXCLUDE_DIRS}}; do
        case $* in
          ${exclude}|${exclude}/*) return ;;
        esac
      done
    fi

    # Resolve the directory to be removed, and confirm a full-database wipe,
    # *before* taking the lock. Both are independent of the datafile, and the
    # confirmation is interactive: holding the lock across a `read -q' the user
    # might walk away from would make concurrent writers in other shells time
    # out on ZSHZ_LOCK_TIMEOUT and silently drop their adds while the prompt
    # sits open. A lock should wrap the read-modify-write, never a question.
    local xdir  # Directory to be removed
    if [[ $action == '--remove' ]]; then
      # The target is canonicalized without any existence test: an entry
      # whose directory has since been deleted is exactly the one a user most
      # wants out of the database. _zshz_realpath resolves a missing path the
      # way `:A' resolves one -- and, unlike a bare `:A', cannot segfault Zsh
      # 4.3.11 on a path whose top-level component is gone. (The old
      # `[[ -d ${...:A} ]]' guard offered no protection there: the `:A'
      # expands, and crashes, before `-d' ever sees it.)
      if (( ${ZSHZ_NO_RESOLVE_SYMLINKS:-${_Z_NO_RESOLVE_SYMLINKS}} )); then
        xdir=${${*:-${PWD}}:a}
      else
        _zshz_realpath "${*:-${PWD}}"
        xdir=$REPLY
      fi

      # Both branches above yield a non-empty absolute path, and that
      # matters: under `-R' an empty $xdir would collapse the subtree filter
      # below into `${lines_to_keep:#/**}', which matches every line in the
      # datafile and erases the lot -- silently, since the whole-database
      # confirmation just below tests for `/' rather than for emptiness. Keep
      # this guard in case a future change lets an empty resolution through.
      [[ -n $xdir ]] || return 1

      if (( ${+opts[-R]} )) && [[ $xdir == '/' ]]; then
        if ! read -q "?Delete entire Zsh-z database? "; then
          print && return 1
        fi
      fi
    fi

    # A temporary file that gets copied over the datafile if all goes well
    local tempfile="${datafile}.${RANDOM}" lockfile="${datafile}.lock"
    integer lockfd=0
    # The no-flock fallback's lock. Deliberately a *different* name from
    # $lockfile: a plain file left behind by a flock-capable Zsh would make
    # `mkdir' fail forever on the same path, deadlocking every later write.
    local lockdir="${datafile}.lock.d"
    integer lockdir_held=0

    {
      # Using zsystem flock
      if (( ZSHZ[USE_FLOCK] )); then

        # Obtain an exclusive lock on the lockfile.
        #
        # Locking the datafile directly would not actually serialize concurrent
        # writers, since the datafile gets replaced by mv and each new datafile
        # has a new inode -- so a separate, stable lockfile is needed.
        #
        # Bound the lock acquisition (default 1s, override with ZSHZ_LOCK_TIMEOUT)
        # so a stuck holder can't stall the backgrounded precmd add or freeze a
        # user's foreground `z --add' / `z -x'. Once the holder dies, the kernel
        # frees the lock and the next add succeeds automatically -- no manual
        # `rm ~/.z.lock' needed.
        #
        # On timeout we return silently and on purpose: the precmd add is
        # best-effort and runs backgrounded (`&!'), so there is nowhere useful
        # to report to -- a message would land on the terminal asynchronously,
        # mid-keystroke, possibly every prompt. To diagnose a database that has
        # stopped updating, run a foreground `z --add .' and check `$?': a
        # nonzero status means the write did not happen -- 2 is a lock-
        # acquisition timeout (contention, or a raised ZSHZ_LOCK_TIMEOUT is
        # still too low), 1 is a permissions or ownership problem (e.g. a stale
        # root-owned lockfile left by an earlier `sudo -s' session, or a
        # symlinked lockfile refused under $ZSHZ_OWNER).
        # Create the lockfile 0600-from-birth and silently (umask in a
        # subshell), mirroring the datafile creation above rather than a bare
        # `touch' under the ambient umask with unsuppressed stderr. zsystem
        # flock opens the lockfile O_RDWR, so under `sudo -s' with $ZSHZ_OWNER
        # the unprivileged user must be able to open it: hand it off at
        # creation, not only after a successful write -- a timed-out or failed
        # first write by root would skip the post-write chown and leave a
        # root-owned lockfile, turning every later user --add / -x into a
        # silently-swallowed EACCES no-op. The lockfile is deliberately never
        # removed: unlinking one a waiter has already opened reintroduces the
        # two-inodes race the stable lockfile exists to prevent.
        # Under $ZSHZ_OWNER all of this runs with root's authority on a path the
        # unprivileged owner controls, and every step follows a symlink: `-f'
        # tests the target, `>>' creates a dangling one, and flock opens it.
        # $datafile survives a planted link only because the `mv' below replaces
        # it outright; the lockfile is deliberately never removed, so a symlink
        # here would persist and be acted on at every subsequent write. Refuse.
        local _lock_owner=${ZSHZ_OWNER:-${_Z_OWNER}}
        [[ -n $_lock_owner && -L $lockfile ]] && return 1
        if [[ ! -f $lockfile ]]; then
          ( umask 077; : >> "$lockfile" ) 2> /dev/null
          [[ -n $_lock_owner ]] &&
            ${ZSHZ[CHOWN]} -h "${_lock_owner}:$(id -ng "${_lock_owner}")" "$lockfile"
        fi
        zsystem flock -t ${ZSHZ_LOCK_TIMEOUT:-1} -f lockfd "$lockfile" 2> /dev/null || return

      else

        # No `zsystem flock' here. MobaXterm's cut-down Cygwin is the case that
        # matters -- it ships no `zsh/system' at all -- and until now this path
        # wrote with nothing serializing it: every writer read its own snapshot
        # and the last `mv' won. Measured on MobaXterm, an entry added by one of
        # four concurrent writers went missing in 7 runs out of 10.
        #
        # `mkdir' is the portable atomic primitive: it succeeds for exactly one
        # caller and fails for the rest, with no module behind it. What it does
        # not give us is the kernel's release-on-death, which is the whole
        # reason `flock' is preferred where it exists -- so a holder that dies
        # would wedge every later write. Hence the staleness sweep below.
        #
        # Failure to acquire returns 2, the same status the flock branch's
        # timeout produces and the one the README documents for contention.
        integer _zshz_deadline=$(( EPOCHSECONDS + ${ZSHZ_LOCK_TIMEOUT:-1} ))
        local -a _zshz_stale
        while :; do
          if mkdir "$lockdir" 2> /dev/null; then
            lockdir_held=1
            break
          fi
          # Break a lock nobody can still be holding. A write is a matter of
          # milliseconds, so a lock directory older than 30 seconds means its
          # owner died without releasing it. `mkdir' stamps the mtime at
          # creation and no holder touches it afterwards, so the age is the
          # hold time. `$lockdir' expands literally here -- only the qualifier
          # is glob syntax -- so a datafile path containing `[' or `*' is safe.
          _zshz_stale=( ${lockdir}(Nms+30) )
          if (( ${#_zshz_stale} )); then
            rmdir "$lockdir" 2> /dev/null && continue
          fi
          (( EPOCHSECONDS >= _zshz_deadline )) && return 2
          # No `zselect' on the platforms that land here, so this costs a fork.
          # It is the slow path already, and spinning would be worse.
          sleep 0.05 2> /dev/null || :
        done

      fi

      # Read the datafile only after obtaining the lock, so concurrent --add
      # calls don't all act on the same stale snapshot.
      lines=( ${(f)"$(< $datafile)"} )
      # Discard entries that are incomplete or incorrectly formatted
      lines=( ${(M)lines:#/*\|[[:digit:]]##[.,]#[[:digit:]]#\|[[:digit:]]##} )

      # Hold the fd in an *unset* scalar, not `integer tmpfd' (which seeds it
      # with 0). On some Zsh builds, `exec {tmpfd}>|...' refuses to clobber a
      # parameter already holding a number that names an open fd -- and 0 is
      # stdin, always open -- yielding "can't clobber parameter tmpfd
      # containing file descriptor 0". An empty scalar isn't a valid fd, so
      # the guard never fires. See https://github.com/agkozak/zsh-z/issues/81
      local tmpfd
      case $action in
        --add)
          # When zf_chmod isn't available (Zsh 4.3.11), avoid the
          # ~900us fork+execve of external /usr/bin/chmod on every
          # write. Create the tempfile with mode 0600 from the start
          # via `umask 077' inside a subshell -- the umask change is
          # contained to the forked child process and the OS prevents
          # it from leaking back to the parent. Subshell fork without
          # exec is ~50us, ~18x cheaper than the chmod fallback.
          if [[ ${ZSHZ[CHMOD]} == 'zf_chmod' ]]; then
            exec {tmpfd}>|"$tempfile"  # Open up tempfile for writing
            # Fail closed. The tempfile is born with the ambient umask (0666
            # under `umask 000'), and it is this inode -- not the datafile's --
            # that the rename below publishes, so a chmod whose failure went
            # unnoticed would replace a 0600 datafile with a world-readable one
            # and still report success. Nothing has been written yet, so
            # there is no salvage: drop the tempfile and leave the database as
            # it was.
            if ! ${ZSHZ[CHMOD]} 600 "$tempfile"; then
              exec {tmpfd}>&-
              ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
              return 1
            fi
            _zshz_update_datafile $tmpfd "$*"
          else
            ( umask 077
              exec {tmpfd}>|"$tempfile"
              _zshz_update_datafile $tmpfd "$*" )
          fi
          local ret=$?
          ;;
        --remove)
          # $xdir was resolved before the lock, and for `-xR /' the
          # whole-database wipe was already confirmed there.
          local -a lines_to_keep
          if (( ${+opts[-R]} )); then
            # All of the lines that don't match the directory to be deleted
            lines_to_keep=( ${lines:#${xdir}\|*} )
            # Or its subdirectories
            lines_to_keep=( ${lines_to_keep:#${xdir%/}/**} )
          else
            # All of the lines that don't match the directory to be deleted
            lines_to_keep=( ${lines:#${xdir}\|*} )
          fi
          if [[ $lines != "$lines_to_keep" ]]; then
            lines=( $lines_to_keep )
          else
            return 1  # The $PWD isn't in the datafile
          fi
          # Same umask-subshell pattern as --add: avoid the external
          # chmod when zf_chmod isn't available.
          if [[ ${ZSHZ[CHMOD]} == 'zf_chmod' ]]; then
            exec {tmpfd}>|"$tempfile"  # Open up tempfile for writing
            # Fail closed, exactly as on the --add path above.
            if ! ${ZSHZ[CHMOD]} 600 "$tempfile"; then
              exec {tmpfd}>&-
              ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
              return 1
            fi
            # `-r': $lines are verbatim on-disk lines (the datafile stores
            # literal paths), so they must be written back unchanged. Without
            # `-r', print would collapse an escape -- e.g. a literal `\t' in a
            # path into a tab -- silently corrupting bystander entries.
            print -u $tmpfd -rl -- $lines
          else
            ( umask 077; print -rl -- $lines >| "$tempfile" )
          fi
          local ret=$?
          ;;
      esac

      if [[ -n $tmpfd ]]; then
        # Close tempfile
        exec {tmpfd}>&-
      fi

      if (( ret != 0 )); then
        # Avoid clobbering the datafile if the write to tempfile failed
        ${ZSHZ[RM]} -f "$tempfile"
        return $ret
      fi

      integer write_ret chown_ret mv_attempts
      local owner
      owner=${ZSHZ_OWNER:-${_Z_OWNER}}

      if (( ZSHZ[USE_FLOCK] )); then
        # An unusual case: if inside Docker container where datafile could be bind
        # mounted
        if [[ -f '/.dockerenv' || ( -r '/proc/1/cgroup' && "$(< '/proc/1/cgroup')" == *docker* ) ]]; then
          # Secure the datafile *before* its contents land. This branch writes
          # in place instead of renaming an already-0600 tempfile over the
          # path, so asserting the mode afterwards -- as this did -- leaves a
          # bind-mounted datafile that arrived permissive readable for the
          # length of the write, and leaves it readable for good if the chmod
          # fails and nothing checks. The mode carries across the truncating
          # write below, which reuses this same inode.
          if ! ${ZSHZ[CHMOD]} 600 "$datafile" 2> /dev/null; then
            ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
            return 1
          fi
          # This is the one write path where a symlink at $datafile redirects
          # real database content: the sibling branch renames a finished
          # tempfile over the path, and a rename *replaces* a link rather than
          # writing through it, while `>|' follows one. Under $ZSHZ_OWNER that
          # content goes out with root's authority to a path an unprivileged
          # owner controls, so a `-L' test ahead of the write is not enough --
          # the path can be swapped in between.
          #
          # `sysopen -o nofollow' settles it atomically, at open time, and the
          # write goes through that descriptor. If it is unavailable (Zsh
          # 4.3.11 has `zsystem flock' but no `sysopen' at all, and O_NOFOLLOW
          # is not universal) or it refuses the open, the privileged write is
          # refused rather than retried by a following one: this degrades to
          # failing closed, never to writing unsafely. Without an owner set no
          # privilege is crossed and the plain redirection stands.
          #
          # `chmod' above stays path-based -- Zsh has no `fchmod' -- so a swap
          # can still misdirect it. Setting the mode on the wrong file is a far
          # smaller matter than writing the database into it, and the write is
          # what this closes.
          local _zshz_dfd
          if [[ -n $owner ]]; then
            if (( ${+builtins[sysopen]} )) &&
               sysopen -o trunc,nofollow -w -u _zshz_dfd "$datafile" 2> /dev/null
            then
              print -u $_zshz_dfd -r -- "$(< "$tempfile")" 2> /dev/null
              write_ret=$?
              exec {_zshz_dfd}>&-
            else
              ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
              return 1
            fi
          else
            # `-r': re-emit the tempfile's already-literal contents byte-for-byte.
            print -r -- "$(< "$tempfile")" >| "$datafile" 2> /dev/null
            write_ret=$?
          fi
          ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
        # All other cases
        else
          # Retry a rename that a Windows sharing violation turned away; see
          # the ZSHZ[MV_RETRIES] comment at the top of this file. Off Windows
          # this loop makes the same single attempt it always has. Retrying is
          # safe here: the rename happens under the lock, so no other writer
          # can slip in between attempts.
          while :; do
            if ${ZSHZ[MV]} "$tempfile" "$datafile" 2> /dev/null; then
              write_ret=0
            else
              write_ret=$?
            fi
            (( write_ret == 0 )) && break
            (( mv_attempts++ >= ${ZSHZ[MV_RETRIES]:-0} )) && break
            if (( ${+ZSHZ[MV_RETRY_DELAY]} )); then
              zselect -t ${ZSHZ[MV_RETRY_DELAY]} || :
            fi
          done
          (( write_ret != 0 )) && ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
        fi
        # Preserve the write failure itself; best-effort tempfile cleanup must not
        # turn a failed persist into a successful return.
        (( write_ret == 0 )) || return $write_ret

        if [[ -n $owner ]]; then
          # Chown the lockfile alongside the datafile: zsystem flock opens it
          # O_RDWR, so if root creates it first under sudo -s, the unprivileged
          # $ZSHZ_OWNER user's flock attempts would fail with EACCES (silently
          # swallowed), turning --add and -x into no-ops.
          # `-h' on both: the lockfile is never replaced, so a symlink planted
          # there outlives any one write, and $datafile can be relinked in the
          # window between the `mv' above and this line. Retitling the link
          # itself -- which the owner already owns -- costs nothing, while
          # dereferencing hands root's authority to whatever it names.
          ${ZSHZ[CHOWN]} -h "${owner}:$(id -ng "${owner}")" "$datafile" "$lockfile"
          chown_ret=$?
          # Surface post-write chown failures too: the current write landed, but a
          # wrong owner can break the next locked write.
          (( chown_ret == 0 )) || return $chown_ret
        fi
      else
        if [[ -n $owner ]]; then
          ${ZSHZ[CHOWN]} -h "${owner}:$(id -ng "${owner}")" "$tempfile"
          chown_ret=$?
          if (( chown_ret != 0 )); then
            # In the no-flock path, chown happens before the move, so clean up the
            # tempfile and leave the live database untouched.
            ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
            return $chown_ret
          fi
        fi
        # Same Windows sharing-violation retry as the flock branch above. This
        # path is the one MobaXterm's cut-down Cygwin takes, and it has neither
        # zsystem flock nor zsh/zselect, so the retries there run back to back.
        while :; do
          if ${ZSHZ[MV]} -f "$tempfile" "$datafile" 2> /dev/null; then
            write_ret=0
          else
            write_ret=$?
          fi
          (( write_ret == 0 )) && break
          (( mv_attempts++ >= ${ZSHZ[MV_RETRIES]:-0} )) && break
          if (( ${+ZSHZ[MV_RETRY_DELAY]} )); then
            zselect -t ${ZSHZ[MV_RETRY_DELAY]} || :
          fi
        done
        if (( write_ret != 0 )); then
          ${ZSHZ[RM]} -f "$tempfile" 2> /dev/null
          return $write_ret
        fi
      fi
    } always {
      # zsystem flock -f opens a real fd; explicitly unlock it so repeated
      # foreground `z --add' / `z -x' invocations in the interactive shell
      # don't leak lock descriptors and stall peers. (A backgrounded precmd
      # child releases its fd on exit regardless; this matters for the parent.)
      (( lockfd != 0 )) && zsystem flock -u $lockfd 2> /dev/null
      # Release the mkdir lock on every exit from the block above, including
      # the early `return's -- unlike an fd, a directory outlives the process
      # that made it, so a missed release here is a wedged database rather than
      # a leaked descriptor. Only if this call is the one that took it.
      (( lockdir_held )) && rmdir "$lockdir" 2> /dev/null
    }

    # In order to make z -x work, we have to disable zsh-z's adding
    # to the database until the user changes directory and the
    # chpwd_functions are run
    if [[ $action == '--remove' ]]; then
      ZSHZ[DIRECTORY_REMOVED]=1
    fi
  }

  ############################################################
  # Read the current datafile contents, update them, "age" them
  # when the total rank gets high enough, and print the new
  # contents to STDOUT.
  #
  # Globals:
  #   ZSHZ_KEEP_DIRS
  #   ZSHZ_MAX_SCORE
  #
  # Arguments:
  #   $1 File descriptor linked to tempfile
  #   $2 Path to be added to datafile
  ############################################################
  _zshz_update_datafile() {

    integer fd=$1
    local -A rank time

    # Characters special to the shell (such as '[]') are quoted with backslashes
    # See https://github.com/rupa/z/issues/246
    local add_path=${(q)2}

    local now=$EPOCHSECONDS line dir
    local path_field rank_field time_field count x
    local -i keep

    rank[$add_path]=1
    time[$add_path]=$now

    for line in $lines; do
      path_field=${line%%\|*}

      # Filter non-existent paths (honoring ZSHZ_KEEP_DIRS) inline so
      # we walk $lines once instead of twice. The `keep=1; break' also
      # fixes a latent bug: the previous existence-check loop had no
      # `break' after appending, so a non-existent path matching
      # multiple ZSHZ_KEEP_DIRS patterns was processed more than once.
      if [[ ! -d $path_field ]]; then
        keep=0
        for dir in ${(@)ZSHZ_KEEP_DIRS}; do
          if [[ $path_field == ${dir}/* || $path_field == $dir || $dir == '/' ]]; then
            keep=1
            break
          fi
        done
        (( keep )) || continue
      fi

      # Quote in place: assoc-array keys need shell-special chars
      # backslash-escaped (rupa/z#246).
      path_field=${(q)path_field}
      rank_field=${${line%\|*}#*\|}
      time_field=${line##*\|}

      # When a rank drops below 1, drop the path from the database
      (( rank_field < 1 )) && continue

      if [[ $path_field == $add_path ]]; then
        # Compute the new rank with a scalar expression, not `(( rank[$key]++ ))'.
        # The keys are `${(q)}'-quoted (rupa/z#246); a math-context subscript
        # runs its key through the arithmetic lexer, which strips a backslash
        # level and so misses any key containing `$ \ [ ] ( )' or a backtick --
        # incrementing a phantom raw-keyed entry and leaving the real one stuck.
        # An assignment subscript expands the key literally, so it is safe.
        rank[$path_field]=$(( rank_field + 1 ))
        time[$path_field]=$now
      else
        rank[$path_field]=$rank_field
        time[$path_field]=$time_field
      fi
      (( count += rank_field ))
    done
    local -a out
    if (( count > ${ZSHZ_MAX_SCORE:-${_Z_MAX_SCORE:-9000}} )); then
      # Aging
      for x in ${(k)rank}; do
        # `${rank[$x]}', not a bare `rank[$x]' math subscript: the keys are
        # `${(q)}'-quoted (rupa/z#246), and a math-context subscript would run
        # the key through the arithmetic lexer, stripping a backslash level and
        # missing any key with `$ \ [ ] ( )' or a backtick -- yielding 0, which
        # the `rank_field < 1' drop above then erases on the next write. The
        # expansion substitutes the numeric value before the math parser runs.
        out+=( "$x|$(( 0.99 * ${rank[$x]} ))|${time[$x]}" )
      done
    else
      for x in ${(k)rank}; do
        out+=( "$x|${rank[$x]}|${time[$x]}" )
      done
    fi
    # Deliberately NO `-r' here, unlike every other datafile write. The keys in
    # $out are `${(q)}'-quoted (assoc-array keys need shell-special chars
    # backslash-escaped -- rupa/z#246), and a plain `print' strips exactly one
    # backslash level back off, so what lands on disk is the literal path the
    # rest of the code expects. Adding `-r' would store the still-quoted form
    # (e.g. `/foo\ bar'), which the read path -- it does not unquote -- would
    # then fail to match. The verbatim-passthrough writes in
    # `_zshz_add_or_remove_path' DO use `-r' because their input is already
    # literal; this one is not.
    print -u $fd -l -- $out || return 1
  }

  ############################################################
  # The original tab completion method
  #
  # String processing is smartcase -- case-insensitive if the
  # search string is lowercase, case-sensitive if there are
  # any uppercase letters. Spaces in the search string are
  # treated as *'s in globbing. Read the contents of the
  # datafile and print matches to STDOUT.
  #
  # Arguments:
  #   $1 The string to be completed
  ############################################################
  _zshz_legacy_complete() {

    local line path_field path_field_normalized

    # Replace spaces in the search string with asterisks for globbing
    1=${1//[[:space:]]/*}

    # Hoist loop-invariants out of the per-line loop -- $1 and
    # $ZSHZ_TRAILING_SLASH don't change inside the loop, so the
    # lowercase comparison and the trailing-slash branch were pure
    # waste when recomputed N times. `query_lower' lets the case-
    # insensitive branch glob against a precompiled lowercase pattern.
    local query_lower=${1:l}
    local -i is_lowercase_query=0
    [[ $1 == $query_lower ]] && is_lowercase_query=1
    local -i trail=${ZSHZ_TRAILING_SLASH:-0}

    for line in $lines; do

      path_field=${line%%\|*}

      path_field_normalized=$path_field
      (( trail )) && path_field_normalized=${path_field%/}/

      # If the search string is all lowercase, the search will be case-insensitive
      if (( is_lowercase_query )) && [[ ${path_field_normalized:l} == *${~query_lower}* ]]; then
        print -r -- $path_field
      # Otherwise, case-sensitive
      elif [[ $path_field_normalized == *${~1}* ]]; then
        print -r -- $path_field
      fi

    done
    # TODO: Search strings with spaces in them are currently treated case-
    # insensitively.
  }

  ############################################################
  # If matches share a common root, find it, and put it in
  # REPLY for _zshz_output to use.
  #
  # Arguments:
  #   $@ Candidate paths
  ############################################################
  _zshz_find_common_root() {
    local -a common_matches
    local x short

    common_matches=( "$@" )

    for x in ${(@)common_matches}; do
      if [[ -z $short ]] || (( $#x < $#short )) || [[ $x != ${short}/* ]]; then
        short=$x
      fi
    done

    [[ $short == '/' ]] && return

    for x in ${(@)common_matches}; do
      [[ $x != $short* ]] && return
    done

    REPLY=$short
  }

  ############################################################
  # Calculate a common root, if there is one. Then do one of
  # the following:
  #
  #   1) Print a list of completions in frecent order;
  #   2) List them (z -l) to STDOUT; or
  #   3) Put a common root or best match into REPLY
  #
  # Globals:
  #   ZSHZ_TILDE
  #   ZSHZ_UNCOMMON
  #
  # Arguments:
  #   $1 Name of an associative array of matches and ranks
  #   $2 The best match or best case-insensitive match
  #   $3 Whether to produce a completion, a list, or a root or
  #        match
  ############################################################
  _zshz_output() {

    local match_array=$1 match=$2 format=$3
    local common x v
    local -a descending_list output

    _zshz_find_common_root ${(@Pk)match_array}
    common=$REPLY
    # Clear REPLY once the common root is captured: the caller reads REPLY as
    # the jump target, so a value left over here would make `z -l <query>'
    # change directory after listing. The default arm below overwrites REPLY
    # deliberately; the completion and list arms must leave it empty.
    REPLY=''

    # Iterate the caller's matches/imatches array as flat key-value
    # pairs via ${(@Pkv)...} instead of copying into a local
    # associative array. Avoids the hash-table allocation and K
    # inserts that the copy required.
    local -a kv
    local -i i
    kv=( ${(@Pkv)match_array} )

    case $format in

      completion)
        # Build "sortkey|path" rows, sort by the leading key descending, then
        # strip the key+'|' prefix to keep just the paths (the key is never
        # user-visible). The key MUST be an integer: `${(@On)}' numeric sort
        # compares each run of digits on its own, so a raw float rank orders by
        # its fractional digit-run rather than its value -- "100.5" would sort
        # below "100.25" (5 < 25). Scale by 100 and drop the decimal so two
        # digits of resolution survive (what the old `%.2f' rows preserved) as a
        # single integer digit-run. (Negative `-t' ranks still sort by
        # magnitude, since `n' ignores the sign -- unchanged from the `%.2f'
        # rows, i.e. a pre-existing quirk, not introduced here.)
        local sortkey
        for ((i=1; i<=${#kv}; i+=2)); do
          sortkey=$(( kv[i+1] * 100 ))
          descending_list+=( "${sortkey%.*}|${kv[i]}" )
        done
        descending_list=( ${${(@On)descending_list}#*\|} )
        print -rl -- $descending_list
        ;;

      list)
        # The bare `z -l' fast path (no query) inlines an equivalent
        # formatting block straight on $lines to skip this pipeline --
        # keep the two list formatters in sync.
        local path_to_display
        local -a displayed_paths
        for ((i=1; i<=${#kv}; i+=2)); do
          x=${kv[i]} v=${kv[i+1]}
          (( v )) || continue
          displayed_paths+=( $x )
          path_to_display=$x
          (( ZSHZ_TILDE )) &&
            path_to_display=${path_to_display/#${HOME}/\~}
          # Right-pad the integer rank to 10 chars, as `printf "%-10d %s\n"'
          # used to, but in parameter expansion. The padding must be
          # conditional: `%-10d' never shortened anything, but a bare
          # `${(r:10:)}' *truncates* a rank longer than 10 characters -- an
          # 11-character `-t' rank (sign + 10 digits, e.g. from a zeroed or
          # hand-imported time field more than ~31.7 years old) or a frecency
          # rank inflated by a raised $ZSHZ_MAX_SCORE would lose its last
          # digits, garbling both the displayed figure and the numeric sort
          # below. The `%.*' strip drops frecency's decimal tail
          # ("30000.0" -> "30000") to match what `%-10d' produced.
          v=${v%.*}
          (( ${#v} < 10 )) && v=${(r:10:)v}
          output+=( "$v $path_to_display" )
        done
        # Recompute the common root over the entries that survived the rank
        # filter above: $common, computed at the top of this function,
        # covers *every* match -- including rank-0 entries hidden from the
        # listing -- so it could name a root the visible entries do not
        # share. The bare `z -l' fast path filters rank-0 entries before
        # looking for a root, and the two formatters must produce identical
        # output. (The jump arm below still uses the full-match root: what
        # `z foo' jumps to is a separate question from what a listing
        # displays.)
        common=''
        if (( $#displayed_paths )); then
          _zshz_find_common_root $displayed_paths
          common=$REPLY
          # A listing must never leave a jump target in REPLY.
          REPLY=''
        fi
        if [[ -n $common ]]; then
          (( ZSHZ_TILDE )) && common=${common/#${HOME}/\~}
          (( $#output > 1 )) && printf "%-10s %s\n" 'common:' $common
        fi
        if (( $#output )); then
          # -lt: most-recent first (descending); -lr and default -l:
          # ascending rank.
          if (( $+opts[-t] )); then
            print -rl -- ${(@On)output}
          else
            print -rl -- ${(@on)output}
          fi
        fi
        ;;

      *)
        if (( ! ZSHZ_UNCOMMON )) && [[ -n $common ]]; then
          REPLY=$common
        else
          REPLY=${(P)match}
        fi
        ;;
    esac
  }

  ############################################################
  # Match a pattern by rank, time, or a combination of the
  # two, and output the results as completions, a list, or a
  # best match.
  #
  # Globals:
  #   ZSHZ
  #   ZSHZ_CASE
  #   ZSHZ_KEEP_DIRS
  #   ZSHZ_TRAILING_SLASH
  #
  # Arguments:
  #   $1 Pattern to match
  #   $2 Matching method (rank, time, or [default] frecency)
  #   $3 Output format (completion, list, or [default] store
  #     in REPLY)
  ############################################################
  _zshz_find_matches() {
    setopt LOCAL_OPTIONS NO_EXTENDED_GLOB

    local fnd=$1 method=$2 format=$3

    local line dir path_field rank_field time_field rank dx
    local -A matches imatches
    local best_match ibest_match hi_rank=-9999999999 ihi_rank=-9999999999
    local -i keep

    # Hoist loop-invariants. $fnd, $1, and $ZSHZ_TRAILING_SLASH don't
    # change inside the per-line loop, so the space-to-glob
    # substitution, the `${1:l} == $1' check, and the `:l' on $q were
    # pure waste when recomputed N times. The `q_lower' precompute
    # lets `${~q_lower}' replace `${~q:l}' in the case-insensitive
    # branches: same expanded pattern, compiled once.
    local q=${fnd//[[:space:]]/\*}
    local q_lower=${q:l}
    local -i is_lowercase_query=0
    [[ ${1:l} == $1 ]] && is_lowercase_query=1
    local -i trail=${ZSHZ_TRAILING_SLASH:-0}
    local now=$EPOCHSECONDS

    # This flag is consumed by the ZSHZ_UNCOMMON trimming block, which must know
    # whether the match it is about to trim was found case-insensitively. Clear
    # it at the start of every search so a value left over from a previous call
    # -- e.g. a tab-completion, which sets it but never runs the trimming block
    # that would reset it -- can't steer this search into the wrong branch. The
    # authoritative value is set below, from whichever match actually wins.
    ZSHZ[CASE_INSENSITIVE]=0

    for line in $lines; do
      path_field=${line%%\|*}

      # Filter non-existent paths (honoring ZSHZ_KEEP_DIRS) inline so we
      # walk $lines once instead of twice. The `keep=1; break' inside the
      # inner loop also fixes a latent bug: the previous existence-check
      # loop had no `break' after appending, so a non-existent path that
      # matched multiple ZSHZ_KEEP_DIRS patterns was processed more than
      # once.
      if [[ ! -d $path_field ]]; then
        keep=0
        for dir in ${(@)ZSHZ_KEEP_DIRS}; do
          if [[ $path_field == ${dir}/* || $path_field == $dir || $dir == '/' ]]; then
            keep=1
            break
          fi
        done
        (( keep )) || continue
      fi

      rank_field=${${line%\|*}#*\|}
      time_field=${line##*\|}

      case $method in
        rank) rank=$rank_field ;;
        time) (( rank = time_field - now )) ;;
        *)
          # Frecency routine: weight a path's stored frequency (rank_field)
          # by how recently it was visited (dx seconds ago). 10000 scales
          # the result into integer-comparable territory; the 3.75 / (...)
          # term decays from 3 (just now) toward 0 as dx grows, so older
          # paths lose rank. This is the canonical copy; the bare `z -l'
          # fast path inlines the same formula -- keep the two in sync.
          (( dx = now - time_field ))
          rank=$(( 10000 * rank_field * (3.75/( (0.0001 * dx + 1) + 0.25)) ))
          ;;
      esac

      local path_field_normalized=$path_field
      (( trail )) && path_field_normalized=${path_field%/}/

      # If $ZSHZ_CASE is 'ignore', be case-insensitive.
      #
      # If it's 'smart', be case-insensitive unless the string to be matched
      # includes capital letters.
      #
      # Otherwise, the default behavior of Zsh-z is to match case-sensitively if
      # possible, then to fall back on a case-insensitive match if possible.
      #
      # Track best_match / ibest_match directly from $rank in each branch so
      # we never have to math-subscript matches[] / imatches[] -- the math
      # parser interprets shell-special chars in associative-array keys as
      # syntax (rupa/z#246), and the workaround used to be a seven-char
      # escape pass on every line. Comparing the $rank scalar to the running
      # max sidesteps the subscript entirely.
      if [[ $ZSHZ_CASE == 'smart' ]] && (( is_lowercase_query )) &&
         [[ ${path_field_normalized:l} == ${~q_lower} ]]; then
        imatches[$path_field]=$rank
        if (( rank > ihi_rank )); then
          ibest_match=$path_field
          ihi_rank=$rank
        fi
      elif [[ $ZSHZ_CASE != 'ignore' && $path_field_normalized == ${~q} ]]; then
        matches[$path_field]=$rank
        if (( rank > hi_rank )); then
          best_match=$path_field
          hi_rank=$rank
        fi
      elif [[ $ZSHZ_CASE != 'smart' && ${path_field_normalized:l} == ${~q_lower} ]]; then
        imatches[$path_field]=$rank
        if (( rank > ihi_rank )); then
          ibest_match=$path_field
          ihi_rank=$rank
        fi
      fi
    done

    # Return 1 when there are no matches
    [[ -z $best_match && -z $ibest_match ]] && return 1

    if [[ -n $best_match ]]; then
      _zshz_output matches best_match $format
    elif [[ -n $ibest_match ]]; then
      # The winning match is the case-insensitive one; tell the ZSHZ_UNCOMMON
      # trimmer to count case-insensitively. A case-sensitive winner (the branch
      # above) correctly leaves the flag at the 0 set at the top of the search.
      ZSHZ[CASE_INSENSITIVE]=1
      _zshz_output imatches ibest_match $format
    fi
  }

  # THE MAIN ROUTINE

  local -A opts

  zparseopts -E -D -A opts -- \
    -add \
    -complete \
    c \
    e \
    h \
    -help \
    l \
    r \
    R \
    t \
    x

  if [[ $1 == '--' ]]; then
    shift
  elif [[ -n ${(M)@:#-*} && -z $compstate ]]; then
    print "Improper option(s) given."
    _zshz_usage
    return 1
  fi

  # -r (rank) and -t (recent) name different, mutually exclusive sort keys, so
  # asking for both is contradictory. Reject it rather than letting an arbitrary
  # one win -- the options loop below visits ${(k)opts} in hash order, so a
  # silent winner would not even be predictable. Skipped when --complete is set:
  # the completion widget always passes it, an error must not reach the terminal
  # mid-completion, and the sort order is merely cosmetic for a completion list.
  if (( ${+opts[-r]} && ${+opts[-t]} && ! ${+opts[--complete]} )); then
    print "${ZSHZ_CMD:-${_Z_CMD:-z}}: options -r and -t cannot be combined." >&2
    return 1
  fi

  local opt output_format method='frecency' fnd prefix req

  for opt in ${(k)opts}; do
    case $opt in
      --add)
        # Don't change the database when invoked via --complete (e.g., from
        # tab completion).
        (( ${+opts[--complete]} )) && continue
        [[ ! -d $* ]] && return 1
        local dir
        # Cygwin and MSYS2 have a hard time with relative paths expressed from /
        if [[ $OSTYPE == (cygwin|msys) && $PWD == '/' && $* != /* ]]; then
          set -- "/$*"
        fi
        if (( ${ZSHZ_NO_RESOLVE_SYMLINKS:-${_Z_NO_RESOLVE_SYMLINKS}} )); then
          dir=${*:a}
        else
          dir=${*:A}
        fi
        _zshz_add_or_remove_path --add "$dir"
        return
        ;;
      --complete)
        if [[ -s $datafile && ${ZSHZ_COMPLETION:-frecent} == 'legacy' ]]; then
          lines=( ${(f)"$(< $datafile)"} )
          # Discard entries that are incomplete or incorrectly formatted
          lines=( ${(M)lines:#/*\|[[:digit:]]##[.,]#[[:digit:]]#\|[[:digit:]]##} )
          _zshz_legacy_complete "$1"
          return
        fi
        output_format='completion'
        ;;
      -c) [[ $* == ${PWD}/* || $PWD == '/' ]] || prefix="$PWD " ;;
      -h|--help)
        (( ${+opts[--complete]} )) && continue
        _zshz_usage
        return
        ;;
      # --complete (completion mode) always wins over -l, independent of the
      # order ${(k)opts} happens to visit them: completing `z -l ...' must still
      # emit bare paths for compadd, never the rank-padded rows of a list.
      -l) (( ${+opts[--complete]} )) || output_format='list' ;;
      -r) method='rank' ;;
      -t) method='time' ;;
      -x)
        (( ${+opts[--complete]} )) && continue
        # Cygwin and MSYS2 have a hard time with relative paths expressed from /
        if [[ $OSTYPE == (cygwin|msys) && $PWD == '/' && $* != /* ]]; then
          set -- "/$*"
        fi
        _zshz_add_or_remove_path --remove $*
        return
        ;;
    esac
  done

  # Load the datafile into an array and parse it
  lines=( ${(f)"$(< $datafile)"} )
  # Discard entries that are incomplete or incorrectly formatted
  lines=( ${(M)lines:#/*\|[[:digit:]]##[.,]#[[:digit:]]#\|[[:digit:]]##} )

  req="$*"
  fnd="$prefix$*"

  [[ -n $fnd && $fnd != "$PWD " ]] || {
    [[ $output_format != 'completion' ]] && output_format='list'
  }

  #########################################################
  # Allow the user to specify directory-changing command
  # using $ZSHZ_CD (default: builtin cd).
  #
  # Globals:
  #   ZSHZ_CD
  #
  # Arguments:
  #   $* Path
  #########################################################
  zshz_cd() {
    setopt LOCAL_OPTIONS NO_WARN_CREATE_GLOBAL

    if [[ -z $ZSHZ_CD ]]; then
      builtin cd "$*"
    else
      ${=ZSHZ_CD} "$*"
    fi
  }

  #########################################################
  # If $ZSHZ_ECHO == 1, display paths as you jump to them.
  # If it is also the case that $ZSHZ_TILDE == 1, display
  # the home directory as a tilde.
  #
  # Globals:
  #   ZSHZ_ECHO
  #   ZSHZ_TILDE
  #########################################################
  _zshz_echo() {
    if (( ZSHZ_ECHO )); then
      if (( ZSHZ_TILDE )); then
        print -r -- ${PWD/#${HOME}/\~}
      else
        print -r -- $PWD
      fi
    fi
  }

  if [[ ${@: -1} == /* ]] && (( ! $+opts[-e] && ! $+opts[-l] )); then
    # cd if possible; echo the new path if $ZSHZ_ECHO == 1
    [[ -d ${@: -1} ]] && zshz_cd ${@: -1} && _zshz_echo && return
  fi

  # Fast path: bare `zshz -l' (no query, list format). Skip the
  # `_zshz_find_matches' / `_zshz_output' pipeline -- there is nothing
  # to match against, no `matches[]'/`imatches[]' to maintain, no
  # case-mode branching, no `${(Pkv)...}' copy. Build the formatted
  # output array directly, then sort and print. Mirrors the list arm
  # of `_zshz_output' but operates straight on $lines.
  if [[ $output_format == 'list' && -z $fnd ]]; then
    local line path_field rank_field time_field rank dx path_to_display dir
    local common now=$EPOCHSECONDS
    local -a output paths
    local -i keep

    for line in $lines; do
      path_field=${line%%\|*}

      if [[ ! -d $path_field ]]; then
        keep=0
        for dir in ${(@)ZSHZ_KEEP_DIRS}; do
          if [[ $path_field == ${dir}/* || $path_field == $dir || $dir == '/' ]]; then
            keep=1
            break
          fi
        done
        (( keep )) || continue
      fi

      rank_field=${${line%\|*}#*\|}
      time_field=${line##*\|}
      case $method in
        rank) rank=$rank_field ;;
        time) (( rank = time_field - now )) ;;
        *)
          # Frecency routine -- see _zshz_find_matches for the canonical
          # copy and the constants' rationale; keep the two in sync.
          (( dx = now - time_field ))
          rank=$(( 10000 * rank_field * (3.75/( (0.0001 * dx + 1) + 0.25)) ))
          ;;
      esac
      (( rank )) || continue

      paths+=( $path_field )
      path_to_display=$path_field
      (( ZSHZ_TILDE )) && path_to_display=${path_to_display/#${HOME}/\~}
      # Conditional padding, never a bare `${(r:10:)}' -- see the list arm
      # of `_zshz_output' for why a rank must not be truncated.
      rank=${rank%.*}
      (( ${#rank} < 10 )) && rank=${(r:10:)rank}
      output+=( "$rank $path_to_display" )
    done

    if (( $#paths )); then
      _zshz_find_common_root $paths
      common=$REPLY
      REPLY=
    fi

    if [[ -n $common ]]; then
      (( ZSHZ_TILDE )) && common=${common/#${HOME}/\~}
      (( $#output > 1 )) && printf "%-10s %s\n" 'common:' $common
    fi

    if (( $#output )); then
      if (( $+opts[-t] )); then
        print -rl -- ${(@On)output}
      else
        print -rl -- ${(@on)output}
      fi
      return 0
    fi
    return 1
  fi

  # With option -c, make sure query string matches beginning of matches;
  # otherwise look for matches anywhere in paths.
  #
  # The `$PWD != /' guard mirrors the one where the prefix is set, above. At the
  # root every path is already under $PWD, so no "$PWD " prefix is prepended and
  # $fnd stays the bare query -- which, anchored, can never match a path
  # beginning with `/'. Without the guard, `z -c foo' from `/' matches nothing
  # whatever the query. Anchoring is still right in the other prefix-less case
  # ($* is an absolute path under $PWD): there the query is itself anchored.
  if (( ${+opts[-c]} )) && [[ $PWD != '/' ]]; then
    _zshz_find_matches "$fnd*" $method $output_format
  else
    _zshz_find_matches "*$fnd*" $method $output_format
  fi

  local ret2=$?

  local cd
  # Only the default (jump/echo) format communicates a destination through
  # REPLY; list and completion print their results directly and leave REPLY
  # empty. Checking the format here is a second line of defense: even if a
  # future edit to `_zshz_output' lets a stray REPLY escape again, a listing
  # must never turn into a directory change.
  [[ -z $output_format ]] && cd=$REPLY

  # New experimental "uncommon" behavior
  #
  # If the best choice at this point is something like /foo/bar/foo/bar, and the
  # search pattern is `bar', go to /foo/bar/foo/bar; but if the search pattern
  # is `foo', go to /foo/bar/foo
  if (( ZSHZ_UNCOMMON )) && [[ -n $cd ]]; then
    if [[ -n $cd ]]; then

      # In the search pattern, replace spaces with *
      local q=${fnd//[[:space:]]/\*}
      q=${q%/} # Trailing slash has to be removed

      # As long as the best match is not case-insensitive
      if (( ! ZSHZ[CASE_INSENSITIVE] )); then
        # Count the number of characters in $cd that $q matches
        local q_chars=$(( ${#cd} - ${#${cd//${~q}/}} ))
        # Try dropping directory elements from the right; stop when it affects
        # how many times the search pattern appears
        until (( ( ${#cd:h} - ${#${${cd:h}//${~q}/}} ) != q_chars )); do
          # ${cd:h} of `/' is `/', so without this guard the trim could spin
          # forever once it reaches the root (e.g. `/' in the database with a
          # pattern that matches zero characters there).
          [[ ${cd:h} == $cd ]] && break
          cd=${cd:h}
        done

      # If the best match is case-insensitive
      else
        local q_chars=$(( ${#cd} - ${#${${cd:l}//${~${q:l}}/}} ))
        until (( ( ${#cd:h} - ${#${${${cd:h}:l}//${~${q:l}}/}} ) != q_chars )); do
          # See the case-sensitive branch: guard against ${cd:h} no longer
          # changing once the trim reaches the root.
          [[ ${cd:h} == $cd ]] && break
          cd=${cd:h}
        done
      fi

      ZSHZ[CASE_INSENSITIVE]=0
    fi
  fi

  if (( ret2 == 0 )) && [[ -n $cd ]]; then
    if (( $+opts[-e] )); then               # echo
      (( ZSHZ_TILDE )) && cd=${cd/#${HOME}/\~}
      print -r -- "$cd"
    else
      # cd if possible; echo the new path if $ZSHZ_ECHO == 1
      [[ -d $cd ]] && zshz_cd "$cd" && _zshz_echo
    fi
  else
    # if $req is a valid path, cd to it; echo the new path if $ZSHZ_ECHO == 1
    if ! (( $+opts[-e] || $+opts[-l] )) && [[ -d $req ]]; then
      zshz_cd "$req" && _zshz_echo
    else
      return $ret2
    fi
  fi
}

alias ${ZSHZ_CMD:-${_Z_CMD:-z}}='zshz 2>&1'

############################################################
# precmd - add path to datafile unless `z -x' has just been
#   run
#
# Globals:
#   ZSHZ
############################################################
_zshz_precmd() {
  # Protect against `setopt NO_UNSET'
  setopt LOCAL_OPTIONS UNSET

  # Do not add PWD to datafile when in HOME directory, or
  # if `z -x' has just been run
  [[ $PWD == "$HOME" ]] || (( ZSHZ[DIRECTORY_REMOVED] )) && return

  # Don't track directory trees excluded in ZSHZ_EXCLUDE_DIRS
  local exclude
  for exclude in ${(@)ZSHZ_EXCLUDE_DIRS:-${(@)_Z_EXCLUDE_DIRS}}; do
    case $PWD in
      ${exclude}|${exclude}/*) return ;;
    esac
  done

  # Add PWD to the datafile. Background the write so the prompt doesn't wait on
  # read + tempfile + rename + chown -- which is tens of ms per prompt on
  # 9P-bridged or VHD-backed paths. Backgrounding is safe under develop's
  # lock design: the `always { zsystem flock -u $lockfd }' block in
  # _zshz_add_or_remove_path guarantees the parent never holds an open
  # lockfd between precmd invocations (so a `&!' fork can't inherit one),
  # and ZSHZ_LOCK_TIMEOUT (default 1s) bounds contention so a stuck holder
  # can't pile up writers. `&!' is zsh background + disown: no wrapper
  # subshell, no job-table entry, no "Done" line at the next prompt.
  #
  # Do not restore the old foreground carve-out for Cygwin/MSYS2. It was
  # right when backgrounding meant a subshell plus a job (two forks) and
  # writes were line-by-line; with one disowned fork and batched writes,
  # measurement (June 2026, Cygwin zsh 5.8 and MSYS2 zsh 5.9) shows ~10-12ms
  # at the prompt for `&!' vs. ~30ms for a foreground add at 300 datafile
  # entries -- and ~300ms at 1,000 entries, since the foreground cost grows
  # with the datafile while the fork cost stays flat.
  #
  # `2> /dev/null' is what actually enforces the "stay quiet at every prompt"
  # rule that $_zshz_quiet_add describes. That marker can only gate Zsh-z's own
  # `print's; it cannot reach the external and builtin commands further down the
  # --add path -- `mkdir -p', `id -ng', ${ZSHZ[CHOWN]}, the deliberately loud
  # datafile-creation retry, or Zsh's own redirection diagnostics -- and any of
  # those can fail when $ZSHZ_DATA sits on an unwritable or unmounted directory,
  # or when $ZSHZ_OWNER names a user `id' can't resolve. Suppressing at the fork
  # covers every such site at once, including ones added later, whereas
  # suppressing site by site has to be kept in sync forever. Nothing actionable
  # is lost: a foreground `z --add .' still reports in full, which is exactly
  # the diagnostic the lock comment above tells the user to run.
  local _zshz_quiet_add=1
  zshz --add "$PWD" 2> /dev/null &!

  # See https://github.com/rupa/z/pull/247/commits/081406117ea42ccb8d159f7630cfc7658db054b6
  : $RANDOM
}

############################################################
# chpwd
#
# When the $PWD is removed from the datafile with `z -x',
# Zsh-z refrains from adding it again until the user has
# left the directory.
#
# Globals:
#   ZSHZ
############################################################
_zshz_chpwd() {
  ZSHZ[DIRECTORY_REMOVED]=0
}

autoload -Uz add-zsh-hook

add-zsh-hook precmd _zshz_precmd
add-zsh-hook chpwd _zshz_chpwd

############################################################
# Completion
############################################################

# Standardized $0 handling
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#${ZSH_ARGZERO-}}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Capture the plugin directory while $0 still names this file: inside the
# unload function, $0 is the function name (FUNCTION_ARGZERO), which `:A'
# would resolve against $PWD.
ZSHZ[PLUGIN_DIR]=${0:A:h}

# Add the plugin directory to $fpath only when nothing else has already put it
# there, and record having done so, so that unload can take back this entry
# and leave a plugin manager's alone.
#
# The record is only ever set, never cleared: on a re-source the directory is
# already present -- because this file added it the first time -- and clearing
# the record then would strand the entry in $fpath at unload. `typeset -gA'
# above preserves the value across that re-source.
if (( ${fpath[(ie)${ZSHZ[PLUGIN_DIR]}]} > ${#fpath} )); then
  fpath=( "${ZSHZ[PLUGIN_DIR]}" "${fpath[@]}" )
  # Record the path itself, not a boolean. $ZSHZ[PLUGIN_DIR] is rewritten by
  # every source, so a flag would end up describing whichever directory was
  # sourced last: re-sourcing from a second, manager-owned installation would
  # make unload drop *that* entry and strand the one this plugin actually
  # added. Newline-separated, since a path may contain spaces, and split with
  # `${(f)...}' at unload.
  ZSHZ[ADDED_FPATH]="${ZSHZ[ADDED_FPATH]:+${ZSHZ[ADDED_FPATH]}
}${ZSHZ[PLUGIN_DIR]}"
fi

# Save the existing Tab binding so that the completion widget can invoke it,
# but being careful not to create a situation where the widget ends up calling
# itself and causing infinite recursion if this script is re-sourced.
if (( ! ${+widgets[_zshz_zle_completion_widget]} )); then
  ZSHZ[TAB_BINDING]="${$(bindkey -M main '^I')##* }"
fi

############################################################
# ZLE widget to fix spaces-as-wildcards completion
#
# When completing a Zsh-z command with multiple search terms
# (e.g. `z us lo bi'), collapse the terms into a single
# wildcard-joined word (e.g. `z us*lo*bi') before triggering
# completion. This causes compadd to replace the whole query
# with the matched path rather than just the last word.
#
# Globals:
#   ZSHZ_CMD
############################################################
_zshz_zle_completion_widget() {

  setopt LOCAL_OPTIONS EXTENDED_GLOB NO_KSH_ARRAYS NO_SH_WORD_SPLIT

  local cmd=${ZSHZ_CMD:-${_Z_CMD:-z}}

  # Ensure tab completion works under `setopt COMPLETE_ALIASES'. Under that
  # option zsh looks up `_comps[$cmd]' verbatim rather than expanding the
  # alias to `zshz' first; compinit's static `#compdef' tag in `_zshz' is
  # parsed literally (no parameter expansion) and only covers the literal
  # `zshz' command. Run once -- the guard short-circuits on subsequent Tabs.
  # Record what was registered, so `zsh-z_plugin_unload' can take back exactly
  # this entry and nothing else. Keyed on the effect rather than compdef's exit
  # status: if the mapping did not land, there is nothing to take back.
  if (( ! ${+_comps[$cmd]} )); then
    compdef _zshz $cmd 2> /dev/null
    # Append rather than overwrite. Re-sourcing with a changed $ZSHZ_CMD
    # registers a second command while the first mapping is still live, and a
    # single slot would forget the earlier one and strand it at unload. Space-
    # separated, like $ZSHZ[FUNCTIONS], and split with `${=...}' there.
    [[ ${_comps[$cmd]-} == '_zshz' ]] &&
      ZSHZ[COMPDEF]="${ZSHZ[COMPDEF]:+${ZSHZ[COMPDEF]} }$cmd"
  fi

  # If a trailing space was added after an already-completed absolute path
  # (e.g. `z /usr/local/bin '), a second Tab would otherwise re-trigger
  # completion on an empty word and insert a duplicate. Bail out early.
  if [[ $LBUFFER[-1] == ' ' && ${${LBUFFER% }##* } == [/~]* ]]; then
    return
  fi

  # Only act when there are at least two words after the command
  if [[ $LBUFFER == ${cmd}\ *\ * ]]; then
    local after=${LBUFFER#${cmd} }
    local -a parts option_parts search_parts
    local p past_options=0

    parts=( ${(z)after} )
    for p in $parts; do
      if (( ! past_options )) && [[ $p == (--|-[cehlrRtx]##|--add|--complete|--help) ]]; then
        option_parts+=( $p )
        # `--' terminates option parsing; subsequent tokens are positional,
        # even if they happen to look like options.
        [[ $p == -- ]] && past_options=1
      else
        past_options=1
        search_parts+=( $p )
      fi
    done

    if (( ${#search_parts} > 1 )); then
      LBUFFER="${cmd}${option_parts:+ ${(j: :)option_parts}} ${(j:*:)search_parts}"
    fi
  fi

  # If Tab had a non-default binding, continue to use it; otherwise the default
  # expand-or-complete gets used.
  zle ${ZSHZ[TAB_BINDING]:-expand-or-complete}
}

# Register the widget and bind to Tab, but only if this script has not already
# been sourced -- avoid infinite recursion.
if (( ! ${+widgets[_zshz_zle_completion_widget]} )); then
  zle -N _zshz_zle_completion_widget
  bindkey -M main '^I' _zshz_zle_completion_widget
fi

############################################################
# zsh-z functions
############################################################
ZSHZ[FUNCTIONS]='_zshz_usage
                 _zshz_realpath
                 _zshz_add_or_remove_path
                 _zshz_update_datafile
                 _zshz_legacy_complete
                 _zshz_find_common_root
                 _zshz_output
                 _zshz_find_matches
                 zshz_cd
                 _zshz_echo
                 zshz
                 _zshz_precmd
                 _zshz_chpwd
                 _zshz
                 _zshz_zle_completion_widget'

############################################################
# Enable WARN_NESTED_VAR for functions listed in
#   ZSHZ[FUNCTIONS]
############################################################
(( ${+ZSHZ_DEBUG} )) && () {
  if is-at-least 5.4.0; then
    local x
    for x in ${=ZSHZ[FUNCTIONS]}; do
      functions -W $x
    done
  fi
}

############################################################
# Unload function
#
# See https://github.com/agkozak/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc#unload-fun
#
# Globals:
#   ZSHZ
#   ZSHZ_CMD
############################################################
zsh-z_plugin_unload() {
  emulate -L zsh

  add-zsh-hook -D precmd _zshz_precmd
  add-zsh-hook -d chpwd _zshz_chpwd

  zle -D _zshz_zle_completion_widget

  # Only restore Tab binding if it is still bound to our widget; otherwise
  # leave it alone.
  local _zshz_current_tab
  _zshz_current_tab="$(bindkey -M main '^I' 2>/dev/null || true)"
  if [[ ${_zshz_current_tab##* } == _zshz_zle_completion_widget ]]; then
    bindkey -M main '^I' "${ZSHZ[TAB_BINDING]:-expand-or-complete}"
  fi

  local x
  for x in ${=ZSHZ[FUNCTIONS]}; do
    (( ${+functions[$x]} )) && unfunction $x
  done

  # The directory captured at source time -- $0 here is the function name,
  # not the plugin file. Read it before ZSHZ is unset.
  #
  # Only when this plugin was the one that added it. A plugin manager that put
  # the directory on $fpath owns that entry: taking it away would break
  # autoloads for anything else living there and leave the manager believing
  # its configuration is intact. And drop a single occurrence rather than
  # filtering every match -- at most one of any duplicates can be ours.
  #
  # `(ie)', not `(i)': without the `e' the subscript treats the stored path as
  # a *pattern*, so a plugin directory containing `[', `*' or `?' would not
  # match itself and the entry would be left behind. The source-time lookup
  # already uses `(ie)'; these two must agree.
  local _zshz_dir
  integer _zshz_fp
  for _zshz_dir in ${(f)ZSHZ[ADDED_FPATH]-}; do
    [[ -n $_zshz_dir ]] || continue
    _zshz_fp=${fpath[(ie)$_zshz_dir]}
    (( _zshz_fp <= ${#fpath} )) && fpath[$_zshz_fp]=()
  done

  # Take back the completion mapping the widget installed on its first Tab.
  # Without this the entry outlives the function it names -- `_zshz' is
  # unfunctioned above and the plugin directory has just left $fpath, so a
  # later completion on that command looks up something unloadable.
  #
  # Only this one entry. compinit's own registrations (`_comps[zshz]', from the
  # static `#compdef' tag) are deliberately left in place: nothing re-runs
  # compinit when the plugin is sourced again, so removing them would break
  # completion for the literal `zshz' command until the user re-ran it by hand.
  # This entry has no such problem -- the widget re-registers it on the next
  # Tab after a reload.
  #
  # `$ZSHZ[COMPDEF]' is the ownership record: the registration above never
  # overwrites an existing mapping, so one Zsh-z did not create must survive
  # unload. Re-check the value too, in case it was repointed since.
  local _zshz_compdef
  for _zshz_compdef in ${=ZSHZ[COMPDEF]-}; do
    [[ ${_comps[$_zshz_compdef]-} == '_zshz' ]] &&
      compdef -d "$_zshz_compdef" 2> /dev/null
  done

  unset ZSHZ

  (( ${+aliases[${ZSHZ_CMD:-${_Z_CMD:-z}}]} )) &&
    unalias ${ZSHZ_CMD:-${_Z_CMD:-z}}

  unfunction $0
}

# vim: fdm=indent:ts=2:et:sts=2:sw=2:
