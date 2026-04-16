## Settings

# Filename of the dotenv file to look for
: ${ZSH_DOTENV_FILE:=.env}

# Path to the file containing allowed paths
: ${ZSH_DOTENV_ALLOWED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/dotenv-allowed.list"}
: ${ZSH_DOTENV_DISALLOWED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/dotenv-disallowed.list"}

## Functions

_parse_dotenv_content() {
  setopt localoptions extendedglob

  local content="$1"
  local mode="${2:-export}"

  # Validate mode argument
  case "$mode" in
    export|test) ;;
    *)
      echo "parse_dotenv: invalid mode '$mode' (use 'export' or 'test')" >&2
      return 1
      ;;
  esac

  local node line key value
  local raw_value expanded prefix remainder var_name escaped_dollar_placeholder
  local sq dq uq safe
  local -A parsed_vars
  local -a nodes lines

  # Parse into command lines separated by `;`, with built-in support for multi-line commands.
  # (Z:C:) ignores comments and preserves quotes and escapes.
  #
  # All logical commands are separated by literal ';' elements, which allows us to reconstruct logical lines
  # by joining all elements between ';'.
  #
  # Example input:
  #   VAR1=value1; VAR2=value2
  #   VAR3="multi
  #   line value"
  # Result:
  #   typeset -a nodes=( 'VAR1=value1' ';' 'VAR2=value2' ';' $'VAR3="multi\nline value"' )
  #   typeset -a lines=( 'VAR1=value1' 'VAR2=value2' $'VAR3="multi\nline value"' )
  #
  nodes=("${(@Z:C:)content}" ";") # last ';' ensures we add the final command
  for node in "${nodes[@]}"; do
    if [[ "$node" == ";" ]]; then
      if [[ -n "$line" ]]; then
        lines+=("$line")
        line=""
      fi
      continue
    fi

    [[ -z "$line" ]] || line+=" "
    line="$node"
  done

  local -a forbidden_vars=(
    NODE_OPTIONS
    BASH_ENV
    ENV
    ZDOTDIR
    ZSH
    LD_PRELOAD
    LD_LIBRARY_PATH
    DYLD_INSERT_LIBRARIES
    GIT_CONFIG_GLOBAL
    GIT_DIR
    GIT_EDITOR
    GIT_EXTERNAL_DIFF
    GIT_EXEC_PATH
    GIT_PAGER
    GIT_SSH
    GIT_SSH_COMMAND
    GIT_SSL_NO_VERIFY
    GIT_TEMPLATE_DIR
    VISUAL
    PAGER
    EDITOR
    ${(k)parameters[(R)*export*special]}
  )
  local forbidden="${(j:|:)forbidden_vars}"


  # Each line contains a single command line, we need to parse valid KEY=VALUE pairs
  for line in "${lines[@]}"; do
    # Strip leading 'export ' keyword
    line="${line#export[ 	]}"

    # Match KEY=VALUE pattern
    # "A name may be any sequence of alphanumeric characters and underscores"
    # https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters
    if [[ ! "$line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)=(.*)$ ]]; then
      continue
    fi

    key="${match[1]}"
    value="${match[2]}"
    raw_value="$value"

    # Filter out variables to be ignored for security reasons (best effort)
    if [[ "$key" == (${~forbidden}) ]]; then
      continue
    fi

    # Use tokenization to split value with native shell parsing (handles quotes and escapes)
    # Ignore any values that parse to multiple words, e.g. `BASE_URL=/ echo command run`
    local -a words
    words=("${(@z)value}")
    if [[ ${#words} -ne 1 ]]; then
      continue
    fi

    ## START: FILTER COMMAND EXPANSION
    #
    # Filter lines with command expansion not in safe contexts
    #
    # READER'S NOTE: this is actually a "best effort" check (works in tests), but
    # only to prevent setting variables with command substitution. The actual effect
    # of setting them would not be a vulnerability, because we use `typeset name=value`
    # and value is a quoted string parsed by zsh itself with `${(Z:C:)content}`.
    #
    # What does this mean? If we were to remove this filter block, this is what would happen:
    #
    # Input: DANGEROUS=$(echo this is a command)
    # Output: DANGEROUS='$(echo this is a command)' (literal string, no command execution)
    #
    # Check for potential command substitution outside of safe contexts
    # - single-quoted strings: command substitution is literal there
    sq="'[^']#'"
    # - double-quoted strings, but NOT unescaped ` or $(
    dq='"([^"$`\\]|\\.|\\$[^(\`])#"'
    # - unquoted text, but NOT unescaped ` or $(
    uq='([^$`'"'"'"\\]|\\.|\\$[^(\`])#'
    safe="(${sq}|${dq}|${uq})#"
    # Remove the longest safe prefix; what remains starts at first unsafe construct
    remainder="${value##${~safe}}"

    if [[ "$remainder" == *'$('* || "$remainder" == *'`'* ]]; then
      continue
    fi
    ## END: FILTER COMMAND EXPANSION

    # Single-quoted values are fully literal and must not participate in expansion.
    if [[ "$raw_value" == \'*\' ]]; then
      value="${(Q)value}"
      parsed_vars[$key]="$value"
      if [[ "$mode" == "export" ]]; then
        typeset -x "$key"="$value"
      fi
      continue
    fi

    # Preserve escaped dollars so they remain literal after unquoting.
    escaped_dollar_placeholder=$'\001DOTENV_ESCAPED_DOLLAR\001'
    value="${value//\\\$/$escaped_dollar_placeholder}"

    # Unquote the value to handle special characters and multiline values.
    value="${(Q)value}"

    # Expand previously parsed in-file variables without partial name matches.
    expanded=""
    prefix=""
    remainder="$value"
    var_name=""
    while [[ "$remainder" == *'$'* ]]; do
      prefix="${remainder%%\$*}"
      expanded+="$prefix"
      remainder="${remainder#$prefix}"

      if [[ "$remainder" =~ '^\$\{([a-zA-Z_][a-zA-Z0-9_]*)\}(.*)$' ]]; then
        var_name="${match[1]}"
        remainder="${match[2]}"
      elif [[ "$remainder" =~ '^\$([a-zA-Z_][a-zA-Z0-9_]*)(.*)$' ]]; then
        var_name="${match[1]}"
        remainder="${match[2]}"
      else
        expanded+='$'
        remainder="${remainder#?}"
        continue
      fi

      if [[ -v "parsed_vars[$var_name]" ]]; then
        expanded+="${parsed_vars[$var_name]}"
      fi
    done
    value="${expanded}${remainder}"
    value="${value//$escaped_dollar_placeholder/\$}"

    # Store in parsed vars (for in-file expansion)
    parsed_vars[$key]="$value"

    # Normal mode: export the variable
    if [[ "$mode" == "export" ]]; then
      typeset -x "$key"="$value"
    fi
  done

  # In test mode, set DOTENV_TEST_VARS
  typeset -gA DOTENV_TEST_VARS
  DOTENV_TEST_VARS=("${(@kv)parsed_vars}")
}

parse_dotenv() {
  local filename="$1"
  local mode="${2:-export}"
  local content

  # Fail if file is too large to avoid DoS
  zmodload -F zsh/stat b:zstat
  local -i file_size max_size=10485760  # 10MiB
  if ! file_size=$(zstat +size "$filename" 2>/dev/null); then
    echo "dotenv: unable to determine size of file '$filename'" >&2
    return 1
  fi

  if (( file_size > max_size )); then
    echo "dotenv: file '$filename' is too large to parse (size: $file_size bytes)" >&2
    return 1
  fi

  content="$(<"$filename")" || return 1
  _parse_dotenv_content "$content" "$mode"
}

_dotenv_read_limited() {
  local filename="$1"
  local chunk content=""
  local -i max_size=10485760 total=0 read_size=0 fd read_status

  zmodload zsh/system || return 1
  exec {fd}<"$filename" || return 1

  while true; do
    sysread -i $fd -s 65536 -c read_size chunk
    read_status=$?

    if (( read_status == 5 )); then
      break
    elif (( read_status != 0 )); then
      exec {fd}<&-
      return 1
    fi

    (( total += read_size ))
    if (( total > max_size )); then
      exec {fd}<&-
      echo "dotenv: file '$filename' is too large to parse (size: more than $max_size bytes)" >&2
      return 1
    fi

    content+="$chunk"
  done

  exec {fd}<&-
  REPLY="$content"
}

_dotenv_check_syntax() {
  local filename="$1"

  if (( $# == 2 )); then
    printf '%s' "$2" | zsh -fn /dev/stdin
  else
    zsh -fn -- "$filename"
  fi || {
    echo "dotenv: error when sourcing '$filename' file" >&2
    return 1
  }
}

source_env() {
  if [[ ! -f "$ZSH_DOTENV_FILE" ]] && [[ ! -p "$ZSH_DOTENV_FILE" ]]; then
    return
  fi

  if [[ "$ZSH_DOTENV_PROMPT" != false ]]; then
    local confirmation dirpath="${PWD:A}"

    # make sure there is an (dis-)allowed file
    touch "$ZSH_DOTENV_ALLOWED_LIST"
    touch "$ZSH_DOTENV_DISALLOWED_LIST"

    # early return if disallowed
    if command grep -Fx -q "$dirpath" "$ZSH_DOTENV_DISALLOWED_LIST" &>/dev/null; then
      return
    fi

    # check if current directory's .env file is allowed or ask for confirmation
    if ! command grep -Fx -q "$dirpath" "$ZSH_DOTENV_ALLOWED_LIST" &>/dev/null; then
      # get cursor column and print new line before prompt if not at line beginning
      local column
      echo -ne "\e[6n" > /dev/tty
      read -t 1 -s -d R column < /dev/tty
      column="${column##*\[*;}"
      [[ $column -eq 1 ]] || echo

      # print same-line prompt and output newline character if necessary
      echo -n "dotenv: found '$ZSH_DOTENV_FILE' file. Source it? ([y]es/[N]o/[a]lways/n[e]ver) "
      read -k 1 confirmation
      [[ "$confirmation" = $'\n' ]] || echo

      # check input
      case "$confirmation" in
        [yY]) ;;
        [aA]) echo "$dirpath" >> "$ZSH_DOTENV_ALLOWED_LIST" ;;
        [eE]) echo "$dirpath" >> "$ZSH_DOTENV_DISALLOWED_LIST"; return ;;
        *) return ;; # interpret anything else as a no
      esac
    fi
  fi

  local content
  if [[ -p "$ZSH_DOTENV_FILE" ]]; then
    _dotenv_read_limited "$ZSH_DOTENV_FILE" || return 1
    content="$REPLY"
    _dotenv_check_syntax "$ZSH_DOTENV_FILE" "$content" || return 1

    setopt localoptions allexport
    _parse_dotenv_content "$content"
    return
  fi

  _dotenv_check_syntax "$ZSH_DOTENV_FILE" || return 1

  setopt localoptions allexport
  parse_dotenv "$ZSH_DOTENV_FILE"
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
