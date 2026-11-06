#!/usr/bin/env zsh
# ==============================================================================
# zsh-sessions (zs) — Oh My Zsh Session Threads Plugin
# Conversational terminal sessions with UUIDv7, safe stdout/stderr capture,
# edited file diffs, secret redaction, manual/AI categories, full-text search,
# Markdown runbook export, EN/PT-BR localization, and fzf TUI.
# ==============================================================================

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"
typeset -g ZS_PLUGIN_DIR="${0:h}"

# Configuration defaults
typeset -g ZS_DATA_DIR="${ZS_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh-sessions}"
typeset -g ZS_LANG="${ZS_LANG:-}"
typeset -gi ZS_CAPTURE_OUTPUT="${ZS_CAPTURE_OUTPUT:-1}"
typeset -g ZS_CAPTURE_MODE="${ZS_CAPTURE_MODE:-safe}"
typeset -g ZS_SAFE_CAPTURE_CMDS="${ZS_SAFE_CAPTURE_CMDS:-}"
typeset -gi ZS_MAX_OUTPUT_LINES="${ZS_MAX_OUTPUT_LINES:-60}"
typeset -gi ZS_MIN_MEANINGFUL_CMDS="${ZS_MIN_MEANINGFUL_CMDS:-2}"
typeset -gi ZS_MAX_DIR_SNAP_FILES="${ZS_MAX_DIR_SNAP_FILES:-15}"

# Always guarantee stdout/stderr are connected to /dev/tty in interactive shells
if [[ -o interactive && -w /dev/tty ]]; then
  if (( ${_ZS_REDIRECT_ACTIVE:-0} == 1 )) || [[ ! -t 1 || ! -t 2 ]]; then
    exec 1>/dev/tty 2>/dev/tty 2>/dev/null
  fi
fi

# Internal state for active session (preserve if already active in current shell)
typeset -g ZS_SESSION_ID="${ZS_SESSION_ID:-}"
typeset -g ZS_SESSION_CATEGORY="${ZS_SESSION_CATEGORY:-}"
typeset -g ZS_SESSION_TITLE="${ZS_SESSION_TITLE:-}"
typeset -g ZS_SESSION_PROJECT="${ZS_SESSION_PROJECT:-}"
typeset -g ZS_SESSION_CREATED_AT="${ZS_SESSION_CREATED_AT:-}"
typeset -gi ZS_SESSION_CMD_COUNT="${ZS_SESSION_CMD_COUNT:-0}"
typeset -gi ZS_SESSION_MEANINGFUL_COUNT="${ZS_SESSION_MEANINGFUL_COUNT:-0}"
typeset -gi ZS_SESSION_HAS_DIFF="${ZS_SESSION_HAS_DIFF:-0}"
typeset -gi ZS_SESSION_MANUAL_META="${ZS_SESSION_MANUAL_META:-0}"
typeset -g _ZS_LAST_CMD=""
typeset -g _ZS_ACTIVE_CMD=""
typeset -gi _ZS_CMD_START_TS=0
typeset -g _ZS_SNAP_DIR=""
typeset -g _ZS_CMD_OUT_FILE=""
typeset -gi _ZS_REDIRECT_ACTIVE=0
typeset -ga _ZS_TRACKED_FILES=()
typeset -ga _ZS_SENSITIVE_TOUCHED=()
typeset -gA _ZS_PWD_EXISTING_CONFIGS=()
typeset -gi _ZS_PWD_SCANNED=0
typeset -g _ZS_STAT_MTIME="0"
typeset -g _ZS_STAT_SIZE="0"
typeset -gi _ZS_UUID_SEQ=0

zmodload zsh/datetime 2>/dev/null
zmodload -F zsh/stat b:zstat 2>/dev/null || zmodload zsh/stat 2>/dev/null

# ------------------------------------------------------------------------------
# 0. Dynamic Zero-Fork Localization (EN default for OMZ / PT-BR automatic)
# ------------------------------------------------------------------------------
_zs_is_pt() {
  local loc="${ZS_LANG:-${LC_ALL:-${LC_MESSAGES:-${LANG:-en}}}}"
  [[ "${loc:l}" == pt* ]]
}

_zs_tr() {
  if _zs_is_pt; then
    print -r -- "$2"
  else
    print -r -- "$1"
  fi
}

_zs_default_category() {
  if _zs_is_pt; then
    print -r -- "Sem Categoria"
  else
    print -r -- "Uncategorized"
  fi
}

_zs_is_uncategorized_val() {
  local val="$1"
  [[ -z "$val" || "$val" == "Sem Categoria" || "$val" == "Uncategorized" ]]
}

# Fast pure-Zsh date formatting (0 forks)
_zs_now_ymd_hm() {
  local out=""
  strftime -s out "%Y-%m-%d %H:%M" "${EPOCHSECONDS:-0}" 2>/dev/null || out="$(command date "+%Y-%m-%d %H:%M")"
  print -r -- "$out"
}

_zs_now_hms() {
  local out=""
  strftime -s out "%H:%M:%S" "${EPOCHSECONDS:-0}" 2>/dev/null || out="$(command date "+%H:%M:%S")"
  print -r -- "$out"
}

# Fast zero-fork file mtime & size via zsh/stat
_zs_file_mtime_size() {
  local filepath="$1"
  _ZS_STAT_MTIME="0"
  _ZS_STAT_SIZE="0"
  [[ ! -e "$filepath" ]] && return 1
  local -A st
  if zstat -H st "$filepath" 2>/dev/null; then
    _ZS_STAT_MTIME="${st[mtime]:-0}"
    _ZS_STAT_SIZE="${st[size]:-0}"
    return 0
  fi
  _ZS_STAT_MTIME=$(command stat -f "%m" "$filepath" 2>/dev/null || command stat -c "%Y" "$filepath" 2>/dev/null || print 1)
  _ZS_STAT_SIZE=$(command wc -c < "$filepath" 2>/dev/null | command tr -d ' ')
  return 0
}

# ------------------------------------------------------------------------------
# 1. Storage Initialization & Atomic Index Locking (0700 / 0600 permissions)
# ------------------------------------------------------------------------------
_zs_init_storage() {
  if [[ ! -d "$ZS_DATA_DIR/sessions" ]]; then
    command mkdir -p -m 0700 "$ZS_DATA_DIR" "$ZS_DATA_DIR/sessions" 2>/dev/null
    command chmod 0700 "$ZS_DATA_DIR" "$ZS_DATA_DIR/sessions" 2>/dev/null
  fi
  if [[ ! -f "$ZS_DATA_DIR/categories.txt" ]]; then
    ( umask 0077; : > "$ZS_DATA_DIR/categories.txt" )
    command chmod 0600 "$ZS_DATA_DIR/categories.txt" 2>/dev/null
  fi
  if [[ ! -f "$ZS_DATA_DIR/index.tsv" ]]; then
    ( umask 0077; : > "$ZS_DATA_DIR/index.tsv" )
    command chmod 0600 "$ZS_DATA_DIR/index.tsv" 2>/dev/null
  fi
}

_zs_acquire_index_lock() {
  local lock_dir="$ZS_DATA_DIR/.index.lock"
  integer attempts=0
  while ! command mkdir "$lock_dir" 2>/dev/null; do
    if _zs_file_mtime_size "$lock_dir"; then
      if (( ${EPOCHSECONDS:-0} - _ZS_STAT_MTIME > 2 )); then
        command rmdir "$lock_dir" 2>/dev/null
        continue
      fi
    fi
    (( ++attempts > 20 )) && return 1
    command sleep 0.01 2>/dev/null
  done
  return 0
}

_zs_release_index_lock() {
  command rmdir "$ZS_DATA_DIR/.index.lock" 2>/dev/null || true
}

# ------------------------------------------------------------------------------
# 2. RFC 9562 UUIDv7 Generator & Short ID Resolver (0-fork pure Zsh)
# ------------------------------------------------------------------------------
_zs_uuidv7() {
  setopt LOCAL_OPTIONS NO_OCTAL_ZEROES
  local ts_sec="${EPOCHSECONDS:-0}"
  local ts_ms_part="000"
  local frac_seed="0"
  if [[ -n "$EPOCHREALTIME" && "$EPOCHREALTIME" == *.* ]]; then
    local frac="${EPOCHREALTIME#*.}"
    ts_ms_part="${(r:3::0:)frac[1,3]}"
    frac_seed="${frac[1,6]:-0}"
  fi
  integer total_ms=$(( ts_sec * 1000 + 10#$ts_ms_part ))
  integer hi32=$(( (total_ms >> 16) & 0xFFFFFFFF ))
  integer lo16=$(( total_ms & 0xFFFF ))

  # Mix high-resolution fractional time + PID + sequence into RANDOM so subshell $(_zs_uuidv7) calls never repeat random bits
  (( ++_ZS_UUID_SEQ ))
  RANDOM=$(( (RANDOM ^ 10#$frac_seed ^ ($$ * 31) ^ (_ZS_UUID_SEQ * 7919)) & 0x7FFF ))

  local rand_hex=""
  printf -v rand_hex "%04x%04x%04x%04x%04x" \
    $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536))

  local ver_rand="${rand_hex[1,3]}"
  integer var_nibble=$(( (16#${rand_hex[4]} & 0x3) | 0x8 ))
  local var_hex=""
  printf -v var_hex "%x" $var_nibble
  local var_rand="${rand_hex[5,7]}"
  local node_rand="${rand_hex[8,19]}"

  printf "%08x-%04x-7%s-%s%s-%s\n" "$hi32" "$lo16" "$ver_rand" "$var_hex" "$var_rand" "$node_rand"
}

_zs_resolve_sid() {
  setopt LOCAL_OPTIONS NULL_GLOB
  local query="$1"
  local allow_default="${2:-1}"

  if [[ -z "$query" ]]; then
    if (( allow_default == 1 )) && [[ -n "$ZS_SESSION_ID" ]]; then
      print -r -- "$ZS_SESSION_ID"
      return 0
    fi
    return 1
  fi

  # Security: strictly reject path traversal characters
  if [[ "$query" == (*/*|*..*) ]]; then
    print -u2 "$(_zs_tr "Invalid session ID: $query" "ID de sessão inválido: $query")"
    return 1
  fi

  # Fast path: exact match
  if [[ "$query" == "$ZS_SESSION_ID" || -f "$ZS_DATA_DIR/sessions/${query}.log" ]]; then
    print -r -- "$query"
    return 0
  fi

  local -A seen_cands
  local -a cands
  local f sid c_rest
  for f in "$ZS_DATA_DIR/sessions/"*.log; do
    sid="${f:t:r}"
    if [[ -n "$sid" && -z "${seen_cands[$sid]}" ]]; then
      seen_cands[$sid]=1
      cands+=("$sid")
    fi
  done
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    while IFS=$'\t' read -r sid c_rest; do
      if [[ -n "$sid" && -z "${seen_cands[$sid]}" ]]; then
        seen_cands[$sid]=1
        cands+=("$sid")
      fi
    done < "$ZS_DATA_DIR/index.tsv"
  fi
  if [[ -n "$ZS_SESSION_ID" && -z "${seen_cands[$ZS_SESSION_ID]}" ]]; then
    seen_cands[$ZS_SESSION_ID]=1
    cands+=("$ZS_SESSION_ID")
  fi

  local q_low="${query:l}"
  local -a matches=()
  for sid in "${cands[@]}"; do
    local s_low="${sid:l}"
    if [[ "$s_low" == "$q_low" ]]; then
      print -r -- "$sid"
      return 0
    fi
    if [[ "$s_low" == "${q_low}"* || "$s_low" == *"${q_low}" ]]; then
      matches+=("$sid")
    fi
  done

  if (( ${#matches[@]} == 0 )); then
    for sid in "${cands[@]}"; do
      local s_low="${sid:l}"
      if [[ "$s_low" == *"${q_low}"* ]]; then
        matches+=("$sid")
      fi
    done
  fi

  if (( ${#matches[@]} == 1 )); then
    print -r -- "${matches[1]}"
    return 0
  elif (( ${#matches[@]} > 1 )); then
    print -u2 "$(_zs_tr "Ambiguous session ID '$query' matches ${#matches[@]} sessions: ${matches[*]}" "ID de sessão ambíguo '$query' corresponde a ${#matches[@]} sessões: ${matches[*]}")"
    return 1
  fi

  return 1
}

# ------------------------------------------------------------------------------
# 3. Security: Sensitive File Check & Secret Redaction Engine
# ------------------------------------------------------------------------------
_zs_is_sensitive_file() {
  local filepath="$1"
  local base="${filepath:t}"
  case "$base" in
    .env|.env.*|*.env|*.pem|*.key|*.p12|*.pfx|*.jks|*.keystore) return 0 ;;
    id_rsa*|id_ed25519*|id_ecdsa*|id_dsa*|*.pub) return 0 ;;
    *credentials*|*secret*|*secrets*|.netrc|.npmrc|.pypirc|.pgpass) return 0 ;;
  esac
  case "$filepath" in
    */.aws/credentials|*/.ssh/*|*/.gnupg/*) return 0 ;;
  esac
  return 1
}

_zs_redact_text() {
  LC_ALL=C command sed -E \
    -e 's/([A-Za-z0-9_]*([Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]|[Pp][Aa][Ss][Ss][Ww][Dd]|[Pp][Aa][Ss][Ss]|[Pp][Ww][Dd]|[Ss][Ee][Cc][Rr][Ee][Tt]|[Tt][Oo][Kk][Ee][Nn]|[Aa][Pp][Ii]_?[Kk][Ee][Yy]|[Aa][Cc][Cc][Ee][Ss][Ss]_?[Kk][Ee][Yy]|[Pp][Rr][Ii][Vv][Aa][Tt][Ee]_?[Kk][Ee][Yy]|[Aa][Uu][Tt][Hh]|[Bb][Ee][Aa][Rr][Ee][Rr]|[Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee]_[Uu][Rr][Ll]))([[:space:]]*[:=][[:space:]]*)(['\''"]?[^][:space:]"'\'',;]+['\''"]?)/\1\3[REDACTED]/g' \
    -e 's/(--requirepass|--password|--token|--api-key|--secret|-a|-u)[[:space:]]+("[^"]*"|'\''[^'\'']*'\''|[^[:space:]]+)/\1 [REDACTED]/g' \
    -e 's/(ghp_[A-Za-z0-9_]{16,}|gho_[A-Za-z0-9_]{16,}|github_pat_[A-Za-z0-9_]{16,}|sk-[A-Za-z0-9_-]{16,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{20,})/[REDACTED]/g' \
    -e 's/eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}/[REDACTED]/g' \
    -e 's#(://[^/:@[:space:]]+:)[^/@[:space:]]+@#\1[REDACTED]@#g'
}

# ------------------------------------------------------------------------------
# 4. Zero Lixo & Command Classification Helpers
# ------------------------------------------------------------------------------
_zs_is_trivial_cmd() {
  local raw="$1"
  local trimmed="${raw#"${raw%%[![:space:]]*}"}"
  local first_word="${trimmed%%[[:space:]]*}"
  case "$first_word" in
    ""|ls|ll|la|l|cd|pwd|clear|cls|exit|logout|zs|history|whoami|date|true|false|echo)
      if [[ "$first_word" == "echo" && "$trimmed" == *">"* ]]; then
        return 1
      fi
      return 0
      ;;
  esac
  return 1
}

_zs_is_interactive_tui() {
  local raw="$1"
  local trimmed="${raw#"${raw%%[![:space:]]*}"}"
  local first_word="${trimmed%%[[:space:]]*}"
  if [[ "$first_word" == "sudo" ]]; then
    return 0
  fi
  case "$first_word" in
    agy|antigravity|antigravity-ide|agy-ide|gemini|claude|codex|aider|cursor|code|vim|nvim|vi|nano|emacs|micro|less|more|man|htop|top|btop|glances|mtr|watch|tmux|screen|zellij|ssh|scp|sftp|ftp|mosh|telnet|nc|netcat|expect|fzf|zs|exit|logout|clear|reset|su|gpg|pass|lazygit|lazydocker|k9s|tig|ranger|mc|nnn|yazi|python|python3|node|irb|psql|mysql|redis-cli|sqlite3|mongosh|gh|git|docker|kubectl|flutter|dart|npm|npx|yarn|pnpm|bun|brew|crontab|visudo)
      return 0
      ;;
  esac
  # Bypass scripts or compound commands that invoke interactive TUI/SSH/REPL tools
  if [[ "$trimmed" == *(agy|antigravity|gemini|claude|codex|ssh|telnet|expect|ftp|sudo|vim|nvim|nano|fzf|less|more)* ]]; then
    return 0
  fi
  if [[ "$first_word" == (./*|*.sh) && -f "$first_word" ]]; then
    if command grep -Eq '\b(agy|antigravity|expect|ssh|telnet|sudo|read|fzf|vim|nvim|nano)\b' "$first_word" 2>/dev/null; then
      return 0
    fi
  fi
  return 1
}

_zs_should_capture_stdout() {
  local raw="$1"
  (( ZS_CAPTURE_OUTPUT == 0 )) && return 1
  [[ "$ZS_CAPTURE_MODE" == "off" ]] && return 1

  local trimmed="${raw#"${raw%%[![:space:]]*}"}"
  [[ -z "$trimmed" ]] && return 1

  # 1. Never intercept stdout for interactive TUIs, REPLs, editors, or AI CLIs (preserves isatty(1) == true)
  if _zs_is_interactive_tui "$trimmed"; then
    return 1
  fi

  # 2. Never intercept stdout if command already redirects stdout or runs in background
  if [[ "$trimmed" == *">"* || "$trimmed" == *"&"* ]]; then
    return 1
  fi

  if [[ "$ZS_CAPTURE_MODE" == "all" ]]; then
    return 0
  fi

  # 3. Default "safe" allowlist mode: only capture single, non-piped, pure-output inspection commands
  if [[ "$trimmed" == *"|"* || "$trimmed" == *";"* ]]; then
    return 1
  fi

  local first_word="${trimmed%%[[:space:]]*}"
  case "$first_word" in
    cat|head|tail|wc|stat|file|uname|hostname|whoami|id|groups|date|uptime|df|du|free|env|printenv|pwd|which|whereis|expr|seq|basename|dirname|tr|cut|sort|uniq|md5|md5sum|shasum|sha256sum|dig|nslookup|host|ifconfig|ip|route|arp|netstat|ss|lsof|ps|lsblk|blkid|sysctl|echo|printf|curl)
      return 0
      ;;
  esac

  if [[ -n "$ZS_SAFE_CAPTURE_CMDS" ]]; then
    local ucmd
    for ucmd in ${=ZS_SAFE_CAPTURE_CMDS}; do
      [[ "$first_word" == "$ucmd" ]] && return 0
    done
  fi

  return 1
}

_zs_should_keep_session() {
  (( ZS_SESSION_CMD_COUNT == 0 )) && return 1
  if (( ZS_SESSION_MANUAL_META == 1 )); then
    return 0
  fi
  if (( ZS_SESSION_HAS_DIFF == 1 )); then
    return 0
  fi
  if (( ZS_SESSION_MEANINGFUL_COUNT >= ZS_MIN_MEANINGFUL_CMDS )); then
    return 0
  fi
  return 1
}

# ------------------------------------------------------------------------------
# 5. Session Metadata & Atomic Low-Fork Index Management
# ------------------------------------------------------------------------------
_zs_detect_project() {
  local dir="$PWD"
  while [[ -n "$dir" && "$dir" != "/" ]]; do
    if [[ -e "$dir/.git" ]]; then
      print -r -- "${dir:t}"
      return 0
    fi
    dir="${dir:h}"
  done
  print -r -- "${PWD:t}"
}

_zs_detect_branch() {
  local dir="$PWD"
  while [[ -n "$dir" && "$dir" != "/" ]]; do
    if [[ -f "$dir/.git/HEAD" ]]; then
      local head_ref=$(< "$dir/.git/HEAD")
      if [[ "$head_ref" == "ref: refs/heads/"* ]]; then
        print -r -- "${head_ref#ref: refs/heads/}"
      else
        print -r -- "${head_ref[1,7]}"
      fi
      return 0
    fi
    dir="${dir:h}"
  done
}

_zs_auto_title_from_cmd() {
  local cmd_clean="$1"
  cmd_clean=$(print -r -- "$cmd_clean" | _zs_redact_text | command tr '\n\t' '  ')
  if [[ ${#cmd_clean} -gt 55 ]]; then
    cmd_clean="${cmd_clean[1,52]}..."
  fi
  print -r -- "$cmd_clean"
}

_zs_update_index() {
  _zs_init_storage
  [[ -z "$ZS_SESSION_ID" ]] && return 0
  local now_str="$(_zs_now_ymd_hm)"
  [[ -z "$ZS_SESSION_CREATED_AT" ]] && ZS_SESSION_CREATED_AT="$now_str"
  local def_cat="$(_zs_default_category)"
  local cat_val="${ZS_SESSION_CATEGORY:-$def_cat}"
  local proj_val="${ZS_SESSION_PROJECT:-$(_zs_detect_project)}"
  local def_title="$(_zs_tr "Session in $proj_val" "Sessão em $proj_val")"
  local title_val="${ZS_SESSION_TITLE:-$def_title}"
  cat_val="${cat_val//[$'\t\n']/ }"
  proj_val="${proj_val//[$'\t\n']/ }"
  title_val="${title_val//[$'\t\n']/ }"
  local dir_val="${PWD//[$'\t\n']/ }"

  _zs_acquire_index_lock || true
  local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
  (
    umask 0077
    {
      if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
        local r_sid r_rest
        while IFS=$'\t' read -r r_sid r_rest; do
          if [[ -n "$r_sid" && "$r_sid" != "$ZS_SESSION_ID" ]]; then
            print -r -- "${r_sid}"$'\t'"${r_rest}"
          fi
        done < "$ZS_DATA_DIR/index.tsv"
      fi
      printf "%s\t%s\t%s\t%s\t%s\t%s\t%d\t%d\t%s\n" \
        "$ZS_SESSION_ID" \
        "$ZS_SESSION_CREATED_AT" \
        "$now_str" \
        "$cat_val" \
        "$proj_val" \
        "$dir_val" \
        "$ZS_SESSION_CMD_COUNT" \
        "$ZS_SESSION_HAS_DIFF" \
        "$title_val"
    } > "$tmp_idx"
    return 0
  )
  command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv" 2>/dev/null || true
  _zs_release_index_lock
}

_zs_remove_session_files() {
  local raw_sid="$1"
  [[ -z "$raw_sid" ]] && return 1
  local sid="$raw_sid"
  if [[ ! -f "$ZS_DATA_DIR/sessions/${sid}.log" && "$sid" != "$ZS_SESSION_ID" ]]; then
    sid=$(_zs_resolve_sid "$raw_sid" 0) || sid="$raw_sid"
  fi

  command rm -f "$ZS_DATA_DIR/sessions/$sid.log" 2>/dev/null
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    _zs_acquire_index_lock || true
    local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
    (
      umask 0077
      local r_sid r_rest
      while IFS=$'\t' read -r r_sid r_rest; do
        if [[ -n "$r_sid" && "$r_sid" != "$sid" ]]; then
          print -r -- "${r_sid}"$'\t'"${r_rest}"
        fi
      done < "$ZS_DATA_DIR/index.tsv" > "$tmp_idx"
      return 0
    )
    command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv" 2>/dev/null || true
    _zs_release_index_lock
  fi
  return 0
}

# ------------------------------------------------------------------------------
# 6. Snapshot & Diff Engine (CLI Tokens + Level-1 $PWD Config Files via zstat)
# ------------------------------------------------------------------------------
_zs_is_excluded_lockfile() {
  local base="${1:t}"
  case "$base" in
    package-lock.json|composer.lock|pnpm-lock.yaml|yarn.lock|Cargo.lock|tsconfig.tsbuildinfo)
      return 0
      ;;
  esac
  return 1
}

_zs_snapshot_single_file() {
  local resolved="$1"
  local max_bytes="${2:-1048576}"

  if [[ -z "$_ZS_SNAP_DIR" ]]; then
    _ZS_SNAP_DIR=$(command mktemp -d "${TMPDIR:-/tmp}/zs_snap.XXXXXX" 2>/dev/null)
    if [[ -n "$_ZS_SNAP_DIR" ]]; then
      command chmod 0700 "$_ZS_SNAP_DIR" 2>/dev/null || true
    fi
  fi
  [[ -z "$_ZS_SNAP_DIR" ]] && return 1

  if _zs_is_sensitive_file "$resolved"; then
    local mtime_before="0"
    if _zs_file_mtime_size "$resolved"; then
      mtime_before="$_ZS_STAT_MTIME"
    fi
    _ZS_SENSITIVE_TOUCHED+=("${resolved}:::${mtime_before}")
    return 0
  fi

  integer snap_idx=$(( ${#_ZS_TRACKED_FILES[@]} + 1 ))
  local snap_file="$_ZS_SNAP_DIR/snap_${snap_idx}"
  if [[ -f "$resolved" ]]; then
    if _zs_file_mtime_size "$resolved" && (( _ZS_STAT_SIZE < max_bytes )); then
      command cp -p "$resolved" "$snap_file" 2>/dev/null || true
      _ZS_TRACKED_FILES+=("${resolved}:::EXISTS:::${snap_file}")
    fi
  else
    : > "$snap_file"
    _ZS_TRACKED_FILES+=("${resolved}:::NEW:::${snap_file}")
  fi
  return 0
}

_zs_snapshot_files_before() {
  setopt LOCAL_OPTIONS NULL_GLOB
  local cmd_str="$1"
  _ZS_TRACKED_FILES=()
  _ZS_SENSITIVE_TOUCHED=()
  _ZS_PWD_EXISTING_CONFIGS=()
  _ZS_PWD_SCANNED=0
  _ZS_SNAP_DIR=""

  local -a tokens
  tokens=(${(z)cmd_str})
  local -A seen_paths
  local tok clean_tok resolved
  integer cli_count=0

  # 1. Explicit CLI file tokens (up to 5 files < 1MB)
  for tok in "${tokens[@]:1}"; do
    [[ "$tok" == -* || "$tok" == "|" || "$tok" == "&&" || "$tok" == ";" || "$tok" == ">" || "$tok" == ">>" ]] && continue
    clean_tok="${(Q)tok}"
    [[ -z "$clean_tok" ]] && continue

    if [[ "$clean_tok" == /* ]]; then
      resolved="$clean_tok"
    else
      resolved="$PWD/$clean_tok"
    fi

    [[ -n "${seen_paths[$resolved]}" ]] && continue

    if [[ -f "$resolved" || "${tokens[1]}" == (vim|nvim|vi|nano|micro|touch|tee) || ( ! -d "$resolved" && -d "${resolved:h}" && "$clean_tok" == (*.*|*/*) ) ]]; then
      seen_paths[$resolved]=1
      (( ++cli_count ))
      (( cli_count > 5 )) && break
      _zs_snapshot_single_file "$resolved" 1048576 || true
    fi
  done

  # 2. Level-1 $PWD config files (< 512KB, max ZS_MAX_DIR_SNAP_FILES) for in-editor or script modifications
  if (( ZS_MAX_DIR_SNAP_FILES > 0 )) && ! _zs_is_trivial_cmd "$cmd_str"; then
    _ZS_PWD_SCANNED=1
    local -a pwd_configs
    pwd_configs=("$PWD/"*.(yml|yaml|json|conf|toml|ini|xml|properties)(N.))
    integer dir_count=0
    local cfg_file
    for cfg_file in "${pwd_configs[@]}"; do
      _ZS_PWD_EXISTING_CONFIGS[$cfg_file]=1
      [[ -n "${seen_paths[$cfg_file]}" ]] && continue
      _zs_is_excluded_lockfile "$cfg_file" && continue
      (( ++dir_count > ZS_MAX_DIR_SNAP_FILES )) && break
      seen_paths[$cfg_file]=1
      _zs_snapshot_single_file "$cfg_file" 524288 || true
    done
  fi
  return 0
}

_zs_collect_diffs_after() {
  setopt LOCAL_OPTIONS NULL_GLOB
  local diff_output=""
  local entry filepath state snap_file rel_name raw_diff
  local -A processed_paths

  for entry in "${_ZS_SENSITIVE_TOUCHED[@]}"; do
    filepath="${entry%%:::*}"
    processed_paths[$filepath]=1
    local old_mtime="${entry##*:::}"
    local new_mtime="0"
    if _zs_file_mtime_size "$filepath"; then
      new_mtime="$_ZS_STAT_MTIME"
    fi
    if [[ "$old_mtime" != "$new_mtime" || ( "$old_mtime" == "0" && -e "$filepath" ) ]]; then
      rel_name="${filepath#$PWD/}"
      if _zs_is_pt; then
        diff_output+="  🔒 [Arquivo sensível editado: ${rel_name} — diff omitido por segurança]"$'\n'
      else
        diff_output+="  🔒 [Sensitive file edited: ${rel_name} — diff omitted for security]"$'\n'
      fi
      ZS_SESSION_HAS_DIFF=1
    fi
  done

  local diff_prefix="$(_zs_tr "Diff in" "Diff em")"

  for entry in "${_ZS_TRACKED_FILES[@]}"; do
    filepath="${entry%%:::*}"
    processed_paths[$filepath]=1
    local rest="${entry#*:::}"
    state="${rest%%:::*}"
    snap_file="${rest##*:::}"
    rel_name="${filepath#$PWD/}"

    if [[ "$state" == "NEW" && ! -f "$filepath" ]]; then
      continue
    fi
    if [[ -f "$filepath" && -f "$snap_file" ]]; then
      if ! command cmp -s "$snap_file" "$filepath" 2>/dev/null; then
        local clean_label="${rel_name#/}"
        raw_diff=$( (command diff -u --label "a/${clean_label}" --label "b/${clean_label}" "$snap_file" "$filepath" 2>/dev/null || true) | _zs_redact_text )
        if [[ -n "$raw_diff" ]]; then
          ZS_SESSION_HAS_DIFF=1
          diff_output+="  📝 ${diff_prefix} ${rel_name}:"$'\n'
          while IFS= read -r dline; do
            diff_output+="    ${dline}"$'\n'
          done <<< "$raw_diff"
        fi
      fi
    fi
  done

  # Detect newly created level-1 config files saved during bare vim/nvim or script execution
  if (( _ZS_PWD_SCANNED == 1 && ZS_MAX_DIR_SNAP_FILES > 0 )); then
    local -a current_configs
    current_configs=("$PWD/"*.(yml|yaml|json|conf|toml|ini|xml|properties)(N.))
    local new_cfg
    for new_cfg in "${current_configs[@]}"; do
      [[ -n "${_ZS_PWD_EXISTING_CONFIGS[$new_cfg]}" || -n "${processed_paths[$new_cfg]}" ]] && continue
      _zs_is_excluded_lockfile "$new_cfg" && continue
      rel_name="${new_cfg#$PWD/}"
      if _zs_is_sensitive_file "$new_cfg"; then
        if _zs_is_pt; then
          diff_output+="  🔒 [Arquivo sensível editado: ${rel_name} — diff omitido por segurança]"$'\n'
        else
          diff_output+="  🔒 [Sensitive file edited: ${rel_name} — diff omitted for security]"$'\n'
        fi
        ZS_SESSION_HAS_DIFF=1
      elif _zs_file_mtime_size "$new_cfg" && (( _ZS_STAT_SIZE < 524288 )); then
        local clean_label="${rel_name#/}"
        raw_diff=$( (command diff -u --label "a/${clean_label}" --label "b/${clean_label}" /dev/null "$new_cfg" 2>/dev/null || true) | _zs_redact_text )
        if [[ -n "$raw_diff" ]]; then
          ZS_SESSION_HAS_DIFF=1
          diff_output+="  📝 ${diff_prefix} ${rel_name}:"$'\n'
          while IFS= read -r dline; do
            diff_output+="    ${dline}"$'\n'
          done <<< "$raw_diff"
        fi
      fi
    done
  fi

  if [[ -n "$_ZS_SNAP_DIR" && -d "$_ZS_SNAP_DIR" ]]; then
    command rm -rf "$_ZS_SNAP_DIR" 2>/dev/null
  fi
  _ZS_SNAP_DIR=""
  _ZS_TRACKED_FILES=()
  _ZS_SENSITIVE_TOUCHED=()
  _ZS_PWD_EXISTING_CONFIGS=()
  _ZS_PWD_SCANNED=0

  print -rn -- "$diff_output"
}

# ------------------------------------------------------------------------------
# 7. Core Session Lifecycle & Hooks (preexec, precmd, zshexit)
# ------------------------------------------------------------------------------
_zs_start_new_session() {
  _zs_init_storage
  : $(( ++_ZS_UUID_SEQ + RANDOM ))
  ZS_SESSION_ID="$(_zs_uuidv7)"
  ZS_SESSION_CATEGORY=""
  ZS_SESSION_TITLE=""
  ZS_SESSION_PROJECT="$(_zs_detect_project)"
  ZS_SESSION_CREATED_AT="$(_zs_now_ymd_hm)"
  ZS_SESSION_CMD_COUNT=0
  ZS_SESSION_MEANINGFUL_COUNT=0
  ZS_SESSION_HAS_DIFF=0
  ZS_SESSION_MANUAL_META=0
  _ZS_LAST_CMD=""
}

_zs_append_turn_to_log() {
  local cmd_str="$1"
  local exit_code="$2"
  local duration_str="$3"
  local cmd_output="$4"
  local diff_block="$5"

  _zs_init_storage
  [[ -z "$ZS_SESSION_ID" ]] && _zs_start_new_session

  local log_file="$ZS_DATA_DIR/sessions/$ZS_SESSION_ID.log"
  umask 0077
  if [[ ! -f "$log_file" ]]; then
    : > "$log_file"
    command chmod 0600 "$log_file" 2>/dev/null
  fi

  local ts_hms="$(_zs_now_hms)"
  local short_pwd="${PWD/#$HOME/~}"
  local branch="$(_zs_detect_branch)"
  local branch_tag=""
  [[ -n "$branch" ]] && branch_tag=" ($branch)"

  local safe_cmd=$(print -r -- "$cmd_str" | _zs_redact_text)

  # Strip terminal OSC title sequences (\e]...\a or \e]...\e\\) if any leaked into output
  if [[ -n "$cmd_output" ]]; then
    cmd_output=$(print -r -- "$cmd_output" | LC_ALL=C command sed -E $'s/\x1b\\][^\x07\x1b]*(\x07|\x1b\\\\)//g')
  fi

  {
    printf "[%s] %s%s \$ %s (exit: %d | %s)\n" \
      "$ts_hms" "$short_pwd" "$branch_tag" "$safe_cmd" "$exit_code" "$duration_str"

    if [[ -n "${cmd_output//[[:space:]]/}" ]]; then
      local safe_out=$(print -r -- "$cmd_output" | _zs_redact_text)
      local -a out_lines
      out_lines=("${(@f)safe_out}")
      integer total_lines=${#out_lines[@]}
      if (( total_lines > ZS_MAX_OUTPUT_LINES )); then
        integer head_cnt=$(( ZS_MAX_OUTPUT_LINES / 2 ))
        integer tail_cnt=$(( ZS_MAX_OUTPUT_LINES - head_cnt ))
        integer omitted=$(( total_lines - head_cnt - tail_cnt ))
        local l
        for l in "${out_lines[@]:0:$head_cnt}"; do
          printf "  │ %s\n" "$l"
        done
        if _zs_is_pt; then
          printf "  │ ... [%d linhas omitidas] ...\n" "$omitted"
        else
          printf "  │ ... [%d lines omitted] ...\n" "$omitted"
        fi
        for l in "${out_lines[@]: -$tail_cnt}"; do
          printf "  │ %s\n" "$l"
        done
      else
        local l
        for l in "${out_lines[@]}"; do
          printf "  │ %s\n" "$l"
        done
      fi
    fi

    if [[ -n "$diff_block" ]]; then
      printf "%s\n" "${diff_block%$'\n'}"
    fi
    printf "\n"
  } >> "$log_file"

  (( ++ZS_SESSION_CMD_COUNT ))
  if ! _zs_is_trivial_cmd "$cmd_str"; then
    (( ++ZS_SESSION_MEANINGFUL_COUNT ))
    if [[ -z "$ZS_SESSION_TITLE" ]]; then
      ZS_SESSION_TITLE="$(_zs_auto_title_from_cmd "$safe_cmd")"
    fi
  elif [[ -z "$ZS_SESSION_TITLE" && -n "$diff_block" ]]; then
    ZS_SESSION_TITLE="$(_zs_auto_title_from_cmd "$safe_cmd")"
  fi

  ZS_SESSION_PROJECT="$(_zs_detect_project)"
  _zs_update_index
}

_zs_restore_tty() {
  if (( _ZS_REDIRECT_ACTIVE == 1 )); then
    if [[ -w /dev/tty ]]; then
      exec 1>/dev/tty 2>/dev/tty 2>/dev/null
    fi
    _ZS_REDIRECT_ACTIVE=0
  fi
}

_zs_preexec() {
  local cmd_str="$1"
  # Ensure previous redirection is always cleaned up first
  _zs_restore_tty

  # 1. Respect leading space (HIST_IGNORE_SPACE)
  if [[ "$cmd_str" == [[:space:]]* ]]; then
    _ZS_ACTIVE_CMD=""
    return 0
  fi

  # 2. Skip internal zs commands, exit, or single-line plugin reload
  local trimmed="${cmd_str#"${cmd_str%%[![:space:]]*}"}"
  local first_word="${trimmed%%[[:space:]]*}"
  if [[ "$first_word" == "zs" || "$first_word" == "exit" || "$first_word" == "logout" ]]; then
    _ZS_ACTIVE_CMD=""
    return 0
  fi
  if [[ ( "$first_word" == "source" || "$first_word" == "." ) && "$trimmed" != *$'\n'* ]]; then
    _ZS_ACTIVE_CMD=""
    return 0
  fi

  _ZS_ACTIVE_CMD="$cmd_str"
  _ZS_CMD_START_TS="${EPOCHSECONDS:-0}"

  # 3. Snapshot files for diff tracking
  _zs_snapshot_files_before "$cmd_str"

  # 4. Capture stdout/stderr ONLY for safe allowlisted commands while keeping native TTY for all TUIs/CLIs
  if [[ -w /dev/tty ]] && _zs_should_capture_stdout "$cmd_str"; then
    _ZS_CMD_OUT_FILE=$(command mktemp "${TMPDIR:-/tmp}/zs_out.XXXXXX" 2>/dev/null)
    if [[ -n "$_ZS_CMD_OUT_FILE" ]]; then
      command chmod 0600 "$_ZS_CMD_OUT_FILE" 2>/dev/null
      setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
      exec > >(command tee -a "$_ZS_CMD_OUT_FILE" > /dev/tty) 2>&1
      _ZS_REDIRECT_ACTIVE=1
    fi
  fi
}

_zs_precmd() {
  local last_exit=$?

  # 1. Immediately restore stdout/stderr directly to /dev/tty
  if (( _ZS_REDIRECT_ACTIVE == 1 )); then
    _zs_restore_tty
    command sleep 0.01 2>/dev/null
  fi

  [[ -z "$_ZS_ACTIVE_CMD" ]] && return 0
  local cmd_str="$_ZS_ACTIVE_CMD"
  _ZS_ACTIVE_CMD=""

  # 2. Calculate duration
  integer end_ts="${EPOCHSECONDS:-0}"
  integer elapsed_sec=$(( end_ts - _ZS_CMD_START_TS ))
  (( elapsed_sec < 0 )) && elapsed_sec=0
  local duration_str="${elapsed_sec}s"

  # 3. Read captured output
  local captured_out=""
  if [[ -n "$_ZS_CMD_OUT_FILE" && -f "$_ZS_CMD_OUT_FILE" ]]; then
    captured_out=$(< "$_ZS_CMD_OUT_FILE")
    command rm -f "$_ZS_CMD_OUT_FILE" 2>/dev/null
  fi
  _ZS_CMD_OUT_FILE=""

  # 4. Collect file diffs
  local diff_block
  diff_block=$(_zs_collect_diffs_after)

  # 5. Deduplicate consecutive identical noise commands if no diff occurred
  if [[ "$cmd_str" == "$_ZS_LAST_CMD" && -z "$diff_block" ]] && _zs_is_trivial_cmd "$cmd_str"; then
    return 0
  fi
  _ZS_LAST_CMD="$cmd_str"

  # 6. Append to session thread log
  _zs_append_turn_to_log "$cmd_str" "$last_exit" "$duration_str" "$captured_out" "$diff_block"
}

# Helper for deterministic execution + recording (used in tests and scripts)
zs_record_exec() {
  local cmd_str="$*"
  [[ -z "$cmd_str" ]] && return 0
  if [[ "$cmd_str" == [[:space:]]* ]]; then
    eval "$cmd_str"
    return $?
  fi

  _ZS_CMD_START_TS="${EPOCHSECONDS:-0}"
  _zs_snapshot_files_before "$cmd_str"

  local out_file=$(command mktemp "${TMPDIR:-/tmp}/zs_exec.XXXXXX" 2>/dev/null)
  command chmod 0600 "$out_file" 2>/dev/null
  eval "$cmd_str" > "$out_file" 2>&1
  local exit_code=$?

  local captured_out=""
  [[ -f "$out_file" ]] && captured_out=$(< "$out_file")
  command rm -f "$out_file" 2>/dev/null

  local diff_block
  diff_block=$(_zs_collect_diffs_after)

  if [[ "$cmd_str" == "$_ZS_LAST_CMD" && -z "$diff_block" ]] && _zs_is_trivial_cmd "$cmd_str"; then
    return $exit_code
  fi
  _ZS_LAST_CMD="$cmd_str"

  _zs_append_turn_to_log "$cmd_str" "$exit_code" "0s" "$captured_out" "$diff_block"
  return $exit_code
}

# Explicit on-demand output & diff capture for any command (`zs cap <cmd...>`)
_zs_cap_command() {
  local cmd_str="$*"
  if [[ -z "$cmd_str" ]]; then
    print -u2 "$(_zs_tr "Usage: zs cap <command> [args...]" "Uso: zs cap <comando> [argumentos...]")"
    return 1
  fi

  integer start_ts="${EPOCHSECONDS:-0}"
  _zs_snapshot_files_before "$cmd_str"

  local out_file=$(command mktemp "${TMPDIR:-/tmp}/zs_cap.XXXXXX" 2>/dev/null)
  command chmod 0600 "$out_file" 2>/dev/null

  eval "$cmd_str" 2>&1 | command tee "$out_file"
  local exit_code=${pipestatus[1]:-$?}

  integer end_ts="${EPOCHSECONDS:-0}"
  integer elapsed_sec=$(( end_ts - start_ts ))
  (( elapsed_sec < 0 )) && elapsed_sec=0

  local captured_out=""
  [[ -f "$out_file" ]] && captured_out=$(< "$out_file")
  command rm -f "$out_file" 2>/dev/null

  local diff_block
  diff_block=$(_zs_collect_diffs_after)

  _ZS_LAST_CMD="$cmd_str"
  _zs_append_turn_to_log "$cmd_str" "$exit_code" "${elapsed_sec}s" "$captured_out" "$diff_block"
  return $exit_code
}

# ------------------------------------------------------------------------------
# 8. Manual Category Management & Closing Flow (exit / SIGHUP)
# ------------------------------------------------------------------------------
_zs_cat_add() {
  _zs_init_storage
  local cat_name="${1#"${1%%[![:space:]]*}"}"
  cat_name="${cat_name%"${cat_name##*[![:space:]]}"}"
  if [[ -z "$cat_name" || "$cat_name" == "-h" || "$cat_name" == "--help" ]]; then
    print -r -- "$(_zs_tr "Usage: zs cat add \"<category_name>\"" "Uso: zs cat add \"<nome_da_categoria>\"")"
    print -r -- "$(_zs_tr "Example: zs cat add \"DevOps\"" "Exemplo: zs cat add \"DevOps\"")"
    return 0
  fi
  if ! command grep -Fxq "$cat_name" "$ZS_DATA_DIR/categories.txt" 2>/dev/null; then
    print -r -- "$cat_name" >> "$ZS_DATA_DIR/categories.txt"
  fi
  print -r -- "$(_zs_tr "Category created/available: $cat_name" "Categoria criada/disponível: $cat_name")"
}

_zs_cat_list() {
  _zs_init_storage
  print -r -- "$(_zs_tr "📂 Registered categories:" "📂 Categorias cadastradas:")"
  if [[ ! -s "$ZS_DATA_DIR/categories.txt" ]]; then
    print -r -- "$(_zs_tr "  (No categories created yet. Use: zs cat add <name>)" "  (Nenhuma categoria criada ainda. Use: zs cat add <nome>)")"
  else
    while IFS= read -r c; do
      [[ -z "$c" ]] && continue
      integer cnt=0
      if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
        local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_rest
        while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_rest; do
          if [[ "$r_cat" == "$c" ]] && (( ${r_cnt:-0} > 0 )); then
            (( ++cnt ))
          fi
        done < "$ZS_DATA_DIR/index.tsv"
      fi
      if _zs_is_pt; then
        printf "  • %-22s (%d sessões)\n" "$c" "$cnt"
      else
        printf "  • %-22s (%d sessions)\n" "$c" "$cnt"
      fi
    done < "$ZS_DATA_DIR/categories.txt"
  fi
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    integer uncat=0
    local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_rest
    while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_rest; do
      if _zs_is_uncategorized_val "$r_cat" && (( ${r_cnt:-0} > 0 )); then
        (( ++uncat ))
      fi
    done < "$ZS_DATA_DIR/index.tsv"
    if (( uncat > 0 )); then
      if _zs_is_pt; then
        printf "  • %-22s (%d sessões pendentes)\n" "[Sem Categoria]" "$uncat"
      else
        printf "  • %-22s (%d pending sessions)\n" "[Uncategorized]" "$uncat"
      fi
    fi
  fi
}

_zs_cat_set() {
  _zs_init_storage
  local cat_name="$1"
  local raw_sid="${2:-$ZS_SESSION_ID}"
  if [[ -z "$cat_name" || -z "$raw_sid" ]]; then
    print -u2 "$(_zs_tr "Usage: zs cat set \"<category>\" [session_id]" "Uso: zs cat set \"<categoria>\" [session_id]")"
    return 1
  fi
  local target_sid
  target_sid=$(_zs_resolve_sid "$raw_sid" 1) || target_sid="$raw_sid"
  _zs_cat_add "$cat_name" >/dev/null

  if [[ "$target_sid" == "$ZS_SESSION_ID" ]]; then
    ZS_SESSION_CATEGORY="$cat_name"
    ZS_SESSION_MANUAL_META=1
    _zs_update_index
  elif [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    _zs_acquire_index_lock
    local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
    (
      umask 0077
      local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title
      while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title; do
        [[ -z "$r_sid" ]] && continue
        [[ "$r_sid" == "$target_sid" ]] && r_cat="$cat_name"
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
          "$r_sid" "$r_c" "$r_u" "$r_cat" "$r_proj" "$r_dir" "$r_cnt" "$r_diff" "$r_title"
      done < "$ZS_DATA_DIR/index.tsv" > "$tmp_idx"
    )
    command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv" 2>/dev/null
    _zs_release_index_lock
  fi
  print -r -- "$(_zs_tr "✓ Session [$target_sid] assigned to category: $cat_name" "✓ Sessão [$target_sid] atribuída à categoria: $cat_name")"
}

_zs_interactive_choose_category() {
  local raw_sid="${1:-$ZS_SESSION_ID}"
  local on_exit_mode="${2:-0}"
  _zs_init_storage
  local target_sid
  target_sid=$(_zs_resolve_sid "$raw_sid" 1) || target_sid="$raw_sid"

  local create_label="$(_zs_tr "[+] Create new category..." "[+] Criar nova categoria...")"
  local skip_label="$(_zs_tr "⏭️  Save uncategorized (classify later)" "⏭️  Salvar sem categoria (classificar depois)")"
  local discard_label="$(_zs_tr "🗑️  Discard this session (do not save)" "🗑️  Descartar esta sessão (não salvar)")"

  local -a options
  options=("$create_label")
  if [[ -s "$ZS_DATA_DIR/categories.txt" ]]; then
    while IFS= read -r c; do
      [[ -n "$c" ]] && options+=("📁 $c")
    done < "$ZS_DATA_DIR/categories.txt"
  fi
  if (( on_exit_mode == 1 )); then
    options+=("$skip_label")
    options+=("$discard_label")
  fi

  local choice=""
  if (( ${ZS_NO_FZF:-0} == 0 )) && command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
    local fzf_prompt="$(_zs_tr "📂 Session Category > " "📂 Categoria da Sessão > ")"
    local fzf_hdr="$(_zs_tr "Select an existing category or create a new one" "Escolha uma categoria existente ou crie uma nova")"
    choice=$(printf "%s\n" "${actions_or_opts:-${options[@]}}" | command fzf --height=40% --reverse --prompt="$fzf_prompt" --header="$fzf_hdr")
  else
    print -r -- "$(_zs_tr "📂 Choose a category for the session ($ZS_SESSION_CMD_COUNT commands):" "📂 Escolha uma categoria para a sessão ($ZS_SESSION_CMD_COUNT comandos):")"
    integer i=1
    local opt
    for opt in "${options[@]}"; do
      printf "  [%d] %s\n" "$i" "$opt"
      (( ++i ))
    done
    printf "%s [1-%d]: " "$(_zs_tr "Option" "Opção")" "${#options[@]}"
    local num
    read -r num
    if [[ "$num" == <-> ]] && (( num >= 1 && num <= ${#options[@]} )); then
      choice="${options[$num]}"
    fi
  fi

  case "$choice" in
    "$create_label")
      printf "%s" "$(_zs_tr "Enter new category name: " "Digite o nome da nova categoria: ")"
      local new_cat
      read -r new_cat
      if [[ -n "$new_cat" ]]; then
        _zs_cat_set "$new_cat" "$target_sid"
      fi
      ;;
    "📁 "*)
      local selected_cat="${choice#📁 }"
      _zs_cat_set "$selected_cat" "$target_sid"
      ;;
    "$discard_label")
      _zs_remove_session_files "$target_sid"
      ZS_SESSION_ID=""
      print -r -- "$(_zs_tr "🗑️  Session discarded." "🗑️  Sessão descartada.")"
      ;;
    *)
      if (( on_exit_mode == 1 )); then
        _zs_update_index
      fi
      ;;
  esac
}

_zs_handle_shell_exit_prompt() {
  _zs_restore_tty
  [[ -z "$ZS_SESSION_ID" ]] && return 0
  if ! _zs_should_keep_session; then
    _zs_remove_session_files "$ZS_SESSION_ID"
    ZS_SESSION_ID=""
    return 0
  fi
  if _zs_is_uncategorized_val "$ZS_SESSION_CATEGORY"; then
    if [[ -t 0 && -t 1 ]]; then
      _zs_interactive_choose_category "$ZS_SESSION_ID" 1
    else
      _zs_update_index
    fi
  else
    _zs_update_index
  fi
}

_zs_on_zshexit() {
  _zs_restore_tty
  [[ -z "$ZS_SESSION_ID" ]] && return 0
  if ! _zs_should_keep_session; then
    _zs_remove_session_files "$ZS_SESSION_ID"
  else
    _zs_update_index
  fi
}

# Zero-fork check for pending uncategorized sessions on startup
_zs_notify_pending_categories() {
  [[ ! -f "$ZS_DATA_DIR/index.tsv" ]] && return 0
  integer pending_cnt=0
  local sid c_at u_at cat proj dir cnt diff title
  while IFS=$'\t' read -r sid c_at u_at cat proj dir cnt diff title; do
    if [[ -n "$sid" && "$sid" != "$ZS_SESSION_ID" ]] && _zs_is_uncategorized_val "$cat" && (( ${cnt:-0} > 0 )); then
      (( ++pending_cnt ))
    fi
  done < "$ZS_DATA_DIR/index.tsv"
  if (( pending_cnt > 0 )); then
    if _zs_is_pt; then
      print -P "%F{yellow}💡 [zsh-sessions] Você tem ${pending_cnt} sessão(ões) anterior(es) sem categoria. Digite %Bzs cat%b ou %Bzs%b para classificar.%f"
    else
      print -P "%F{yellow}💡 [zsh-sessions] You have ${pending_cnt} uncategorized previous session(s). Run %Bzs cat%b or %Bzs%b to classify.%f"
    fi
  fi
}

# ------------------------------------------------------------------------------
# 9. Session Actions: Show, Rename, Resume (+ History Injection), AI, Search, Export
# ------------------------------------------------------------------------------
_zs_show_session() {
  local raw_sid="${1:-$ZS_SESSION_ID}"
  local sid
  sid=$(_zs_resolve_sid "$raw_sid" 1) || sid="$raw_sid"
  local log_file="$ZS_DATA_DIR/sessions/$sid.log"
  if [[ ! -f "$log_file" ]]; then
    print -r -- "$(_zs_tr "Session not found or no commands recorded yet ($raw_sid)." "Sessão não encontrada ou ainda sem comandos gravados ($raw_sid).")"
    return 1
  fi

  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local meta=""
    local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title
    while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title; do
      if [[ "$r_sid" == "$sid" ]]; then
        if _zs_is_pt; then
          meta=$(printf "ID: %s | Data: %s | Categoria: [%s] | Projeto: %s | Cmds: %s\nTítulo: %s\nÚltima pasta: %s" "$r_sid" "$r_u" "$r_cat" "$r_proj" "$r_cnt" "$r_title" "$r_dir")
        else
          meta=$(printf "ID: %s | Date: %s | Category: [%s] | Project: %s | Cmds: %s\nTitle: %s\nLast directory: %s" "$r_sid" "$r_u" "$r_cat" "$r_proj" "$r_cnt" "$r_title" "$r_dir")
        fi
        break
      fi
    done < "$ZS_DATA_DIR/index.tsv"
    if [[ -n "$meta" ]]; then
      print -r -- "======================================================================"
      print -r -- "$meta"
      print -r -- "======================================================================"
    fi
  fi

  command awk '
    /^\[[0-9]{2}:[0-9]{2}:[0-9]{2}\]/ { printf "\033[1;36m%s\033[0m\n", $0; next }
    /^  📝 Diff/ { printf "\033[1;33m%s\033[0m\n", $0; next }
    /^  🔒/ { printf "\033[1;35m%s\033[0m\n", $0; next }
    /^    \+/ { printf "\033[32m%s\033[0m\n", $0; next }
    /^    -/ { printf "\033[31m%s\033[0m\n", $0; next }
    /^    @@/ { printf "\033[36m%s\033[0m\n", $0; next }
    { print $0 }
  ' "$log_file"
}

_zs_rename_session() {
  local new_title="$1"
  local raw_sid="${2:-$ZS_SESSION_ID}"
  local target_sid
  target_sid=$(_zs_resolve_sid "$raw_sid" 1) || target_sid="$raw_sid"
  if [[ -z "$new_title" ]]; then
    printf "%s" "$(_zs_tr "New title for session [$target_sid]: " "Novo título para a sessão [%s]: " | sed "s/%s/$target_sid/")"
    read -r new_title
  fi
  [[ -z "$new_title" ]] && return 1

  if [[ "$target_sid" == "$ZS_SESSION_ID" ]]; then
    ZS_SESSION_TITLE="$new_title"
    ZS_SESSION_MANUAL_META=1
    _zs_update_index
  elif [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    _zs_acquire_index_lock
    local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
    (
      umask 0077
      local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title
      while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title; do
        [[ -z "$r_sid" ]] && continue
        [[ "$r_sid" == "$target_sid" ]] && r_title="${new_title//[$'\t\n']/ }"
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
          "$r_sid" "$r_c" "$r_u" "$r_cat" "$r_proj" "$r_dir" "$r_cnt" "$r_diff" "$r_title"
      done < "$ZS_DATA_DIR/index.tsv" > "$tmp_idx"
    )
    command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv" 2>/dev/null
    _zs_release_index_lock
  fi
  print -r -- "$(_zs_tr "✓ Title updated: $new_title" "✓ Título atualizado: $new_title")"
}

_zs_resume_session() {
  local raw_sid="$1"
  if [[ -z "$raw_sid" || ! -f "$ZS_DATA_DIR/index.tsv" ]]; then
    print -u2 "$(_zs_tr "Usage: zs resume <session_id_or_prefix>" "Uso: zs resume <session_id>")"
    return 1
  fi

  local target_sid
  if ! target_sid=$(_zs_resolve_sid "$raw_sid" 0); then
    print -u2 "$(_zs_tr "Session $raw_sid not found." "Sessão $raw_sid não encontrada.")"
    return 1
  fi

  local row=""
  local r_sid r_rest
  while IFS=$'\t' read -r r_sid r_rest; do
    if [[ "$r_sid" == "$target_sid" ]]; then
      row="${r_sid}"$'\t'"${r_rest}"
      break
    fi
  done < "$ZS_DATA_DIR/index.tsv"

  if [[ -z "$row" ]]; then
    print -u2 "$(_zs_tr "Session $target_sid not found." "Sessão $target_sid não encontrada.")"
    return 1
  fi

  if [[ -n "$ZS_SESSION_ID" && "$ZS_SESSION_ID" != "$target_sid" ]]; then
    if ! _zs_should_keep_session; then
      _zs_remove_session_files "$ZS_SESSION_ID"
    else
      _zs_update_index
    fi
  fi

  local -a fields
  fields=("${(@ps:\t:)row}")
  ZS_SESSION_ID="${fields[1]}"
  ZS_SESSION_CREATED_AT="${fields[2]}"
  ZS_SESSION_CATEGORY="${fields[4]}"
  ZS_SESSION_PROJECT="${fields[5]}"
  local target_dir="${fields[6]}"
  ZS_SESSION_CMD_COUNT="${fields[7]:-0}"
  ZS_SESSION_HAS_DIFF="${fields[8]:-0}"
  ZS_SESSION_TITLE="${fields[9]}"
  ZS_SESSION_MEANINGFUL_COUNT="$ZS_SESSION_CMD_COUNT"
  ZS_SESSION_MANUAL_META=1

  if [[ -n "$target_dir" && -d "$target_dir" ]]; then
    builtin cd "$target_dir" || true
  fi

  print -rP "%F{green}▶ $(_zs_tr "Resuming session:" "Retomando sessão:")%f %B${ZS_SESSION_TITLE}%b [%F{cyan}${ZS_SESSION_CATEGORY}%f]"
  print -rP "%F{242}ID: ${ZS_SESSION_ID} | $(_zs_tr "Dir" "Pasta"): ${PWD/#$HOME/~}%f"
  local log_file="$ZS_DATA_DIR/sessions/$ZS_SESSION_ID.log"
  if [[ -f "$log_file" ]]; then
    # Inject session commands into Zsh Up-Arrow history stack (print -S)
    local -a hist_cmds=()
    local line extracted prev_cmd=""
    while IFS= read -r line; do
      if [[ "$line" == \[[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\]*" \$ "*" (exit: "* ]]; then
        extracted="${line#* \$ }"
        extracted="${extracted% \(exit: *}"
        if [[ -n "$extracted" && "$extracted" != "$prev_cmd" ]]; then
          hist_cmds+=("$extracted")
          prev_cmd="$extracted"
        fi
      fi
    done < "$log_file"
    integer total_h=${#hist_cmds[@]}
    integer start_h=$(( total_h > 50 ? total_h - 50 : 0 ))
    local h_cmd
    for h_cmd in "${hist_cmds[@]:$start_h}"; do
      builtin print -S -- "$h_cmd" 2>/dev/null || true
    done

    print -P "%F{yellow}--- $(_zs_tr "Recent commands in this conversation" "Últimos comandos desta conversa") ---%f"
    command grep -E '^\[[0-9]{2}:[0-9]{2}:[0-9]{2}\]' "$log_file" | command tail -n 5
    print -P "%F{yellow}---------------------------------------%f"
  fi
}

_zs_ai_categorize() {
  local raw_sid="${1:-$ZS_SESSION_ID}"
  local target_sid
  target_sid=$(_zs_resolve_sid "$raw_sid" 1) || target_sid="$raw_sid"
  local log_file="$ZS_DATA_DIR/sessions/$target_sid.log"
  if [[ ! -f "$log_file" ]]; then
    print -u2 "$(_zs_tr "Session log not found for categorization." "Log da sessão não encontrado para categorização.")"
    return 1
  fi

  local summary_cmds
  summary_cmds=$(command grep -E '^\[[0-9]{2}:[0-9]{2}:[0-9]{2}\]|^  📝 Diff' "$log_file" | command head -n 30 | _zs_redact_text)

  if [[ -n "$GEMINI_API_KEY" ]] && command -v curl >/dev/null 2>&1; then
    local existing_cats=$(command tr '\n' ',' < "$ZS_DATA_DIR/categories.txt" 2>/dev/null)
    local prompt
    if _zs_is_pt; then
      prompt="Com base nestes comandos de terminal (já sanitizados), responda APENAS no formato CATEGORIA|TITULO_CURTO (máx 50 chars). Categorias existentes: ${existing_cats}. Comandos: ${summary_cmds}"
    else
      prompt="Based on these sanitized terminal commands, reply ONLY in the format CATEGORY|SHORT_TITLE (max 50 chars). Existing categories: ${existing_cats}. Commands: ${summary_cmds}"
    fi
    local escaped_prompt=$(print -r -- "$prompt" | command tr '\n"\t\\' '    ')
    local resp
    resp=$(command curl -sS --max-time 8 \
      -H "Content-Type: application/json" \
      -d "{\"contents\":[{\"parts\":[{\"text\":\"${escaped_prompt}\"}]}]}" \
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}" 2>/dev/null)
    local parsed
    parsed=$(print -r -- "$resp" | command sed -nE 's/.*"text":[[:space:]]*"([^"|]+\|[^"]+)".*/\1/p' | command head -n 1)
    if [[ -n "$parsed" && "$parsed" == *"|"* ]]; then
      local ai_cat="${parsed%%|*}"
      local ai_title="${parsed#*|}"
      ai_cat="${ai_cat//\\n/}"
      ai_title="${ai_title//\\n/}"
      _zs_cat_set "$ai_cat" "$target_sid" >/dev/null
      _zs_rename_session "$ai_title" "$target_sid" >/dev/null
      print -r -- "🤖 [AI] $(_zs_tr "Category" "Categoria"): [$ai_cat] | $(_zs_tr "Title" "Título"): $ai_title"
      return 0
    fi
  fi

  local auto_cat="Terminal"
  if print -r -- "$summary_cmds" | command grep -Eq 'docker|kubectl|helm|terraform|systemctl|nginx'; then
    auto_cat="DevOps"
  elif print -r -- "$summary_cmds" | command grep -Eq 'git (commit|rebase|merge|push|pull|checkout|branch)'; then
    auto_cat="Git"
  elif print -r -- "$summary_cmds" | command grep -Eq 'pytest|jest|cargo test|go test|npm test|mvn test|gradle test'; then
    auto_cat="$(_zs_tr "Tests" "Testes")"
  elif print -r -- "$summary_cmds" | command grep -Eq 'psql|mysql|redis-cli|mongosh|sqlite3|flyway'; then
    auto_cat="Database"
  elif print -r -- "$summary_cmds" | command grep -Eq '📝 Diff'; then
    auto_cat="Config"
  fi
  _zs_cat_set "$auto_cat" "$target_sid" >/dev/null
  print -r -- "🤖 [Auto] $(_zs_tr "Session classified as:" "Sessão classificada em:") [$auto_cat]"
}

# Full-Text Search across all session logs (`zs search [query]` & `Ctrl+S` in fzf)
_zs_search_sessions() {
  setopt LOCAL_OPTIONS NULL_GLOB
  _zs_init_storage
  local query="$*"

  local -a log_files
  log_files=("$ZS_DATA_DIR/sessions/"*.log)
  if (( ${#log_files[@]} == 0 )); then
    print -r -- "$(_zs_tr "No saved sessions found to search." "Nenhuma sessão salva para buscar.")"
    return 1
  fi

  # Interactive fzf full-text search if no query passed and fzf is available
  if [[ -z "$query" ]]; then
    if (( ${ZS_NO_FZF:-0} == 0 )) && command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
      local -A meta_map
      if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
        local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title
        while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title; do
          meta_map[$r_sid]="[${r_cat} | ${r_proj}]"
        done < "$ZS_DATA_DIR/index.tsv"
      fi
      local stream="" f sid l tag
      for f in "${log_files[@]}"; do
        sid="${f:t:r}"
        tag="${meta_map[$sid]:-[$sid[1,8]]}"
        while IFS= read -r l; do
          [[ -z "${l//[[:space:]]/}" ]] && continue
          stream+="${sid}"$'\t'"${tag} ${l}"$'\n'
        done < "$f"
      done
      local preview_cmd="zsh -c 'source \"${ZS_PLUGIN_DIR}/zsh-sessions.plugin.zsh\" >/dev/null 2>&1; ZS_DATA_DIR=\"${ZS_DATA_DIR}\" _zs_show_session {1}'"
      local sel
      sel=$(print -rn -- "$stream" | command fzf \
        --ansi \
        --delimiter='\t' \
        --with-nth=2.. \
        --prompt="🔍 $(_zs_tr "Search Logs > " "Buscar nos Logs > ")" \
        --preview="$preview_cmd" \
        --preview-window="right:60%:wrap")
      if [[ -n "$sel" ]]; then
        local chosen_sid="${sel%%$'\t'*}"
        _zs_action_menu_for_session "$chosen_sid"
        return 0
      fi
      return 0
    else
      print -u2 "$(_zs_tr "Usage: zs search <query>" "Uso: zs search <termo>")"
      return 1
    fi
  fi

  # CLI search mode (`zs search <query>`)
  local -A meta_header
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title
    while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title; do
      meta_header[$r_sid]="${r_sid} | ${r_u} | [${r_cat}] | ${r_proj} | ${r_title}"
    done < "$ZS_DATA_DIR/index.tsv"
  fi

  integer found_any=0
  local f sid matches
  for f in "${log_files[@]}"; do
    matches=$(command grep -niF -- "$query" "$f" 2>/dev/null || true)
    if [[ -n "$matches" ]]; then
      (( ++found_any ))
      sid="${f:t:r}"
      print -rP "%F{cyan}=== ${meta_header[$sid]:-$sid} ===%f"
      while IFS= read -r mline; do
        print -r -- "  $mline"
      done <<< "$matches"
      print ""
    fi
  done

  if (( found_any == 0 )); then
    print -r -- "$(_zs_tr "No matches found for: $query" "Nenhum resultado encontrado para: $query")"
    return 1
  fi
  return 0
}

# Markdown Runbook Export (`zs export [id_or_file] [file.md]`)
_zs_export_session() {
  _zs_init_storage
  local arg1="$1"
  local arg2="$2"
  local target_sid=""
  local out_path=""

  if [[ -z "$arg1" ]]; then
    target_sid="$ZS_SESSION_ID"
    out_path="$PWD/session-${target_sid[1,8]}.md"
  elif target_sid=$(_zs_resolve_sid "$arg1" 0 2>/dev/null); then
    out_path="${arg2:-$PWD/session-${target_sid[1,8]}.md}"
  else
    target_sid="$ZS_SESSION_ID"
    out_path="$arg1"
  fi

  local log_file="$ZS_DATA_DIR/sessions/$target_sid.log"
  if [[ -z "$target_sid" || ! -f "$log_file" ]]; then
    if [[ "$target_sid" == "$ZS_SESSION_ID" ]]; then
      print -u2 "$(_zs_tr "Current session ($target_sid) has no recorded commands yet. Run commands first or pass a saved session ID/prefix (e.g., zs export 8cb4)." "A sessão atual ($target_sid) ainda não possui comandos gravados. Execute comandos antes ou informe o ID/prefixo de uma sessão salva (ex.: zs export 8cb4).")"
    else
      print -u2 "$(_zs_tr "Session log not found ($target_sid)." "Log da sessão não encontrado ($target_sid).")"
    fi
    return 1
  fi

  local s_date="" s_cat="$(_zs_default_category)" s_proj="$(_zs_detect_project)" s_dir="$PWD" s_cmds="0" s_title="Session $target_sid"
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title
    while IFS=$'\t' read -r r_sid r_c r_u r_cat r_proj r_dir r_cnt r_diff r_title; do
      if [[ "$r_sid" == "$target_sid" ]]; then
        s_date="$r_u"
        s_cat="$r_cat"
        s_proj="$r_proj"
        s_dir="$r_dir"
        s_cmds="$r_cnt"
        s_title="$r_title"
        break
      fi
    done < "$ZS_DATA_DIR/index.tsv"
  fi

  local md_content
  md_content=$(
    {
      print -r -- "# ${s_title}"
      print ""
      print -r -- "| Field | Value |"
      print -r -- "| :--- | :--- |"
      print -r -- "| **Session ID** | \`${target_sid}\` |"
      print -r -- "| **Date** | \`${s_date}\` |"
      print -r -- "| **Category** | \`${s_cat}\` |"
      print -r -- "| **Project** | \`${s_proj}\` |"
      print -r -- "| **Directory** | \`${s_dir}\` |"
      print -r -- "| **Commands** | \`${s_cmds}\` |"
      print ""
      print -r -- "## Timeline"
      print ""

      integer step_num=0
      local state="IDLE"
      local line ts_part rest_part cmd_part meta_part
      while IFS= read -r line; do
        if [[ "$line" == \[[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\]*" \$ "*" (exit: "* ]]; then
          if [[ "$state" == "OUT" || "$state" == "DIFF" ]]; then
            print -r -- '```'
            print ""
          fi
          (( ++step_num ))
          ts_part="${line#\[}"
          ts_part="${ts_part%%\]*}"
          cmd_part="${line#* \$ }"
          meta_part="${cmd_part##* \(exit: }"
          meta_part="exit: ${meta_part%\)}"
          cmd_part="${cmd_part% \(exit: *}"

          print -r -- "### Step ${step_num} (\`${ts_part}\` | \`${meta_part}\`)"
          print ""
          print -r -- '```zsh'
          print -r -- "$cmd_part"
          print -r -- '```'
          print ""
          state="IDLE"
        elif [[ "$line" == "  │ "* ]]; then
          if [[ "$state" == "DIFF" ]]; then
            print -r -- '```'
            print ""
          fi
          if [[ "$state" != "OUT" ]]; then
            print -r -- '```text'
            state="OUT"
          fi
          print -r -- "${line#  │ }"
        elif [[ "$line" == "  📝 Diff "* ]]; then
          if [[ "$state" == "OUT" || "$state" == "DIFF" ]]; then
            print -r -- '```'
            print ""
          fi
          print -r -- "**${line#  }**"
          print ""
          print -r -- '```diff'
          state="DIFF"
        elif [[ "$line" == "  🔒 "* ]]; then
          if [[ "$state" == "OUT" || "$state" == "DIFF" ]]; then
            print -r -- '```'
            print ""
          fi
          print -r -- "> ${line#  }"
          print ""
          state="IDLE"
        elif [[ "$state" == "DIFF" && "$line" == "    "* ]]; then
          print -r -- "${line#    }"
        elif [[ -z "$line" ]]; then
          if [[ "$state" == "OUT" || "$state" == "DIFF" ]]; then
            print -r -- '```'
            print ""
            state="IDLE"
          fi
        fi
      done < "$log_file"

      if [[ "$state" == "OUT" || "$state" == "DIFF" ]]; then
        print -r -- '```'
        print ""
      fi
    } | _zs_redact_text
  )

  if [[ "$out_path" == "-" ]]; then
    print -r -- "$md_content"
    return 0
  fi

  (
    umask 0077
    print -r -- "$md_content" > "$out_path"
  )
  print -r -- "$(_zs_tr "✓ Session exported to Markdown: $out_path" "✓ Sessão exportada para Markdown: $out_path")"
}

# ------------------------------------------------------------------------------
# 10. Interactive fzf TUI (Multi-platform ASCII shortcuts + Tab Action Menu)
# ------------------------------------------------------------------------------
_zs_format_index_for_fzf() {
  local filter_mode="${1:-ALL}"
  local filter_val="$2"
  [[ ! -f "$ZS_DATA_DIR/index.tsv" ]] && return 0

  command awk -F'\t' -v mode="$filter_mode" -v val="$filter_val" '
    {
      if ($7 + 0 <= 0) next;
      if (mode == "PROJECT" && $5 != val) next;
      if (mode == "CATEGORY") {
        if (val == "__UNCATEGORIZED__") {
          if ($4 != "Sem Categoria" && $4 != "Uncategorized" && $4 != "") next;
        } else if ($4 != val) {
          next;
        }
      }
      printf "%s\t%-16s  [%-14s]  %-14s  %-42s (%s cmds)\n", $1, $3, $4, $5, $9, $7
    }
  ' "$ZS_DATA_DIR/index.tsv" | command tail -r 2>/dev/null || command tac "$ZS_DATA_DIR/index.tsv" 2>/dev/null
}

_zs_action_menu_for_session() {
  local sid="$1"
  [[ -z "$sid" ]] && return 0
  local -a actions
  if _zs_is_pt; then
    actions=(
      "📜 Ver conversa completa (comandos, saídas e diffs)"
      "▶ Retomar esta sessão (cd + continuar conversa)"
      "📂 Mudar / Criar Categoria para esta sessão"
      "✏️  Renomear título da sessão"
      "🤖 Categorizar automaticamente (IA / Heurística)"
      "📄 Exportar sessão para Markdown (.md)"
      "🗑️  Excluir esta sessão"
    )
  else
    actions=(
      "📜 View full conversation (commands, outputs, and diffs)"
      "▶ Resume this session (cd + continue thread)"
      "📂 Change / Create Category for this session"
      "✏️  Rename session title"
      "🤖 Auto-categorize (AI / Heuristics)"
      "📄 Export session to Markdown (.md)"
      "🗑️  Delete this session"
    )
  fi
  local act=""
  if (( ${ZS_NO_FZF:-0} == 0 )) && command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
    act=$(printf "%s\n" "${actions[@]}" | command fzf --height=45% --reverse --prompt="$(_zs_tr "Action for [$sid] > " "Ação para [$sid] > ")")
  else
    printf "\n⚡ %s [%s]:\n" "$(_zs_tr "Choose an action for session" "Escolha uma ação para a sessão")" "$sid"
    integer idx=1
    local a
    for a in "${actions[@]}"; do
      printf "  [%d] %s\n" "$idx" "$a"
      (( ++idx ))
    done
    printf "%s [1-%d]: " "$(_zs_tr "Option" "Opção")" "${#actions[@]}"
    local num
    read -r num < /dev/tty
    if [[ "$num" == <-> ]] && (( num >= 1 && num <= ${#actions[@]} )); then
      act="${actions[$num]}"
    fi
  fi

  case "$act" in
    "📜 "*) _zs_show_session "$sid" ;;
    "▶ "*) _zs_resume_session "$sid" ;;
    "📂 "*) _zs_interactive_choose_category "$sid" 0 ;;
    "✏️ "*) _zs_rename_session "" "$sid" ;;
    "🤖 "*) _zs_ai_categorize "$sid" ;;
    "📄 "*) _zs_export_session "$sid" ;;
    "🗑️ "*) _zs_remove_session_files "$sid"; print -r -- "$(_zs_tr "🗑️  Session $sid deleted." "🗑️  Sessão $sid removida.")" ;;
  esac
}

_zs_open_tui() {
  _zs_init_storage
  if (( ${ZS_NO_FZF:-0} == 1 )) || ! command -v fzf >/dev/null 2>&1 || [[ ! -t 0 || ! -t 1 ]]; then
    local lines
    lines=$(_zs_format_index_for_fzf "ALL" "")
    if [[ -z "$lines" ]]; then
      print -r -- "$(_zs_tr "No saved sessions yet. Run commands in the terminal and type 'zs'!" "Nenhuma sessão salva ainda. Execute comandos no terminal e use 'zs'!")"
      return 0
    fi
    print -P "%B=== 💬 $(_zs_tr "Terminal Sessions (zsh-sessions)" "Sessões de Terminal (zsh-sessions)") ===%b"
    local -a row_list sids
    row_list=("${(@f)lines}")
    integer idx=1
    local r sid display
    for r in "${row_list[@]}"; do
      sid="${r%%$'\t'*}"
      display="${r#*$'\t'}"
      sids+=("$sid")
      printf "  [%d] %s\n" "$idx" "$display"
      (( ++idx ))
    done
    if [[ -o interactive && -r /dev/tty ]]; then
      printf "\n%s [1-%d] (%s): " "$(_zs_tr "Select session number" "Selecione o número da sessão")" "${#sids[@]}" "$(_zs_tr "or Enter to exit" "ou Enter para sair")"
      local sel
      read -r sel < /dev/tty
      if [[ "$sel" == <-> ]] && (( sel >= 1 && sel <= ${#sids[@]} )); then
        _zs_action_menu_for_session "${sids[$sel]}"
      fi
    fi
    return 0
  fi

  local filter_mode="ALL"
  local filter_val=""

  while true; do
    local lines
    lines=$(_zs_format_index_for_fzf "$filter_mode" "$filter_val")
    if [[ -z "$lines" ]]; then
      if [[ "$filter_mode" != "ALL" ]]; then
        print -r -- "$(_zs_tr "No sessions for filter [$filter_mode: $filter_val]. Returning to ALL..." "Nenhuma sessão para o filtro [$filter_mode: $filter_val]. Voltando para TODAS...")"
        filter_mode="ALL"
        filter_val=""
        continue
      fi
      print -r -- "$(_zs_tr "No saved sessions yet. Run commands in the terminal and type 'zs'!" "Nenhuma sessão salva ainda. Execute comandos no terminal e use 'zs'!")"
      return 0
    fi

    local header
    if _zs_is_pt; then
      header="Enter:Retomar | Tab:Ações | ^S:Buscar Logs | ^T:Categoria | ^R:Renomear | ^F:Filtrar | ^A:IA | ^X:Excluir | ^U/^D:Rolar"
    else
      header="Enter:Resume | Tab:Actions | ^S:Search Logs | ^T:Category | ^R:Rename | ^F:Filter | ^A:AI | ^X:Delete | ^U/^D:Scroll"
    fi
    local preview_cmd="zsh -c 'source \"${ZS_PLUGIN_DIR}/zsh-sessions.plugin.zsh\" >/dev/null 2>&1; ZS_DATA_DIR=\"${ZS_DATA_DIR}\" _zs_show_session {1}'"

    local out
    out=$(print -r -- "$lines" | command fzf \
      --ansi \
      --delimiter='\t' \
      --with-nth=2.. \
      --header="$header" \
      --prompt="💬 $(_zs_tr "Sessions" "Sessões") ($filter_mode) > " \
      --preview="$preview_cmd" \
      --preview-window="right:60%:wrap" \
      --expect="tab,ctrl-s,ctrl-t,ctrl-r,ctrl-f,ctrl-a,ctrl-x" \
      --bind="ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down")

    local exit_status=$?
    (( exit_status != 0 )) && break

    local key="${${(@f)out}[1]}"
    local selection="${${(@f)out}[2]}"
    local sid="${selection%%$'\t'*}"

    if [[ "$key" == "ctrl-s" ]]; then
      _zs_search_sessions
      break
    fi

    [[ -z "$sid" ]] && break

    case "$key" in
      "")
        _zs_resume_session "$sid"
        break
        ;;
      "tab")
        _zs_action_menu_for_session "$sid"
        break
        ;;
      "ctrl-t")
        _zs_interactive_choose_category "$sid" 0
        ;;
      "ctrl-r")
        _zs_rename_session "" "$sid"
        ;;
      "ctrl-a")
        _zs_ai_categorize "$sid"
        ;;
      "ctrl-x")
        _zs_remove_session_files "$sid"
        ;;
      "ctrl-f")
        if [[ "$filter_mode" == "ALL" ]]; then
          filter_mode="PROJECT"
          filter_val="$(_zs_detect_project)"
        elif [[ "$filter_mode" == "PROJECT" ]]; then
          local uncat_tag="[$(_zs_default_category)]"
          local chosen_cat
          chosen_cat=$( (print -r -- "$uncat_tag"; command cat "$ZS_DATA_DIR/categories.txt" 2>/dev/null) | command fzf --height=35% --reverse --prompt="$(_zs_tr "Filter by Category > " "Filtrar por Categoria > ")")
          if [[ "$chosen_cat" == "$uncat_tag" ]]; then
            filter_mode="CATEGORY"
            filter_val="__UNCATEGORIZED__"
          elif [[ -n "$chosen_cat" ]]; then
            filter_mode="CATEGORY"
            filter_val="$chosen_cat"
          else
            filter_mode="ALL"
            filter_val=""
          fi
        else
          filter_mode="ALL"
          filter_val=""
        fi
        ;;
    esac
  done
}

# ------------------------------------------------------------------------------
# 11. Complete Help Guide (-h / --help / help) — Bilingual EN / PT-BR
# ------------------------------------------------------------------------------
_zs_print_help() {
  if _zs_is_pt; then
    cat <<'EOF'
================================================================================
💬 zs (zsh-sessions) — Gerenciador de Sessões/Conversas de Terminal (Oh My Zsh)
================================================================================

USO:
  zs [comando] [argumentos]
  zs -h | --help | help

--------------------------------------------------------------------------------
1. COMANDOS PRINCIPAIS (aceitam UUIDv7 completo ou prefixo/sufixo curto)
--------------------------------------------------------------------------------
  zs                         Abre o painel interativo (tela dividida com fzf)
  zs -h, zs --help, zs help  Exibe este guia completo com todos os exemplos
  zs status                  Mostra os dados da sessão atual (UUIDv7, pasta,
                             categoria, título, quantidade de comandos e diffs)
  zs show [id_ou_prefixo]    Exibe a conversa completa (comandos, saídas e diffs
                             coloridos) da sessão atual ou do ID informado
  zs search [termo]          Busca um texto (IP, porta, comando, diff) dentro do
                             conteúdo de todas as sessões salvas
  zs export [id] [arq.md]    Exporta a sessão como Runbook em Markdown (.md)
  zs cap <comando...>        Executa qualquer comando gravando explicitamente sua
                             saída completa (stdout/stderr) + diffs na sessão
  zs resume <id_ou_prefixo>  Retoma uma sessão anterior (faz 'cd', injeta os
                             comandos na seta ↑ e continua gravando na thread)
  zs rename "<título>" [id]  Altera o título da sessão atual (ou do ID informado)
  zs rm <id_ou_prefixo>      Remove permanentemente uma sessão salva

--------------------------------------------------------------------------------
2. GESTÃO DE CATEGORIAS (100% Manual ou com IA)
--------------------------------------------------------------------------------
  zs cat                     Abre o menu interativo para classificar a sessão
                             atual em uma categoria existente ou criar uma nova
  zs cat add "<nome>"        Cria uma nova categoria (ex.: DevOps, Rede, Bugfix)
  zs cat list                Lista todas as categorias e quantas sessões há nelas
  zs cat set "<cat>" [id]    Atribui diretamente uma categoria à sessão atual
                             (ou à sessão do ID informado)
  zs ai [id_ou_prefixo]      Classifica e gera título automaticamente usando IA
                             (se GEMINI_API_KEY estiver definida) ou heurística

--------------------------------------------------------------------------------
3. ATALHOS DENTRO DO PAINEL INTERATIVO (fzf)
--------------------------------------------------------------------------------
  Enter       Retoma a sessão selecionada (entra na pasta e continua a conversa)
  Tab         Abre o Menu de Ações (Ver, Retomar, Categoria, Renomear, Exportar...)
  Ctrl + S    Busca Full-Text dentro dos logs e diffs de todas as sessões
  Ctrl + T    Mudar ou criar uma Categoria para a sessão selecionada
  Ctrl + R    Renomear o título da sessão selecionada
  Ctrl + F    Alternar filtro (Todas -> Projeto Atual -> Filtrar por Categoria)
  Ctrl + A    Classificar automaticamente com IA / Heurística
  Ctrl + X    Excluir a sessão selecionada
  Ctrl + U/D  Rolar a conversa (painel da direita) para cima / para baixo
  Esc / ^C    Sair do painel sem fazer alterações

--------------------------------------------------------------------------------
4. EXEMPLOS PRÁTICOS DO DIA A DIA
--------------------------------------------------------------------------------
  # Exemplo 1: Abrir o painel visual para procurar e retomar uma sessão antiga
  zs

  # Exemplo 2: Criar suas categorias de trabalho habituais
  zs cat add "Rede & Roteadores"
  zs cat add "DevOps & Docker"
  zs cat add "Backups"

  # Exemplo 3: Listar todas as suas categorias e ver sessões pendentes
  zs cat list

  # Exemplo 4: Classificar a sessão que você está usando agora
  zs cat
  # (ou diretamente):
  zs cat set "Rede & Roteadores"

  # Exemplo 5: Dar um nome fácil de lembrar para a sessão atual
  zs rename "Backup dos switches S6730 e roteador M4"

  # Exemplo 6: Ver todo o histórico ou buscar um IP/porta em sessões antigas
  zs show
  zs search "6380"

  # Exemplo 7: Exportar a sessão atual para documentação em Markdown
  zs export runbook-rede.md

  # Exemplo 8: Executar um comando sensível SEM gravar na sessão (espaço antes)
   export MINHA_SENHA="123"   # (com um espaço em branco no início da linha)

  # Exemplo 9: Capturar explicitamente a saída de qualquer comando ou script
  zs cap docker ps --format "table {{.Names}}\t{{.Status}}"

--------------------------------------------------------------------------------
5. VARIÁVEIS DE CONFIGURAÇÃO (no seu ~/.zshrc)
--------------------------------------------------------------------------------
  export ZS_LANG="pt"               # "pt" (Português) ou "en" (Inglês - auto por $LANG)
  export ZS_CAPTURE_OUTPUT=1        # 1 = ativa captura de saída; 0 = só comandos e diffs
  export ZS_CAPTURE_MODE="safe"     # "safe" = allowlist segura (nunca quebra TUIs/agy); "off" = desligado
  export ZS_SAFE_CAPTURE_CMDS=""    # Comandos extras para capturar saída no modo "safe"
  export ZS_MAX_OUTPUT_LINES=60     # Máximo de linhas de saída salvas por comando
  export ZS_MIN_MEANINGFUL_CMDS=2   # Mínimo de comandos relevantes (Regra Zero Lixo)
  export ZS_BINDKEY="^G"            # Atalho opcional (ex: Ctrl+G) para abrir o 'zs'
================================================================================
EOF
  else
    cat <<'EOF'
================================================================================
💬 zs (zsh-sessions) — Terminal Session Threads Manager (Oh My Zsh)
================================================================================

USAGE:
  zs [command] [arguments]
  zs -h | --help | help

--------------------------------------------------------------------------------
1. CORE COMMANDS (accept full UUIDv7 or short unique prefix/suffix)
--------------------------------------------------------------------------------
  zs                         Open the interactive split-view session TUI (fzf)
  zs -h, zs --help, zs help  Display this complete guide with practical examples
  zs status                  Display active session metadata (UUIDv7, directory,
                             category, title, command count, and diff status)
  zs show [id_or_prefix]     Display the full colorized timeline (commands,
                             outputs, and file diffs) of a session
  zs search [query]          Full-text search across all session logs and diffs
  zs export [id] [file.md]   Export a session as a clean Markdown (.md) runbook
  zs cap <command...>        Execute any command and explicitly record its full
                             stdout/stderr output and file diffs
  zs resume <id_or_prefix>   Resume a previous session ('cd' to its last folder,
                             inject commands into Up-Arrow history, and continue)
  zs rename "<title>" [id]   Set a custom title for the current or specified session
  zs rm <id_or_prefix>       Permanently delete a saved session

--------------------------------------------------------------------------------
2. CATEGORY MANAGEMENT (100% Manual or AI-Assisted)
--------------------------------------------------------------------------------
  zs cat                     Interactively classify the current session into an
                             existing category or create a new one
  zs cat add "<name>"        Create a new category (e.g., DevOps, Network, Bugfix)
  zs cat list                List all categories and session counts
  zs cat set "<cat>" [id]    Directly assign a category to a session
  zs ai [id_or_prefix]       Auto-categorize and title a session using AI
                             (if GEMINI_API_KEY is set) or local heuristics

--------------------------------------------------------------------------------
3. KEYBOARD SHORTCUTS INSIDE THE INTERACTIVE PANEL (fzf)
--------------------------------------------------------------------------------
  Enter       Resume selected session (cd into folder + continue thread)
  Tab         Open Action Menu (View, Resume, Category, Rename, Export, Delete)
  Ctrl + S    Full-text search across all session logs and file diffs
  Ctrl + T    Change or create a Category for the selected session
  Ctrl + R    Rename the selected session title
  Ctrl + F    Cycle filter (ALL -> Current Project -> By Category)
  Ctrl + A    Auto-categorize with AI / Heuristics
  Ctrl + X    Delete the selected session
  Ctrl + U/D  Scroll conversation preview up / down
  Esc / ^C    Exit panel without changes

--------------------------------------------------------------------------------
4. PRACTICAL EXAMPLES
--------------------------------------------------------------------------------
  # Example 1: Open the interactive TUI to browse and resume sessions
  zs

  # Example 2: Create your custom work categories
  zs cat add "Networks & Routers"
  zs cat add "DevOps & Docker"
  zs cat add "Backups"

  # Example 3: List all categories and check pending sessions
  zs cat list

  # Example 4: Categorize your current active session
  zs cat
  zs cat set "Networks & Routers"

  # Example 5: Give the current session a clear title
  zs rename "Backup S6730 switches and M4 router"

  # Example 6: View current session timeline or search across historical logs
  zs show
  zs search "6380"

  # Example 7: Export the current session to a Markdown runbook
  zs export network-runbook.md

  # Example 8: Run a sensitive command WITHOUT recording it (leading space)
   export MY_SECRET="123"

  # Example 9: Explicitly capture stdout/stderr of any command on demand
  zs cap docker ps --format "table {{.Names}}\t{{.Status}}"

--------------------------------------------------------------------------------
5. CONFIGURATION VARIABLES (in your ~/.zshrc)
--------------------------------------------------------------------------------
  export ZS_LANG="en"               # "en" (English) or "pt" (Portuguese - auto via $LANG)
  export ZS_CAPTURE_OUTPUT=1        # 1 = enable output capture; 0 = commands and diffs only
  export ZS_CAPTURE_MODE="safe"     # "safe" = allowlist (preserves native TTY for TUIs); "off" = disabled
  export ZS_SAFE_CAPTURE_CMDS=""    # Extra commands to auto-capture in "safe" mode
  export ZS_MAX_OUTPUT_LINES=60     # Max output lines stored per command
  export ZS_MIN_MEANINGFUL_CMDS=2   # Min meaningful commands required (Zero-Junk rule)
  export ZS_BINDKEY="^G"            # Optional ZLE shortcut (e.g., Ctrl+G) to launch 'zs'
================================================================================
EOF
  fi
}

# ------------------------------------------------------------------------------
# 12. Main CLI Dispatcher: `zs`
# ------------------------------------------------------------------------------
zs() {
  # Ensure TTY is restored and flush pending capture if pasted in a block
  _zs_restore_tty
  if [[ -n "$_ZS_ACTIVE_CMD" ]]; then
    _zs_precmd
  fi

  local subcmd="${1:-ui}"
  (( $# > 0 )) && shift

  # Support -h / --help anywhere as first arg to subcmd too
  if [[ "$subcmd" == "-h" || "$subcmd" == "--help" || "$subcmd" == "help" ]]; then
    _zs_print_help
    return 0
  fi

  case "$subcmd" in
    ui|list|ls)
      if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
        _zs_print_help
        return 0
      fi
      _zs_open_tui "$@"
      ;;
    cat|category)
      local action="${1:-choose}"
      if [[ "$action" == "-h" || "$action" == "--help" ]]; then
        _zs_print_help
        return 0
      fi
      (( $# > 0 )) && shift
      case "$action" in
        add)     _zs_cat_add "$@" ;;
        list|ls) _zs_cat_list ;;
        set)     _zs_cat_set "$@" ;;
        choose|*) _zs_interactive_choose_category "${1:-$ZS_SESSION_ID}" 0 ;;
      esac
      ;;
    rename|title)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_rename_session "$@"
      ;;
    resume|continue)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_resume_session "$@"
      ;;
    show|view)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_show_session "$@"
      ;;
    search|find|grep)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_search_sessions "$@"
      ;;
    export|md|runbook)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_export_session "$@"
      ;;
    cap|run)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_cap_command "$@"
      ;;
    ai|auto)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_ai_categorize "$@"
      ;;
    rm|delete)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      local target_rm
      if ! target_rm=$(_zs_resolve_sid "$1" 0); then
        return 1
      fi
      _zs_remove_session_files "$target_rm"
      print -r -- "$(_zs_tr "✓ Session removed: $target_rm" "✓ Sessão removida: $target_rm")"
      ;;
    status|info)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      if _zs_is_pt; then
        print -r -- "Sessão Atual (UUIDv7): $ZS_SESSION_ID"
        print -r -- "Projeto:               ${ZS_SESSION_PROJECT:-$(_zs_detect_project)}"
        print -r -- "Categoria:             ${ZS_SESSION_CATEGORY:-Sem Categoria}"
        print -r -- "Título:                ${ZS_SESSION_TITLE:-(automático)}"
        print -r -- "Comandos gravados:     $ZS_SESSION_CMD_COUNT ($ZS_SESSION_MEANINGFUL_COUNT relevantes)"
        print -r -- "Possui diffs:          $ZS_SESSION_HAS_DIFF"
      else
        print -r -- "Active Session (UUIDv7): $ZS_SESSION_ID"
        print -r -- "Project:                 ${ZS_SESSION_PROJECT:-$(_zs_detect_project)}"
        print -r -- "Category:                ${ZS_SESSION_CATEGORY:-Uncategorized}"
        print -r -- "Title:                   ${ZS_SESSION_TITLE:-(automatic)}"
        print -r -- "Recorded commands:       $ZS_SESSION_CMD_COUNT ($ZS_SESSION_MEANINGFUL_COUNT meaningful)"
        print -r -- "Has file diffs:          $ZS_SESSION_HAS_DIFF"
      fi
      ;;
    *)
      print -u2 "$(_zs_tr "Unknown subcommand: $subcmd (use 'zs -h' to view all commands and examples)" "Subcomando desconhecido: $subcmd (use 'zs -h' para ver todos os comandos e exemplos)")"
      return 1
      ;;
  esac
}

# ------------------------------------------------------------------------------
# 13. Hook Registration for Interactive Shells
# ------------------------------------------------------------------------------
if [[ -o interactive ]]; then
  _zs_init_storage
  [[ -z "$ZS_SESSION_ID" ]] && _zs_start_new_session

  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _zs_preexec
  add-zsh-hook zshexit _zs_on_zshexit

  # Register _zs_precmd at the VERY BEGINNING of precmd_functions so /dev/tty is
  # restored BEFORE Oh My Zsh's termsupport prints window title escape codes!
  typeset -ga precmd_functions
  precmd_functions=(_zs_precmd ${precmd_functions:#_zs_precmd})

  # Ensure Ctrl+C (SIGINT) always restores /dev/tty immediately
  TRAPINT() {
    _zs_restore_tty
    return $(( 128 + $1 ))
  }

  # Override exit to prompt for category when session is meaningful & uncategorized
  exit() {
    _zs_handle_shell_exit_prompt
    builtin exit "$@"
  }

  # Optional keybinding if configured by user (e.g., export ZS_BINDKEY="^G")
  if [[ -n "$ZS_BINDKEY" ]]; then
    _zs_zle_widget() {
      zle push-input
      BUFFER="zs"
      zle accept-line
    }
    zle -N _zs_zle_widget
    bindkey "$ZS_BINDKEY" _zs_zle_widget
  fi

  _zs_notify_pending_categories
fi
