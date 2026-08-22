# ai-session-search.plugin.zsh
# fzf-style fuzzy search over AI CLI session histories (Claude / Codex / Gemini).
#
# Install: source this file from ~/.zshrc, e.g.
#     source ~/plugins/ai-session-search/ai-session-search.plugin.zsh
# (oh-my-zsh: drop the folder in ~/.oh-my-zsh/custom/plugins/ and add
#  `ai-session-search` to your plugins=(...) array.)
#
# Default keybinding: Ctrl-X Ctrl-W   (does NOT clobber Ctrl-W / backward-kill-word)
# Change it by setting AISS_KEYBIND before sourcing, e.g. AISS_KEYBIND='^G'.
#
# In the picker:
#   - type to fuzzy-filter (the provider name is part of each row, so typing
#     "claude" / "codex" / "copilot" / "gemini" narrows to that tool)
#   - Enter     resume the selected session in its original directory
#   - Ctrl-O    open the raw .jsonl in $EDITOR
#   - Ctrl-/    toggle the preview pane
#   - Ctrl-R    rescan
#
# Override scan locations with AISS_CLAUDE_DIR / AISS_CODEX_DIR / AISS_GEMINI_DIR.

AISS_DIR=${0:A:h}
AISS_HELPER="$AISS_DIR/aiss-helper.zsh"

# Hard dependencies (fzf for the picker, jq for parsing the session files).
# Checked lazily so we don't nag on every shell startup: nothing is printed at
# load time, and the keybinding is still registered (so it works the moment the
# user installs the missing tool — no re-source needed). `${+commands[x]}` reads
# zsh's command hash table, so this never forks a subprocess.
_aiss_missing_deps() {
  local -a missing
  (( ${+commands[fzf]} )) || missing+=(fzf)
  (( ${+commands[jq]}  )) || missing+=(jq)
  (( ${#missing} )) || return 1
  print -u2 "ai-session-search: missing required command(s): ${missing[*]}." \
            "Install them first, e.g.:  brew install ${missing[*]}  (or your package manager)."
  return 0
}

# Core picker. Prints a ready-to-run resume command to stdout (does not run it),
# so it can drive both the ZLE widget and direct invocation.
_aiss_select() {
  emulate -L zsh
  setopt pipefail 2>/dev/null
  _aiss_missing_deps && return 1
  local sel
  sel=$(
    zsh "$AISS_HELPER" scan | fzf \
      --ansi \
      --delimiter=$'\t' --with-nth=1 --nth=1 \
      --no-sort \
      --height=90% --layout=reverse --border \
      --prompt='ai-sessions ❯ ' \
      --query="${1:-}" \
      --header='Enter: resume   Ctrl-O: open   Ctrl-/: preview   Ctrl-R: rescan' \
      --preview="zsh ${(q)AISS_HELPER} preview {2} {5}" \
      --preview-window='right:55%:wrap:border-left' \
      --bind='ctrl-/:toggle-preview' \
      --bind="ctrl-r:reload(zsh ${(q)AISS_HELPER} scan)" \
      --bind='ctrl-o:execute(${EDITOR:-vi} {5} < /dev/tty > /dev/tty)'
  ) || return 1
  [[ -z $sel ]] && return 1

  local -a F
  F=("${(@s:	:)sel}")        # split selected row on tabs
  local provider=$F[2] id=$F[3] cwd=$F[4] file=$F[5]
  [[ -z $id ]] && return 1
  # Resume must run in the session's ORIGINAL directory: claude --resume locates
  # the project by the current working directory. If that dir was deleted, recreate
  # it (empty) so the project lookup still matches; never silently fall back to $PWD.
  local cdpart
  if [[ -z $cwd ]]; then
    cdpart="cd ${(q)PWD}"
  elif [[ -d $cwd ]]; then
    cdpart="cd ${(q)cwd}"
  else
    cdpart="mkdir -p ${(q)cwd} && cd ${(q)cwd}"
  fi

  case $provider in
    claude) print -r -- "( $cdpart && claude --resume ${(q)id} )" ;;
    codex)
      # Pin the model the session was recorded with, so `codex resume` doesn't
      # warn about / silently switch to a different default model.
      local model=""
      [[ -r $file ]] && model=$(jq -rs 'first(.[] | .payload.model // empty) // empty' -- "$file" 2>/dev/null)
      print -r -- "( $cdpart && codex resume ${(q)id}${model:+ -m ${(q)model}} )"
      ;;
    copilot) print -r -- "( $cdpart && copilot --resume=${(q)id} )" ;;
    gemini) print -r -- "( $cdpart && gemini )  # gemini-cli has no resume-by-id; opens in dir" ;;
    *)      return 1 ;;
  esac
}

# Direct command: ai-sessions [initial-query]
ai-sessions() {
  local cmd
  cmd=$(_aiss_select "$@") || return 0
  print -r -- "$cmd"
  eval "$cmd"
}

# ZLE widget: pick, then drop the resume command on the command line and run it.
_aiss_widget() {
  local cmd
  cmd=$(_aiss_select) || { zle reset-prompt; return 0; }
  BUFFER=$cmd
  zle reset-prompt
  zle accept-line
}
zle -N _aiss_widget

# Bind only in interactive shells (the fzf preview child shell sources nothing,
# but guard anyway so non-interactive sourcing stays silent).
if [[ -o interactive ]]; then
  bindkey "${AISS_KEYBIND:-^X^W}" _aiss_widget
fi
