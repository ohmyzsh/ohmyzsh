# lib/pattern.zsh - Search pattern builders for different pagers
# Generates regex patterns for option search in man pages

# Build search pattern for less pager (ERE - Extended Regular Expressions)
# Patterns match option definitions: lines starting with whitespace then dash
# Supports comma-separated (GNU style) and slash-separated (jq style) options
# Input: $1 = word (the option, e.g., "-l", "--recursive", "-rf")
# Output: ERE pattern string
zvm_build_less_pattern() {
  local word="$1"
  local pattern=""

  if [[ -z "$word" ]]; then
    echo ""
    return
  fi

  # Long option with value: --color=always -> search for --color
  # Use -[^[:space:],/]* instead of -.* to prevent matching across descriptions
  # Use (-[^[:space:],/]*[,/][[:space:]]+)* to allow multiple preceding options
  if [[ "$word" =~ ^--[^=]+= ]]; then
    local opt="${word%%=*}"
    pattern="^[[:space:]]*${opt}([,/=:[[:space:]]|$)|^[[:space:]]*(-[^[:space:],/]*[,/][[:space:]]+)+${opt}([,/=:[[:space:]]|$)"

  # Combined short options: -rf -> search for -[rf] to find individual options
  # Also includes fallback for single-dash long options like find's -name, -type
  # Use (-[^[:space:],/]*[,/][[:space:]]+)+ to allow multiple preceding options
  elif [[ "$word" =~ ^-[a-zA-Z]{2,}$ ]]; then
    local chars="${word:1}"
    # Pattern 1: individual chars (e.g., -r or -f from -rf)
    # Pattern 2: the full word as-is (e.g., -name for find)
    pattern="^[[:space:]]*-[${chars}][,/:[:space:]]|^[[:space:]]*(-[^[:space:],/]*[,/][[:space:]]+)+-[${chars}][,/:[:space:]]|^[[:space:]]*${word}([,/:[:space:]]|$)|^[[:space:]]*(-[^[:space:],/]*[,/][[:space:]]+)+${word}([,/:[:space:]]|$)"

  # Single short option: -r -> match at start of option definition line
  # Use (-[^[:space:],/]*[,/][[:space:]]+)+ to allow multiple preceding options
  elif [[ "$word" =~ ^-[a-zA-Z]$ ]]; then
    pattern="^[[:space:]]*${word}[,/:[:space:]]|^[[:space:]]*(-[^[:space:],/]*[,/][[:space:]]+)+${word}([,/:[:space:]]|$)"

  # Long option without value: --recursive
  # Use (-[^[:space:],/]*[,/][[:space:]]+)+ to allow multiple preceding options
  elif [[ "$word" =~ ^-- ]]; then
    pattern="^[[:space:]]*${word}([,/=:[[:space:]]|$)|^[[:space:]]*(-[^[:space:],/]*[,/][[:space:]]+)+${word}([,/=:[[:space:]]|$)"
  fi

  echo "$pattern"
}

# Build search pattern for vim/neovim (Vim regex syntax)
# Matches option definitions: lines starting with whitespace then dash
# Supports comma-separated (GNU style) and slash-separated (jq style) options
# Uses word boundaries to prevent partial matches (e.g., --slurp vs --slurpfile)
# Input: $1 = word (the option, e.g., "-l", "--recursive", "-rf")
# Output: Vim search pattern string
zvm_build_nvim_pattern() {
  local word="$1"
  local search_term=""

  if [[ -z "$word" ]]; then
    echo ""
    return
  fi

  # Long option with value: --color=always -> search for --color
  # Match: at line start OR after comma/slash separator
  # End: followed by delimiter (comma, slash, equals, colon, space) or EOL
  # Use \(-[^[:space:],/]*[,/][[:space:]]*\)\+ to allow multiple preceding options
  if [[ "$word" =~ ^--[^=]+= ]]; then
    local opt="${word%%=*}"
    search_term="^[[:space:]]*${opt}\\([,/=:[[:space:]]\\|$\\)\\|^[[:space:]]*\\(-[^[:space:],/]*[,/][[:space:]]*\\)\\+${opt}\\([,/=:[[:space:]]\\|$\\)"

  # Combined short options: -la -> search for -l or -a
  # Also includes the full word as fallback for find-style -name, -type
  # Use \(-[^[:space:],/]*[,/][[:space:]]*\)\+ to allow multiple preceding options
  elif [[ "$word" =~ ^-[a-zA-Z]{2,}$ ]]; then
    local chars="${word:1}"
    local alternation=""
    # Pattern for individual chars (e.g., -r or -f from -rf)
    for (( i=0; i<${#chars}; i++ )); do
      local char="-${chars:$i:1}"
      if [[ -n "$alternation" ]]; then
        alternation="${alternation}\\|^[[:space:]]*${char}[,/:[:space:]]\\|^[[:space:]]*\\(-[^[:space:],/]*[,/][[:space:]]*\\)\\+${char}\\([,/:[:space:]]\\|$\\)"
      else
        alternation="^[[:space:]]*${char}[,/:[:space:]]\\|^[[:space:]]*\\(-[^[:space:],/]*[,/][[:space:]]*\\)\\+${char}\\([,/:[:space:]]\\|$\\)"
      fi
    done
    # Add full word as fallback (for find-style -name, -exec, etc.)
    alternation="${alternation}\\|^[[:space:]]*${word}\\([,/:[:space:]]\\|$\\)\\|^[[:space:]]*\\(-[^[:space:],/]*[,/][[:space:]]*\\)\\+${word}\\([,/:[:space:]]\\|$\\)"
    search_term="${alternation}"

  # Single short option: -r
  # Match: at line start OR after comma/slash separator
  # End: followed by delimiter or EOL
  # Use \(-[^[:space:],/]*[,/][[:space:]]*\)\+ to allow multiple preceding options
  elif [[ "$word" =~ ^-[a-zA-Z]$ ]]; then
    search_term="^[[:space:]]*${word}[,/:[:space:]]\\|^[[:space:]]*\\(-[^[:space:],/]*[,/][[:space:]]*\\)\\+${word}\\([,/:[:space:]]\\|$\\)"

  # Long option without value: --recursive
  # Match: at line start OR after comma/slash separator
  # End: followed by delimiter or EOL (prevents --slurp matching --slurpfile)
  # Use \(-[^[:space:],/]*[,/][[:space:]]*\)\+ to allow multiple preceding options
  elif [[ "$word" =~ ^-- ]]; then
    search_term="^[[:space:]]*${word}\\([,/=:[[:space:]]\\|$\\)\\|^[[:space:]]*\\(-[^[:space:],/]*[,/][[:space:]]*\\)\\+${word}\\([,/=:[[:space:]]\\|$\\)"
  fi

  echo "$search_term"
}

