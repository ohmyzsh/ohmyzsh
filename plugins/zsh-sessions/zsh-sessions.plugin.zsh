#!/usr/bin/env zsh
# ==============================================================================
# zsh-sessions (zs) — Oh My Zsh Session Threads Plugin
# Conversational terminal sessions with UUIDv7, stdout/stderr capture,
# edited file diffs, secret redaction, manual/AI categories, and fzf TUI.
# ==============================================================================

0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"
typeset -g ZS_PLUGIN_DIR="${0:h}"

# Configuration defaults
typeset -g ZS_DATA_DIR="${ZS_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh-sessions}"
typeset -gi ZS_CAPTURE_OUTPUT="${ZS_CAPTURE_OUTPUT:-1}"
typeset -gi ZS_MAX_OUTPUT_LINES="${ZS_MAX_OUTPUT_LINES:-60}"
typeset -gi ZS_MIN_MEANINGFUL_CMDS="${ZS_MIN_MEANINGFUL_CMDS:-2}"

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

zmodload zsh/datetime 2>/dev/null
zmodload zsh/stat 2>/dev/null

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

# ------------------------------------------------------------------------------
# 1. Storage Initialization (0700 / 0600 permissions, zero-fork fast path)
# ------------------------------------------------------------------------------
_zs_init_storage() {
  if [[ ! -d "$ZS_DATA_DIR/sessions" ]]; then
    command mkdir -p -m 0700 "$ZS_DATA_DIR" "$ZS_DATA_DIR/sessions" 2>/dev/null
    command chmod 0700 "$ZS_DATA_DIR" "$ZS_DATA_DIR/sessions" 2>/dev/null
  fi
  if [[ ! -f "$ZS_DATA_DIR/categories.txt" ]]; then
    umask 0077
    : > "$ZS_DATA_DIR/categories.txt"
    command chmod 0600 "$ZS_DATA_DIR/categories.txt" 2>/dev/null
  fi
  if [[ ! -f "$ZS_DATA_DIR/index.tsv" ]]; then
    umask 0077
    : > "$ZS_DATA_DIR/index.tsv"
    command chmod 0600 "$ZS_DATA_DIR/index.tsv" 2>/dev/null
  fi
}

# ------------------------------------------------------------------------------
# 2. RFC 9562 UUIDv7 Generator (0-fork pure Zsh fast implementation)
# ------------------------------------------------------------------------------
_zs_uuidv7() {
  setopt LOCAL_OPTIONS NO_OCTAL_ZEROES
  local ts_sec="${EPOCHSECONDS:-0}"
  local ts_ms_part="000"
  if [[ -n "$EPOCHREALTIME" && "$EPOCHREALTIME" == *.* ]]; then
    local frac="${EPOCHREALTIME#*.}"
    ts_ms_part="${(r:3::0:)frac[1,3]}"
  fi
  integer total_ms=$(( ts_sec * 1000 + 10#$ts_ms_part ))
  integer hi32=$(( (total_ms >> 16) & 0xFFFFFFFF ))
  integer lo16=$(( total_ms & 0xFFFF ))

  local rand_hex
  rand_hex=$(printf "%04x%04x%04x%04x%04x" $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536)) $((RANDOM % 65536)))

  local ver_rand="${rand_hex[1,3]}"
  integer var_nibble=$(( (16#${rand_hex[4]} & 0x3) | 0x8 ))
  local var_hex=$(printf "%x" $var_nibble)
  local var_rand="${rand_hex[5,7]}"
  local node_rand="${rand_hex[8,19]}"

  printf "%08x-%04x-7%s-%s%s-%s\n" "$hi32" "$lo16" "$ver_rand" "$var_hex" "$var_rand" "$node_rand"
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
    vim|nvim|vi|nano|emacs|micro|less|more|man|htop|top|btop|glances|mtr|watch|tmux|screen|zellij|ssh|scp|sftp|ftp|mosh|telnet|nc|netcat|expect|fzf|zs|exit|logout|clear|reset|su|gpg|pass|claude|codex|lazygit|lazydocker|k9s|tig|ranger|mc|nnn|yazi)
      return 0
      ;;
  esac
  # Bypass scripts or compound commands that invoke interactive ssh/expect/telnet/sudo/read
  if [[ "$trimmed" == *(ssh|telnet|expect|ftp|sudo|vim|nano|fzf)* ]]; then
    return 0
  fi
  if [[ "$first_word" == (./*|*.sh) && -f "$first_word" ]]; then
    if command grep -Eq '\b(expect|ssh|telnet|sudo|read|fzf|vim|nano)\b' "$first_word" 2>/dev/null; then
      return 0
    fi
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
# 5. Session Metadata & Index Management
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
  local cat_val="${ZS_SESSION_CATEGORY:-Sem Categoria}"
  local proj_val="${ZS_SESSION_PROJECT:-$(_zs_detect_project)}"
  local title_val="${ZS_SESSION_TITLE:-Sessão em $proj_val}"
  cat_val="${cat_val//[$'\t\n']/ }"
  proj_val="${proj_val//[$'\t\n']/ }"
  title_val="${title_val//[$'\t\n']/ }"
  local dir_val="${PWD//[$'\t\n']/ }"

  local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
  umask 0077
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    command awk -F'\t' -v sid="$ZS_SESSION_ID" '$1 != sid { print $0 }' "$ZS_DATA_DIR/index.tsv" > "$tmp_idx" 2>/dev/null
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
    "$title_val" >> "$tmp_idx"
  command chmod 0600 "$tmp_idx" 2>/dev/null
  command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv"
}

_zs_remove_session_files() {
  local sid="$1"
  [[ -z "$sid" ]] && return 1
  command rm -f "$ZS_DATA_DIR/sessions/$sid.log" 2>/dev/null
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
    umask 0077
    command awk -F'\t' -v sid="$sid" '$1 != sid { print $0 }' "$ZS_DATA_DIR/index.tsv" > "$tmp_idx" 2>/dev/null
    command chmod 0600 "$tmp_idx" 2>/dev/null
    command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv"
  fi
}

# ------------------------------------------------------------------------------
# 6. Snapshot & Diff Engine for Edited Files (.yml, .json, .conf, etc.)
# ------------------------------------------------------------------------------
_zs_snapshot_files_before() {
  local cmd_str="$1"
  _ZS_TRACKED_FILES=()
  _ZS_SENSITIVE_TOUCHED=()
  _ZS_SNAP_DIR=""

  local -a tokens
  tokens=(${(z)cmd_str})
  local -A seen_paths
  local tok clean_tok resolved
  integer count=0

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
    seen_paths[$resolved]=1

    if [[ -f "$resolved" || "${tokens[1]}" == (vim|nvim|vi|nano|micro|touch|tee) || ( ! -d "$resolved" && -d "${resolved:h}" && "$clean_tok" == (*.*|*/*) ) ]]; then
      if [[ -z "$_ZS_SNAP_DIR" ]]; then
        _ZS_SNAP_DIR=$(command mktemp -d "${TMPDIR:-/tmp}/zs_snap.XXXXXX" 2>/dev/null)
        [[ -n "$_ZS_SNAP_DIR" ]] && command chmod 0700 "$_ZS_SNAP_DIR" 2>/dev/null
      fi
      [[ -z "$_ZS_SNAP_DIR" ]] && return 0

      if _zs_is_sensitive_file "$resolved"; then
        local mtime_before="0"
        if [[ -e "$resolved" ]]; then
          mtime_before=$(command stat -f "%m" "$resolved" 2>/dev/null || command stat -c "%Y" "$resolved" 2>/dev/null || print 1)
        fi
        _ZS_SENSITIVE_TOUCHED+=("${resolved}:::${mtime_before}")
        continue
      fi

      (( ++count ))
      (( count > 5 )) && break

      local snap_file="$_ZS_SNAP_DIR/snap_${count}"
      if [[ -f "$resolved" ]]; then
        local fsize=$(command wc -c < "$resolved" 2>/dev/null | command tr -d ' ')
        if [[ "${fsize:-0}" -lt 1048576 ]]; then
          command cp -p "$resolved" "$snap_file" 2>/dev/null
          _ZS_TRACKED_FILES+=("${resolved}:::EXISTS:::${snap_file}")
        fi
      else
        : > "$snap_file"
        _ZS_TRACKED_FILES+=("${resolved}:::NEW:::${snap_file}")
      fi
    fi
  done
}

_zs_collect_diffs_after() {
  local diff_output=""
  local entry filepath state snap_file rel_name raw_diff

  for entry in "${_ZS_SENSITIVE_TOUCHED[@]}"; do
    filepath="${entry%%:::*}"
    local old_mtime="${entry##*:::}"
    local new_mtime="0"
    if [[ -e "$filepath" ]]; then
      new_mtime=$(command stat -f "%m" "$filepath" 2>/dev/null || command stat -c "%Y" "$filepath" 2>/dev/null || print 1)
    fi
    if [[ "$old_mtime" != "$new_mtime" || ( "$old_mtime" == "0" && -e "$filepath" ) ]]; then
      rel_name="${filepath#$PWD/}"
      diff_output+="  🔒 [Arquivo sensível editado: ${rel_name} — diff omitido por segurança]"$'\n'
      ZS_SESSION_HAS_DIFF=1
    fi
  done

  for entry in "${_ZS_TRACKED_FILES[@]}"; do
    filepath="${entry%%:::*}"
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
          diff_output+="  📝 Diff em ${rel_name}:"$'\n'
          while IFS= read -r dline; do
            diff_output+="    ${dline}"$'\n'
          done <<< "$raw_diff"
        fi
      fi
    fi
  done

  if [[ -n "$_ZS_SNAP_DIR" && -d "$_ZS_SNAP_DIR" ]]; then
    command rm -rf "$_ZS_SNAP_DIR" 2>/dev/null
  fi
  _ZS_SNAP_DIR=""
  _ZS_TRACKED_FILES=()
  _ZS_SENSITIVE_TOUCHED=()

  print -rn -- "$diff_output"
}

# ------------------------------------------------------------------------------
# 7. Core Session Lifecycle & Hooks (preexec, precmd, zshexit)
# ------------------------------------------------------------------------------
_zs_start_new_session() {
  _zs_init_storage
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
        printf "  │ ... [%d linhas omitidas] ...\n" "$omitted"
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

  # 4. Capture stdout/stderr for non-interactive CLI commands while writing directly to /dev/tty
  if (( ZS_CAPTURE_OUTPUT == 1 )) && [[ -w /dev/tty ]] && ! _zs_is_interactive_tui "$cmd_str"; then
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

# ------------------------------------------------------------------------------
# 8. Manual Category Management & Closing Flow (exit / SIGHUP)
# ------------------------------------------------------------------------------
_zs_cat_add() {
  _zs_init_storage
  local cat_name="${1#"${1%%[![:space:]]*}"}"
  cat_name="${cat_name%"${cat_name##*[![:space:]]}"}"
  if [[ -z "$cat_name" || "$cat_name" == "-h" || "$cat_name" == "--help" ]]; then
    print -r -- "Uso: zs cat add \"<nome_da_categoria>\""
    print -r -- "Exemplo: zs cat add \"DevOps\""
    return 0
  fi
  if ! command grep -Fxq "$cat_name" "$ZS_DATA_DIR/categories.txt" 2>/dev/null; then
    print -r -- "$cat_name" >> "$ZS_DATA_DIR/categories.txt"
  fi
  print -r -- "Categoria criada/disponível: $cat_name"
}

_zs_cat_list() {
  _zs_init_storage
  print -r -- "📂 Categorias cadastradas:"
  if [[ ! -s "$ZS_DATA_DIR/categories.txt" ]]; then
    print -r -- "  (Nenhuma categoria criada ainda. Use: zs cat add <nome>)"
  else
    while IFS= read -r c; do
      [[ -z "$c" ]] && continue
      local cnt=0
      if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
        cnt=$(command awk -F'\t' -v cat="$c" '$7 + 0 > 0 && $4 == cat { n++ } END { print n+0 }' "$ZS_DATA_DIR/index.tsv")
      fi
      printf "  • %-22s (%d sessões)\n" "$c" "$cnt"
    done < "$ZS_DATA_DIR/categories.txt"
  fi
  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local uncat=$(command awk -F'\t' '$7 + 0 > 0 && $4 == "Sem Categoria" { n++ } END { print n+0 }' "$ZS_DATA_DIR/index.tsv")
    if (( uncat > 0 )); then
      printf "  • %-22s (%d sessões pendentes)\n" "[Sem Categoria]" "$uncat"
    fi
  fi
}

_zs_cat_set() {
  _zs_init_storage
  local cat_name="$1"
  local target_sid="${2:-$ZS_SESSION_ID}"
  if [[ -z "$cat_name" || -z "$target_sid" ]]; then
    print -u2 "Uso: zs cat set \"<categoria>\" [session_id]"
    return 1
  fi
  _zs_cat_add "$cat_name" >/dev/null

  if [[ "$target_sid" == "$ZS_SESSION_ID" ]]; then
    ZS_SESSION_CATEGORY="$cat_name"
    ZS_SESSION_MANUAL_META=1
    _zs_update_index
  elif [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
    umask 0077
    command awk -F'\t' -v OFS='\t' -v sid="$target_sid" -v cat="$cat_name" '
      $1 == sid { $4 = cat }
      { print $0 }
    ' "$ZS_DATA_DIR/index.tsv" > "$tmp_idx"
    command chmod 0600 "$tmp_idx" 2>/dev/null
    command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv"
  fi
  print -r -- "✓ Sessão [$target_sid] atribuída à categoria: $cat_name"
}

_zs_interactive_choose_category() {
  local target_sid="${1:-$ZS_SESSION_ID}"
  local on_exit_mode="${2:-0}"
  _zs_init_storage

  local -a options
  options=("[+] Criar nova categoria...")
  if [[ -s "$ZS_DATA_DIR/categories.txt" ]]; then
    while IFS= read -r c; do
      [[ -n "$c" ]] && options+=("📁 $c")
    done < "$ZS_DATA_DIR/categories.txt"
  fi
  if (( on_exit_mode == 1 )); then
    options+=("⏭️  Salvar sem categoria (classificar depois)")
    options+=("🗑️  Descartar esta sessão (não salvar)")
  fi

  local choice=""
  if (( ${ZS_NO_FZF:-0} == 0 )) && command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
    choice=$(printf "%s\n" "${options[@]}" | command fzf --height=40% --reverse --prompt="📂 Categoria da Sessão > " --header="Escolha uma categoria existente ou crie uma nova")
  else
    print -r -- "📂 Escolha uma categoria para a sessão ($ZS_SESSION_CMD_COUNT comandos):"
    integer i=1
    for opt in "${options[@]}"; do
      printf "  [%d] %s\n" "$i" "$opt"
      (( ++i ))
    done
    printf "Opção [1-%d]: " "${#options[@]}"
    local num
    read -r num
    if [[ "$num" == <-> ]] && (( num >= 1 && num <= ${#options[@]} )); then
      choice="${options[$num]}"
    fi
  fi

  case "$choice" in
    "[+] Criar nova categoria...")
      printf "Digite o nome da nova categoria: "
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
    "🗑️  Descartar esta sessão (não salvar)")
      _zs_remove_session_files "$target_sid"
      ZS_SESSION_ID=""
      print -r -- "🗑️  Sessão descartada."
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
  if [[ -z "$ZS_SESSION_CATEGORY" || "$ZS_SESSION_CATEGORY" == "Sem Categoria" ]]; then
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
    if [[ -n "$sid" && "$sid" != "$ZS_SESSION_ID" && "$cat" == "Sem Categoria" ]] && (( ${cnt:-0} > 0 )); then
      (( ++pending_cnt ))
    fi
  done < "$ZS_DATA_DIR/index.tsv"
  if (( pending_cnt > 0 )); then
    print -P "%F{yellow}💡 [zsh-sessions] Você tem ${pending_cnt} sessão(ões) anterior(es) sem categoria. Digite %Bzs cat%b ou %Bzs%b para classificar.%f"
  fi
}

# ------------------------------------------------------------------------------
# 9. Session Actions: Show, Rename, Resume, AI Categorize
# ------------------------------------------------------------------------------
_zs_show_session() {
  local sid="${1:-$ZS_SESSION_ID}"
  local log_file="$ZS_DATA_DIR/sessions/$sid.log"
  if [[ ! -f "$log_file" ]]; then
    print -r -- "Sessão não encontrada ou ainda sem comandos gravados ($sid)."
    return 1
  fi

  if [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local meta
    meta=$(command awk -F'\t' -v sid="$sid" '$1 == sid { printf "ID: %s | Data: %s | Categoria: [%s] | Projeto: %s | Cmds: %s\nTítulo: %s\nÚltima pasta: %s\n", $1, $3, $4, $5, $7, $9, $6 }' "$ZS_DATA_DIR/index.tsv")
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
  local target_sid="${2:-$ZS_SESSION_ID}"
  if [[ -z "$new_title" ]]; then
    printf "Novo título para a sessão [%s]: " "$target_sid"
    read -r new_title
  fi
  [[ -z "$new_title" ]] && return 1

  if [[ "$target_sid" == "$ZS_SESSION_ID" ]]; then
    ZS_SESSION_TITLE="$new_title"
    ZS_SESSION_MANUAL_META=1
    _zs_update_index
  elif [[ -f "$ZS_DATA_DIR/index.tsv" ]]; then
    local tmp_idx="$ZS_DATA_DIR/index.tsv.tmp.$$"
    umask 0077
    command awk -F'\t' -v OFS='\t' -v sid="$target_sid" -v t="$new_title" '
      $1 == sid { $9 = t }
      { print $0 }
    ' "$ZS_DATA_DIR/index.tsv" > "$tmp_idx"
    command chmod 0600 "$tmp_idx" 2>/dev/null
    command mv -f "$tmp_idx" "$ZS_DATA_DIR/index.tsv"
  fi
  print -r -- "✓ Título atualizado: $new_title"
}

_zs_resume_session() {
  local target_sid="$1"
  if [[ -z "$target_sid" || ! -f "$ZS_DATA_DIR/index.tsv" ]]; then
    print -u2 "Uso: zs resume <session_id>"
    return 1
  fi

  local row
  row=$(command awk -F'\t' -v sid="$target_sid" '$1 == sid { print $0 }' "$ZS_DATA_DIR/index.tsv")
  if [[ -z "$row" ]]; then
    print -u2 "Sessão $target_sid não encontrada."
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

  print -P "%F{green}▶ Retomando sessão:%f %B${ZS_SESSION_TITLE}%b [%F{cyan}${ZS_SESSION_CATEGORY}%f]"
  print -P "%F{242}ID: ${ZS_SESSION_ID} | Pasta: ${PWD/#$HOME/~}%f"
  local log_file="$ZS_DATA_DIR/sessions/$ZS_SESSION_ID.log"
  if [[ -f "$log_file" ]]; then
    print -P "%F{yellow}--- Últimos comandos desta conversa ---%f"
    command grep -E '^\[[0-9]{2}:[0-9]{2}:[0-9]{2}\]' "$log_file" | command tail -n 5
    print -P "%F{yellow}---------------------------------------%f"
  fi
}

_zs_ai_categorize() {
  local target_sid="${1:-$ZS_SESSION_ID}"
  local log_file="$ZS_DATA_DIR/sessions/$target_sid.log"
  if [[ ! -f "$log_file" ]]; then
    print -u2 "Log da sessão não encontrado para categorização."
    return 1
  fi

  local summary_cmds
  summary_cmds=$(command grep -E '^\[[0-9]{2}:[0-9]{2}:[0-9]{2}\]|^  📝 Diff' "$log_file" | command head -n 30 | _zs_redact_text)

  if [[ -n "$GEMINI_API_KEY" ]] && command -v curl >/dev/null 2>&1; then
    local existing_cats=$(command tr '\n' ',' < "$ZS_DATA_DIR/categories.txt" 2>/dev/null)
    local prompt="Com base nestes comandos de terminal (já sanitizados), responda APENAS no formato CATEGORIA|TITULO_CURTO (máx 50 chars). Categorias existentes: ${existing_cats}. Comandos: ${summary_cmds}"
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
      print -r -- "🤖 [IA] Categoria: [$ai_cat] | Título: $ai_title"
      return 0
    fi
  fi

  local auto_cat="Terminal"
  if print -r -- "$summary_cmds" | command grep -Eq 'docker|kubectl|helm|terraform|systemctl|nginx'; then
    auto_cat="DevOps"
  elif print -r -- "$summary_cmds" | command grep -Eq 'git (commit|rebase|merge|push|pull|checkout|branch)'; then
    auto_cat="Git"
  elif print -r -- "$summary_cmds" | command grep -Eq 'pytest|jest|cargo test|go test|npm test|mvn test|gradle test'; then
    auto_cat="Testes"
  elif print -r -- "$summary_cmds" | command grep -Eq 'psql|mysql|redis-cli|mongosh|sqlite3|flyway'; then
    auto_cat="Database"
  elif print -r -- "$summary_cmds" | command grep -Eq '📝 Diff'; then
    auto_cat="Config"
  fi
  _zs_cat_set "$auto_cat" "$target_sid" >/dev/null
  print -r -- "🤖 [Auto] Sessão classificada em: [$auto_cat]"
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
      if (mode == "CATEGORY" && $4 != val) next;
      printf "%s\t%-16s  [%-14s]  %-14s  %-42s (%s cmds)\n", $1, $3, $4, $5, $9, $7
    }
  ' "$ZS_DATA_DIR/index.tsv" | command tail -r 2>/dev/null || command tac "$ZS_DATA_DIR/index.tsv" 2>/dev/null
}

_zs_action_menu_for_session() {
  local sid="$1"
  [[ -z "$sid" ]] && return 0
  local -a actions
  actions=(
    "📜 Ver conversa completa (comandos, saídas e diffs)"
    "▶ Retomar esta sessão (cd + continuar conversa)"
    "📂 Mudar / Criar Categoria para esta sessão"
    "✏️  Renomear título da sessão"
    "🤖 Categorizar automaticamente (IA / Heurística)"
    "🗑️  Excluir esta sessão"
  )
  local act=""
  if (( ${ZS_NO_FZF:-0} == 0 )) && command -v fzf >/dev/null 2>&1 && [[ -t 0 && -t 1 ]]; then
    act=$(printf "%s\n" "${actions[@]}" | command fzf --height=40% --reverse --prompt="Ação para [$sid] > ")
  else
    printf "\n⚡ Escolha uma ação para a sessão [%s]:\n" "$sid"
    integer idx=1
    for a in "${actions[@]}"; do
      printf "  [%d] %s\n" "$idx" "$a"
      (( ++idx ))
    done
    printf "Opção [1-%d]: " "${#actions[@]}"
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
    "🗑️ "*) _zs_remove_session_files "$sid"; print -r -- "🗑️  Sessão $sid removida." ;;
  esac
}

_zs_open_tui() {
  _zs_init_storage
  if (( ${ZS_NO_FZF:-0} == 1 )) || ! command -v fzf >/dev/null 2>&1 || [[ ! -t 0 || ! -t 1 ]]; then
    local lines
    lines=$(_zs_format_index_for_fzf "ALL" "")
    if [[ -z "$lines" ]]; then
      print -r -- "Nenhuma sessão salva ainda. Execute comandos no terminal e use 'zs'!"
      return 0
    fi
    print -P "%B=== 💬 Sessões de Terminal (zsh-sessions) ===%b"
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
      printf "\nSelecione o número da sessão [1-%d] (ou Enter para sair): " "${#sids[@]}"
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
        print -r -- "Nenhuma sessão para o filtro [$filter_mode: $filter_val]. Voltando para TODAS..."
        filter_mode="ALL"
        filter_val=""
        continue
      fi
      print -r -- "Nenhuma sessão salva ainda. Execute comandos no terminal e use 'zs'!"
      return 0
    fi

    local header="Enter:Retomar | Tab:Menu Ações | ^T:Categoria | ^R:Renomear | ^F:Filtrar | ^A:IA | ^X:Excluir | ^U/^D:Rolar"
    local preview_cmd="zsh -c 'source \"${ZS_PLUGIN_DIR}/zsh-sessions.plugin.zsh\" >/dev/null 2>&1; ZS_DATA_DIR=\"${ZS_DATA_DIR}\" _zs_show_session {1}'"

    local out
    out=$(print -r -- "$lines" | command fzf \
      --ansi \
      --delimiter='\t' \
      --with-nth=2.. \
      --header="$header" \
      --prompt="💬 Sessões ($filter_mode) > " \
      --preview="$preview_cmd" \
      --preview-window="right:60%:wrap" \
      --expect="tab,ctrl-t,ctrl-r,ctrl-f,ctrl-a,ctrl-x" \
      --bind="ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down")

    local exit_status=$?
    (( exit_status != 0 )) && break

    local key="${${(@f)out}[1]}"
    local selection="${${(@f)out}[2]}"
    local sid="${selection%%$'\t'*}"
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
          local chosen_cat
          chosen_cat=$( (print "[Sem Categoria]"; command cat "$ZS_DATA_DIR/categories.txt" 2>/dev/null) | command fzf --height=35% --reverse --prompt="Filtrar por Categoria > ")
          if [[ "$chosen_cat" == "[Sem Categoria]" ]]; then
            filter_mode="CATEGORY"
            filter_val="Sem Categoria"
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
# 11. Complete Help Guide (-h / --help / help)
# ------------------------------------------------------------------------------
_zs_print_help() {
  cat <<'EOF'
================================================================================
💬 zs (zsh-sessions) — Gerenciador de Sessões/Conversas de Terminal (Oh My Zsh)
================================================================================

USO:
  zs [comando] [argumentos]
  zs -h | --help | help

--------------------------------------------------------------------------------
1. COMANDOS PRINCIPAIS
--------------------------------------------------------------------------------
  zs                         Abre o painel interativo (tela dividida com fzf)
  zs -h, zs --help, zs help  Exibe este guia completo com todos os exemplos
  zs status                  Mostra os dados da sessão atual (UUIDv7, pasta,
                             categoria, título, quantidade de comandos e diffs)
  zs show [session_id]       Exibe a conversa completa (comandos, saídas e diffs
                             coloridos) da sessão atual ou do ID informado
  zs resume <session_id>     Retoma uma sessão anterior (faz 'cd' para a última
                             pasta da sessão e continua gravando na mesma thread)
  zs rename "<título>" [id]  Altera o título da sessão atual (ou do ID informado)
  zs rm <session_id>         Remove permanentemente uma sessão salva

--------------------------------------------------------------------------------
2. GESTÃO DE CATEGORIAS (100% Manual ou com IA)
--------------------------------------------------------------------------------
  zs cat                     Abre o menu interativo para classificar a sessão
                             atual em uma categoria existente ou criar uma nova
  zs cat add "<nome>"        Cria uma nova categoria (ex.: DevOps, Rede, Bugfix)
  zs cat list                Lista todas as categorias e quantas sessões há nelas
  zs cat set "<cat>" [id]    Atribui diretamente uma categoria à sessão atual
                             (ou à sessão do ID informado)
  zs ai [session_id]         Classifica e gera título automaticamente usando IA
                             (se GEMINI_API_KEY estiver definida) ou heurística

--------------------------------------------------------------------------------
3. ATALHOS DENTRO DO PAINEL INTERATIVO (fzf)
--------------------------------------------------------------------------------
  Enter       Retoma a sessão selecionada (entra na pasta e continua a conversa)
  Tab         Abre o Menu de Ações (Ver, Retomar, Categoria, Renomear, IA, Excluir)
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

  # Exemplo 6: Ver todo o histórico (comandos, saídas e diffs .yml) da aba atual
  zs show

  # Exemplo 7: Pedir para a IA categorizar e dar título para a sessão atual
  zs ai

  # Exemplo 8: Executar um comando sensível SEM gravar na sessão (espaço antes)
   export MINHA_SENHA="123"   # (com um espaço em branco no início da linha)

--------------------------------------------------------------------------------
5. VARIÁVEIS DE CONFIGURAÇÃO (no seu ~/.zshrc)
--------------------------------------------------------------------------------
  export ZS_CAPTURE_OUTPUT=1        # 1 = grava saídas stdout/stderr; 0 = só comandos e diffs
  export ZS_MAX_OUTPUT_LINES=60     # Máximo de linhas de saída salvas por comando
  export ZS_MIN_MEANINGFUL_CMDS=2   # Mínimo de comandos relevantes (Regra Zero Lixo)
  export ZS_BINDKEY="^G"            # Atalho opcional (ex: Ctrl+G) para abrir o 'zs'
================================================================================
EOF
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
    ai|auto)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_ai_categorize "$@"
      ;;
    rm|delete)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      _zs_remove_session_files "$1"
      print -r -- "✓ Sessão removida: $1"
      ;;
    status|info)
      [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { _zs_print_help; return 0; }
      print -r -- "Sessão Atual (UUIDv7): $ZS_SESSION_ID"
      print -r -- "Projeto:               ${ZS_SESSION_PROJECT:-$(_zs_detect_project)}"
      print -r -- "Categoria:             ${ZS_SESSION_CATEGORY:-Sem Categoria}"
      print -r -- "Título:                ${ZS_SESSION_TITLE:-(automático)}"
      print -r -- "Comandos gravados:     $ZS_SESSION_CMD_COUNT ($ZS_SESSION_MEANINGFUL_COUNT relevantes)"
      print -r -- "Possui diffs:          $ZS_SESSION_HAS_DIFF"
      ;;
    *)
      print -u2 "Subcomando desconhecido: $subcmd (use 'zs -h' para ver todos os comandos e exemplos)"
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
