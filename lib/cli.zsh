#!/usr/bin/env zsh

function omz {
  setopt localoptions noksharrays
  [[ $# -gt 0 ]] || {
    _omz::help
    return 1
  }

  local command="$1"
  shift

  # Subcommand functions start with _ so that they don't
  # appear as completion entries when looking for `omz`
  (( ${+functions[_omz::$command]} )) || {
    _omz::help
    return 1
  }

  _omz::$command "$@"
}

function _omz {
  local -a cmds subcmds
  cmds=(
    'changelog:Print the changelog'
    'generate:Run a generator, e.g. to create a custom plugin'
    'help:Usage information'
    'plugin:Manage plugins'
    'pr:Manage Oh My Zsh Pull Requests'
    'reload:Reload the current zsh session'
    'shop:Open the Oh My Zsh shop'
    'theme:Manage themes'
    'update:Update Oh My Zsh'
    'version:Show the version'
  )

  if (( CURRENT == 2 )); then
    _describe 'command' cmds
  elif (( CURRENT == 3 )); then
    case "$words[2]" in
      changelog) local -a refs
        refs=("${(@f)$(builtin cd -q "$ZSH"; command git for-each-ref --format="%(refname:short):%(subject)" refs/heads refs/tags)}")
        _describe 'command' refs ;;
      generate) subcmds=('plugin:Create a custom plugin')
        _describe 'generator' subcmds ;;
      plugin) subcmds=(
        'disable:Disable plugin(s)'
        'enable:Enable plugin(s)'
        'info:Get plugin information'
        'list:List plugins'
        'load:Load plugin(s)'
      )
        _describe 'command' subcmds ;;
      pr) subcmds=('clean:Delete all Pull Request branches' 'test:Test a Pull Request')
        _describe 'command' subcmds ;;
      theme) subcmds=('list:List themes' 'set:Set a theme in your .zshrc file' 'use:Load a theme')
        _describe 'command' subcmds ;;
    esac
  elif (( CURRENT == 4 )); then
    case "${words[2]}::${words[3]}" in
      generate::plugin)
        _omz::generate::plugin::complete_options ;;
      plugin::(disable|enable|load))
        local -aU valid_plugins

        if [[ "${words[3]}" = disable ]]; then
          # if command is "disable", only offer already enabled plugins
          valid_plugins=($plugins)
        else
          valid_plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t))
          # if command is "enable", remove already enabled plugins
          [[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins})
        fi

        _describe 'plugin' valid_plugins ;;
      plugin::info)
        local -aU plugins
        plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t))
        _describe 'plugin' plugins ;;
      plugin::list)
        local -a opts
        opts=('--enabled:List enabled plugins only')
        _describe -o 'options' opts ;;
      theme::(set|use))
        local -aU themes
        themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r) "$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::))
        _describe 'theme' themes ;;
    esac
  elif (( CURRENT > 4 )); then
    case "${words[2]}::${words[3]}" in
      generate::plugin)
        _omz::generate::plugin::complete_options ;;
      plugin::(enable|disable|load))
        local -aU valid_plugins

        if [[ "${words[3]}" = disable ]]; then
          # if command is "disable", only offer already enabled plugins
          valid_plugins=($plugins)
        else
          valid_plugins=("$ZSH"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t) "$ZSH_CUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t))
          # if command is "enable", remove already enabled plugins
          [[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins})
        fi

        # Remove plugins already passed as arguments
        # NOTE: $(( CURRENT - 1 )) is the last plugin argument completely passed, i.e. that which
        # has a space after them. This is to avoid removing plugins partially passed, which makes
        # the completion not add a space after the completed plugin.
        local -a args
        args=(${words[4,$(( CURRENT - 1))]})
        valid_plugins=(${valid_plugins:|args})

        _describe 'plugin' valid_plugins ;;
    esac
  fi

  return 0
}

# If run from a script, do not set the completion function
if (( ${+functions[compdef]} )); then
  compdef _omz omz
fi

## Utility functions

function _omz::confirm {
  # If question supplied, ask it before reading the answer
  # NOTE: uses the logname of the caller function
  if [[ -n "$1" ]]; then
    _omz::log prompt "$1" "${${functrace[1]#_}%:*}"
  fi

  # Read one character
  read -r -k 1

  # If no newline entered, add a newline
  if [[ "$REPLY" != $'\n' ]]; then
    echo
  fi
}

function _omz::log {
  # if promptsubst is set, a message with `` or $()
  # will be run even if quoted due to `print -P`
  setopt localoptions nopromptsubst

  # $1 = info|warn|error|debug
  # $2 = text
  # $3 = (optional) name of the logger

  local logtype=$1
  local logname=${3:-${${functrace[1]#_}%:*}}

  # Don't print anything if debug is not active
  if [[ $logtype = debug && -z $_OMZ_DEBUG ]]; then
    return
  fi

  # Choose coloring based on log type
  case "$logtype" in
    prompt) print -Pn "%S%F{blue}$logname%f%s: $2" ;;
    debug) print -P "%F{white}$logname%f: $2" ;;
    info) print -P "%F{green}$logname%f: $2" ;;
    warn) print -P "%S%F{yellow}$logname%f%s: $2" ;;
    error) print -P "%S%F{red}$logname%f%s: $2" ;;
  esac >&2
}

## User-facing commands

function _omz::help {
  cat >&2 <<EOF
Usage: omz <command> [options]

Available commands:

  help                  Print this help message
  changelog             Print the changelog
  generate <generator>  Run a generator, e.g. to create a custom plugin
  plugin <command>      Manage plugins
  pr     <command>      Manage Oh My Zsh Pull Requests
  reload                Reload the current zsh session
  shop                  Open the Oh My Zsh shop
  theme  <command>      Manage themes
  update                Update Oh My Zsh
  version               Show the version

EOF
}

function _omz::changelog {
  local version=${1:-HEAD} format=${3:-"--text"}

  if (
    builtin cd -q "$ZSH"
    ! command git show-ref --verify refs/heads/$version && \
    ! command git show-ref --verify refs/tags/$version && \
    ! command git rev-parse --verify "${version}^{commit}"
  ) &>/dev/null; then
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} [version]

NOTE: <version> must be a valid branch, tag or commit.
EOF
    return 1
  fi

  ZSH="$ZSH" command zsh -f "$ZSH/tools/changelog.sh" "$version" "${2:-}" "$format"
}

function _omz::generate {
  (( $# > 0 && $+functions[$0::$1] )) || {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <generator> [options]

Available generators:

  plugin [<name>]  Create a custom plugin in \$ZSH_CUSTOM/plugins

EOF
    return 1
  }

  local command="$1"
  shift

  $0::$command "$@"
}

function _omz::generate::plugin {
  setopt localoptions extendedglob

  local -A opts
  zparseopts -D -E -A opts -- d: -description: c: -command: -no-completion -enable y -yes h -help || return 1

  if (( ${+opts[-h]} || ${+opts[--help]} )); then
    _omz::generate::plugin::usage
    return 0
  fi

  # zparseopts -E leaves anything it doesn't recognise in $@
  local arg
  for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
      _omz::log error "unknown option '$arg'."
      _omz::generate::plugin::usage
      return 1
    fi
  done
  if (( $# > 1 )); then
    _omz::generate::plugin::usage
    return 1
  fi

  # Only ask questions when there is someone there to answer them
  local interactive=0
  if [[ -o interactive && -t 0 ]] && (( ! ${+opts[-y]} && ! ${+opts[--yes]} )); then
    interactive=1
  fi

  local custom="${ZSH_CUSTOM:-${ZSH:+$ZSH/custom}}"
  if [[ -z "$custom" ]]; then
    _omz::log error "\$ZSH is not set. Is Oh My Zsh loaded?"
    return 1
  fi

  local templates="$ZSH/templates/generators/plugin"
  if [[ ! -d "$templates" ]]; then
    _omz::log error "templates not found at '${templates/#$HOME/\~}'. Try running 'omz update'."
    return 1
  fi

  # Check we can write to $ZSH_CUSTOM/plugins, or the closest directory that exists
  local probe="$custom/plugins"
  while [[ ! -e "$probe" && "$probe" != "${probe:h}" ]]; do
    probe="${probe:h}"
  done
  if [[ ! -w "$probe" ]]; then
    _omz::log error "cannot write to '${probe/#$HOME/\~}'. Set \$ZSH_CUSTOM to a directory you own."
    return 1
  fi

  ## Gather answers. Nothing is written until all of them are in.

  local name="$1" attempts=0
  if [[ -n "$name" ]]; then
    _omz::generate::plugin::validate_name "$name" || return 1
  elif (( interactive )); then
    while true; do
      _omz::generate::plugin::ask "Plugin name" || return 1
      name="$REPLY"
      _omz::generate::plugin::validate_name "$name" && break
      if (( ++attempts >= 3 )); then
        _omz::log error "giving up."
        return 1
      fi
    done
  else
    _omz::generate::plugin::usage
    return 1
  fi

  local dir="$custom/plugins/$name"
  if [[ -e "$dir" ]]; then
    _omz::log error "'$name' already exists at '${dir/#$HOME/\~}'. Remove it or pick another name."
    return 1
  fi
  if [[ -d "$ZSH/plugins/$name" ]]; then
    _omz::log warn "'$name' is also a built-in plugin. Your custom plugin will override it."
    if (( interactive )); then
      _omz::confirm "Continue? [y/N] "
      if [[ "$REPLY" != [yY] ]]; then
        _omz::log info "aborted."
        return 1
      fi
    fi
  fi

  local description="${opts[-d]:-${opts[--description]:-}}"
  if [[ -z "$description" ]]; then
    description="$name plugin for Oh My Zsh"
    if (( interactive )); then
      _omz::generate::plugin::ask "Short description" "$description" || return 1
      description="$REPLY"
    fi
  fi
  # The description goes into a comment and a README line: keep it on one line
  description="${description//[[:cntrl:]]/ }"

  local cmd="${opts[-c]:-${opts[--command]:-}}"
  if [[ -n "$cmd" ]]; then
    _omz::generate::plugin::validate_command "$cmd" || return 1
  elif (( interactive )); then
    local default_cmd=""
    (( $+commands[$name] )) && default_cmd="$name"
    attempts=0
    while true; do
      if [[ -n "$default_cmd" ]]; then
        _omz::generate::plugin::ask "Command-line tool this plugin wraps (or 'none')" "$default_cmd" || return 1
      else
        _omz::generate::plugin::ask "Command-line tool this plugin wraps (blank for none)" || return 1
      fi
      cmd="$REPLY"
      [[ "$cmd" != (none|-) ]] || cmd=""
      [[ -n "$cmd" ]] || break
      _omz::generate::plugin::validate_command "$cmd" && break
      if (( ++attempts >= 3 )); then
        _omz::log error "giving up."
        return 1
      fi
    done
  fi

  # completion: "" (none), "file" (a _<cmd> skeleton) or "cached" (the tool generates it)
  local completion="" compgen=""
  if [[ -n "$cmd" ]] && (( ! ${+opts[--no-completion]} )); then
    completion=file
    if (( interactive )); then
      _omz::confirm "Add a completion function for $cmd? [Y/n] "
      if [[ "$REPLY" == [nN] ]]; then
        completion=""
      else
        _omz::confirm "Does $cmd generate its own zsh completion (e.g. '$cmd completion zsh')? [y/N] "
        if [[ "$REPLY" == [yY] ]]; then
          completion=cached
          _omz::generate::plugin::ask "Command that prints the completion script" "$cmd completion zsh" || return 1
          compgen="$REPLY"
        fi
      fi
    fi
  fi

  local enable=${+opts[--enable]}
  if (( interactive && ! enable )); then
    _omz::confirm "Add $name to plugins=() in your .zshrc now? [y/N] "
    [[ "$REPLY" != [yY] ]] || enable=1
  fi

  ## Write the files. If anything fails, remove only what we created.

  local -a created
  local block="" cache="" ok=0
  {
    if [[ ! -d "$custom/plugins" ]]; then
      command mkdir -p "$custom/plugins" || return 1
      _omz::generate::plugin::created "$custom/plugins"
    fi
    command mkdir "$dir" || return 1
    _omz::generate::plugin::created "$dir"

    local plugin_tpl=plugin.zsh-template readme_tpl=README.md-template
    if [[ -z "$cmd" ]]; then
      plugin_tpl=plugin-generic.zsh-template
      readme_tpl=README-generic.md-template
    elif [[ "$completion" == cached ]]; then
      block="$(_omz::generate::plugin::template completion-cached.zsh-template)" || return 1
      cache="$(_omz::generate::plugin::template README-cache.md-template)" || return 1
    else
      block="$(_omz::generate::plugin::template completion-note.zsh-template)" || return 1
    fi

    _omz::generate::plugin::render "$plugin_tpl" "$dir/$name.plugin.zsh" || return 1
    _omz::generate::plugin::render "$readme_tpl" "$dir/README.md" || return 1
    if [[ "$completion" == file ]]; then
      _omz::generate::plugin::render completion.zsh-template "$dir/_$cmd" || return 1
    fi
    ok=1
  } always {
    if (( ! ok )); then
      _omz::log error "could not generate the plugin. Cleaning up..."
      (( ${#created} )) && command rm -f -- "${created[@]}"
      [[ ! -d "$dir" ]] || command rmdir -- "$dir" 2>/dev/null
    fi
  }

  print
  _omz::log info "plugin '$name' generated."
  print
  print -r -- "Next steps:"
  print
  print -r -- "  1. Edit it:     ${EDITOR:-vim} ${dir/#$HOME/\~}/$name.plugin.zsh"
  print -r -- "  2. Try it now:  omz plugin load $name"
  (( enable )) || print -r -- "  3. Keep it:     omz plugin enable $name"
  print
  print -r -- "Docs: https://github.com/ohmyzsh/ohmyzsh/wiki/Customization#overriding-and-adding-plugins"

  # Last thing we do: in an interactive shell this restarts zsh
  if (( enable )); then
    print
    _omz::plugin::enable "$name"
  fi
}

function _omz::generate::plugin::usage {
  cat >&2 <<EOF
Usage: omz generate plugin [<name>] [options]

Creates a custom plugin in \$ZSH_CUSTOM/plugins/<name>. Anything not given as an
option is asked for interactively. In a non-interactive shell (or with --yes)
defaults are used instead.

Options:
  -d, --description <text>  One-line description for the README and file header
  -c, --command <cmd>       Command-line tool this plugin wraps. Adds a check
                            that it is installed and scaffolds its completion
      --no-completion       Don't scaffold a completion function
      --enable              Add the plugin to plugins=() in .zshrc when done
                            (restarts your shell)
  -y, --yes                 Never prompt; use defaults for anything not given
  -h, --help                Show this help

EOF
}

function _omz::generate::plugin::complete_options {
  local -a opts
  opts=(
    '--description:One-line description for the README'
    '--command:Command-line tool this plugin wraps'
    '--no-completion:Skip the completion scaffold'
    '--enable:Enable the plugin when done'
    '--yes:Never prompt'
  )
  _describe -o 'options' opts
}

# The name ends up in a mkdir path and, via --enable, inside the awk script that
# rewrites .zshrc. This is the one place it gets checked.
function _omz::generate::plugin::validate_name {
  setopt localoptions extendedglob
  local name="$1"

  if [[ -z "$name" ]]; then
    _omz::log error "plugin name cannot be empty."
  elif (( ${#name} > 64 )); then
    _omz::log error "plugin name is too long (64 characters max)."
  elif [[ "$name" != "${name:l}" ]]; then
    _omz::log error "plugin names must be lowercase. Did you mean '${name:l}'?"
  elif [[ "$name" != [a-z0-9][a-z0-9_-]# ]]; then
    _omz::log error "invalid plugin name: use only lowercase letters, digits, '-' and '_', starting with a letter or digit."
  else
    return 0
  fi
  return 1
}

# The command name ends up in $+commands[...], _comps[...] and a filename
function _omz::generate::plugin::validate_command {
  setopt localoptions extendedglob

  if (( ${#1} > 64 )) || [[ "$1" != [[:alnum:]_][[:alnum:]_.+-]# ]]; then
    _omz::log error "invalid command name: use only letters, digits, '.', '_', '+' and '-'."
    return 1
  fi
}

# Ask a question and leave the answer in $REPLY. An empty answer takes the
# default. Returns 1 when there is no more input (Ctrl-D).
function _omz::generate::plugin::ask {
  setopt localoptions extendedglob
  local question="$1" default="$2"
  [[ -z "$default" ]] || question+=" [$default]"

  _omz::log prompt "$question: " "omz::generate::plugin"
  if ! builtin read -r; then
    print >&2
    _omz::log info "aborted." "omz::generate::plugin"
    return 1
  fi

  [[ -n "$REPLY" ]] || REPLY="$default"
  # Answers are single-line values: flatten control characters and trim
  REPLY="${REPLY//[[:cntrl:]]/ }"
  REPLY="${${REPLY##[[:space:]]#}%%[[:space:]]#}"
}

# Print a template file, or explain which one is missing
function _omz::generate::plugin::template {
  if [[ ! -f "$templates/$1" ]]; then
    _omz::log error "missing template '${templates/#$HOME/\~}/$1'." "omz::generate::plugin"
    return 1
  fi
  print -r -- "$(<"$templates/$1")"
}

# Fill in the %placeholders% of a template and write it to a file. Values come
# from the caller: $name, $cmd, $description, $compgen, $block and $cache.
# Substitution is done with parameter expansion rather than sed so that the
# values are always taken literally.
function _omz::generate::plugin::render {
  setopt localoptions extendedglob
  local content
  content="$(_omz::generate::plugin::template "$1")" || return 1

  # Blocks go first: they contain placeholders of their own
  content="${content//'%completion%'/$block}"
  content="${content//'%cache%'/$cache}"
  content="${content//'%name%'/$name}"
  content="${content//'%command%'/$cmd}"
  content="${content//'%description%'/$description}"
  content="${content//'%compgen%'/$compgen}"
  # Drop blank lines left behind by an empty placeholder at the end
  content="${content%%$'\n'##}"

  created+=("$2")
  print -r -- "$content" > "$2" || return 1
  _omz::generate::plugin::created "$2"
}

function _omz::generate::plugin::created {
  # Colour the verb with print -P, but print the path with print -r so that a
  # '%' somewhere in the path isn't treated as a prompt escape.
  # Keep the output plain when it is being piped.
  if [[ -t 1 ]]; then
    print -Pn "      %F{green}create%f  "
  else
    print -n "      create  "
  fi
  print -r -- "${1/#$HOME/\~}"
}

function _omz::plugin {
  (( $# > 0 && $+functions[$0::$1] )) || {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  disable <plugin> Disable plugin(s)
  enable <plugin>  Enable plugin(s)
  info <plugin>    Get information of a plugin
  list [--enabled] List Oh My Zsh plugins
  load <plugin>    Load plugin(s)

EOF
    return 1
  }

  local command="$1"
  shift

  $0::$command "$@"
}

function _omz::plugin::disable {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]"
    return 1
  fi

  # Check that plugin is in $plugins
  local -a dis_plugins
  for plugin in "$@"; do
    if [[ ${plugins[(Ie)$plugin]} -eq 0 ]]; then
      _omz::log warn "plugin '$plugin' is not enabled."
      continue
    fi
    dis_plugins+=("$plugin")
  done

  # Exit if there are no enabled plugins to disable
  if [[ ${#dis_plugins} -eq 0 ]]; then
    return 1
  fi

  # Remove plugins substitution awk script
  local awk_subst_plugins="\
  gsub(/[ \t]+(${(j:|:)dis_plugins})[ \t]+/, \" \") # with spaces before or after
  gsub(/[ \t]+(${(j:|:)dis_plugins})$/, \"\")       # with spaces before and EOL
  gsub(/^(${(j:|:)dis_plugins})[ \t]+/, \"\")       # with BOL and spaces after

  gsub(/\((${(j:|:)dis_plugins})[ \t]+/, \"(\")     # with parenthesis before and spaces after
  gsub(/[ \t]+(${(j:|:)dis_plugins})\)/, \")\")     # with spaces before or parenthesis after
  gsub(/\((${(j:|:)dis_plugins})\)/, \"()\")        # with only parentheses

  gsub(/^(${(j:|:)dis_plugins})\)/, \")\")          # with BOL and closing parenthesis
  gsub(/\((${(j:|:)dis_plugins})$/, \"(\")          # with opening parenthesis and EOL
"

  # Disable plugins awk script
  local awk_script="
# if plugins=() is in oneline form, substitute disabled plugins and go to next line
/^[ \t]*plugins=\([^#]+\).*\$/ {
  $awk_subst_plugins
  print \$0
  next
}

# if plugins=() is in multiline form, enable multi flag and disable plugins if they're there
/^[ \t]*plugins=\(/ {
  multi=1
  $awk_subst_plugins
  print \$0
  next
}

# if multi flag is enabled and we find a valid closing parenthesis, remove plugins and disable multi flag
multi == 1 && /^[^#]*\)/ {
  multi=0
  $awk_subst_plugins
  print \$0
  next
}

multi == 1 && length(\$0) > 0 {
  $awk_subst_plugins
  if (length(\$0) > 0) print \$0
  next
}

{ print \$0 }
"

  local zdot="${ZDOTDIR:-$HOME}"
  local zshrc="${${:-"${zdot}/.zshrc"}:A}"
  awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" \
  && command cp -f "$zshrc" "$zdot/.zshrc.bck" \
  && command mv -f "$zdot/.zshrc.new" "$zshrc"

  # Exit if the new .zshrc file wasn't created correctly
  [[ $? -eq 0 ]] || {
    local ret=$?
    _omz::log error "error disabling plugins."
    return $ret
  }

  # Exit if the new .zshrc file has syntax errors
  if ! command zsh -n "$zdot/.zshrc"; then
    _omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
    command mv -f "$zdot/.zshrc.bck" "$zshrc"
    return 1
  fi

  # Restart the zsh session if there were no errors
  _omz::log info "plugins disabled: ${(j:, :)dis_plugins}."

  # Only reload zsh if run in an interactive session
  [[ ! -o interactive ]] || _omz::reload
}

function _omz::plugin::enable {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]"
    return 1
  fi

  # Check that plugin is not in $plugins
  local -a add_plugins
  for plugin in "$@"; do
    if [[ ${plugins[(Ie)$plugin]} -ne 0 ]]; then
      _omz::log warn "plugin '$plugin' is already enabled."
      continue
    fi
    add_plugins+=("$plugin")
  done

  # Exit if there are no plugins to enable
  if [[ ${#add_plugins} -eq 0 ]]; then
    return 1
  fi

  # Enable plugins awk script
  local awk_script="
# if plugins=() is in oneline form, substitute ) with new plugins and go to the next line
/^[ \t]*plugins=\([^#]+\).*\$/ {
  sub(/\)/, \" $add_plugins&\")
  print \$0
  next
}

# if plugins=() is in multiline form, enable multi flag and indent by default with 2 spaces
/^[ \t]*plugins=\(/ {
  multi=1
  indent=\"  \"
  print \$0
  next
}

# if multi flag is enabled and we find a valid closing parenthesis,
# add new plugins with proper indent and disable multi flag
multi == 1 && /^[^#]*\)/ {
  multi=0
  split(\"$add_plugins\",p,\" \")
  for (i in p) {
    print indent p[i]
  }
  print \$0
  next
}

# if multi flag is enabled and we didn't find a closing parenthesis,
# get the indentation level to match when adding plugins
multi == 1 && /^[^#]*/ {
  indent=\"\"
  for (i = 1; i <= length(\$0); i++) {
    char=substr(\$0, i, 1)
    if (char == \" \" || char == \"\t\") {
      indent = indent char
    } else {
      break
    }
  }
}

{ print \$0 }
"

  local zdot="${ZDOTDIR:-$HOME}"
  local zshrc="${${:-"${zdot}/.zshrc"}:A}"
  awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" \
  && command cp -f "$zshrc" "$zdot/.zshrc.bck" \
  && command mv -f "$zdot/.zshrc.new" "$zshrc"

  # Exit if the new .zshrc file wasn't created correctly
  [[ $? -eq 0 ]] || {
    local ret=$?
    _omz::log error "error enabling plugins."
    return $ret
  }

  # Exit if the new .zshrc file has syntax errors
  if ! command zsh -n "$zdot/.zshrc"; then
    _omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
    command mv -f "$zdot/.zshrc.bck" "$zshrc"
    return 1
  fi

  # Restart the zsh session if there were no errors
  _omz::log info "plugins enabled: ${(j:, :)add_plugins}."

  # Only reload zsh if run in an interactive session
  [[ ! -o interactive ]] || _omz::reload
}

function _omz::plugin::info {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <plugin>"
    return 1
  fi

  local readme
  for readme in "$ZSH_CUSTOM/plugins/$1/README.md" "$ZSH/plugins/$1/README.md"; do
    if [[ -f "$readme" ]]; then
      # If being piped, just cat the README
      if [[ ! -t 1 ]]; then
        cat "$readme"
        return $?
      fi

      # Enrich the README display depending on the tools we have
      # - glow: https://github.com/charmbracelet/glow
      # - bat: https://github.com/sharkdp/bat
      # - less: typical pager command
      case 1 in
        ${+commands[glow]}) glow -p "$readme" ;;
        ${+commands[bat]}) bat -l md --style plain "$readme" ;;
        ${+commands[less]}) less "$readme" ;;
        *) cat "$readme" ;;
      esac
      return $?
    fi
  done

  if [[ -d "$ZSH_CUSTOM/plugins/$1" || -d "$ZSH/plugins/$1" ]]; then
    _omz::log error "the '$1' plugin doesn't have a README file"
  else
    _omz::log error "'$1' plugin not found"
  fi

  return 1
}

function _omz::plugin::list {
  local -a custom_plugins builtin_plugins

  # If --enabled is provided, only list what's enabled
  if [[ "$1" == "--enabled" ]]; then
    local plugin
    for plugin in "${plugins[@]}"; do
      if [[ -d "${ZSH_CUSTOM}/plugins/${plugin}" ]]; then
        custom_plugins+=("${plugin}")
      elif [[ -d "${ZSH}/plugins/${plugin}" ]]; then
        builtin_plugins+=("${plugin}")
      fi
    done
  else
    custom_plugins=("$ZSH_CUSTOM"/plugins/*(-/N:t))
    builtin_plugins=("$ZSH"/plugins/*(-/N:t))
  fi

  # If the command is being piped, print all found line by line
  if [[ ! -t 1 ]]; then
    print -l ${(q-)custom_plugins} ${(q-)builtin_plugins}
    return
  fi

  if (( ${#custom_plugins} )); then
    print -P "%U%BCustom plugins%b%u:"
    print -lac ${(q-)custom_plugins}
  fi

  if (( ${#builtin_plugins} )); then
    (( ${#custom_plugins} )) && echo # add a line of separation

    print -P "%U%BBuilt-in plugins%b%u:"
    print -lac ${(q-)builtin_plugins}
  fi
}

function _omz::plugin::load {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <plugin> [...]"
    return 1
  fi

  local plugin base has_completion=0
  for plugin in "$@"; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      base="$ZSH_CUSTOM/plugins/$plugin"
    elif [[ -d "$ZSH/plugins/$plugin" ]]; then
      base="$ZSH/plugins/$plugin"
    else
      _omz::log warn "plugin '$plugin' not found"
      continue
    fi

    # Check if its a valid plugin
    if [[ ! -f "$base/_$plugin" && ! -f "$base/$plugin.plugin.zsh" ]]; then
      _omz::log warn "'$plugin' is not a valid plugin"
      continue
    # It is a valid plugin, add its directory to $fpath unless it is already there
    elif (( ! ${fpath[(Ie)$base]} )); then
      fpath=("$base" $fpath)
    fi

    # Check if it has completion to reload compinit
    local -a comp_files
    comp_files=($base/_*(N))
    (( has_completion )) || has_completion=$(( $#comp_files > 0 ))

    # Load the plugin
    if [[ -f "$base/$plugin.plugin.zsh" ]]; then
      source "$base/$plugin.plugin.zsh"
    fi
  done

  # If we have completion, we need to reload the completion
  # We pass -D to avoid generating a new dump file, which would overwrite our
  # current one for the next session (and we don't want that because we're not
  # actually enabling the plugins for the next session).
  # Note that we still have to pass -d "$_comp_dumpfile", so that compinit
  # doesn't use the default zcompdump location (${ZDOTDIR:-$HOME}/.zcompdump).
  if (( has_completion )); then
    compinit -D -d "$_comp_dumpfile"
  fi
}

function _omz::pr {
  (( $# > 0 && $+functions[$0::$1] )) || {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  clean                       Delete all PR branches (ohmyzsh/pull-*)
  test <PR_number_or_URL>     Fetch PR #NUMBER and rebase against master

EOF
    return 1
  }

  local command="$1"
  shift

  $0::$command "$@"
}

function _omz::pr::clean {
  (
    set -e
    builtin cd -q "$ZSH"

    # Check if there are PR branches
    local fmt branches
    fmt="%(color:bold blue)%(align:18,right)%(refname:short)%(end)%(color:reset) %(color:dim bold red)%(objectname:short)%(color:reset) %(color:yellow)%(contents:subject)"
    branches="$(command git for-each-ref --sort=-committerdate --color --format="$fmt" "refs/heads/ohmyzsh/pull-*")"

    # Exit if there are no PR branches
    if [[ -z "$branches" ]]; then
      _omz::log info "there are no Pull Request branches to remove."
      return
    fi

    # Print found PR branches
    echo "$branches\n"
    # Confirm before removing the branches
    _omz::confirm "do you want remove these Pull Request branches? [Y/n] "
    # Only proceed if the answer is a valid yes option
    [[ "$REPLY" != [yY$'\n'] ]] && return

    _omz::log info "removing all Oh My Zsh Pull Request branches..."
    command git branch --list 'ohmyzsh/pull-*' | while read branch; do
      command git branch -D "$branch"
    done
  )
}

function _omz::pr::test {
  # Allow $1 to be a URL to the pull request
  if [[ "$1" = https://* ]]; then
    1="${1:t}"
  fi

  # Check the input
  if ! [[ -n "$1" && "$1" =~ ^[[:digit:]]+$ ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <PR_NUMBER_or_URL>"
    return 1
  fi

  # Save current git HEAD
  local branch
  branch=$(builtin cd -q "$ZSH"; git symbolic-ref --short HEAD) || {
    _omz::log error "error when getting the current git branch. Aborting..."
    return 1
  }


  # Fetch PR onto ohmyzsh/pull-<PR_NUMBER> branch and rebase against master
  # If any of these operations fail, undo the changes made
  (
    set -e
    builtin cd -q "$ZSH"

    # Get the ohmyzsh git remote
    command git remote -v | while read remote url _; do
      case "$url" in
      https://github.com/ohmyzsh/ohmyzsh(|.git)) found=1; break ;;
      git@github.com:ohmyzsh/ohmyzsh(|.git)) found=1; break ;;
      esac
    done

    (( $found )) || {
      _omz::log error "could not find the ohmyzsh git remote. Aborting..."
      return 1
    }

    # Check if Pull Request has the "testers needed" label
    _omz::log info "checking if PR #$1 has the 'testers needed' label..."
    local pr_json label label_id="MDU6TGFiZWw4NzY1NTkwNA=="
    pr_json=$(
      curl -fsSL \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/ohmyzsh/ohmyzsh/pulls/$1"
    )

    if [[ $? -gt 0 || -z "$pr_json" ]]; then
      _omz::log error "error when trying to fetch PR #$1 from GitHub."
      return 1
    fi

    # Check if the label is present with jq or grep
    if (( $+commands[jq] )); then
      label="$(command jq ".labels.[] | select(.node_id == \"$label_id\")" <<< "$pr_json")"
    else
      label="$(command grep "\"$label_id\"" <<< "$pr_json" 2>/dev/null)"
    fi

    # If a maintainer hasn't labeled the PR to test, explain the security risk
    if [[ -z "$label" ]]; then
      _omz::log warn "PR #$1 does not have the 'testers needed' label. This means that the PR"
      _omz::log warn "has not been reviewed by a maintainer and may contain malicious code."

      # Ask for explicit confirmation: user needs to type "yes" to continue
      _omz::log prompt "Do you want to continue testing it? [yes/N] "
      builtin read -r
      if [[ "${REPLY:l}" != yes ]]; then
        _omz::log error "PR test canceled. Please ask a maintainer to review and label the PR."
        return 1
      else
        _omz::log warn "Continuing to check out and test PR #$1. Be careful!"
      fi
    fi

    # Fetch pull request head
    _omz::log info "fetching PR #$1 to ohmyzsh/pull-$1..."
    command git fetch -f "$remote" refs/pull/$1/head:ohmyzsh/pull-$1 || {
      _omz::log error "error when trying to fetch PR #$1."
      return 1
    }

    # Rebase pull request branch against the current master
    _omz::log info "rebasing PR #$1..."
    local ret gpgsign
    {
      # Back up commit.gpgsign setting: use --local to get the current repository
      # setting, not the global one. If --local is not a known option, it will
      # exit with a 129 status code.
      gpgsign=$(command git config --local commit.gpgsign 2>/dev/null) || ret=$?
      [[ $ret -ne 129 ]] || gpgsign=$(command git config commit.gpgsign 2>/dev/null)
      command git config commit.gpgsign false

      command git rebase master ohmyzsh/pull-$1 || {
        command git rebase --abort &>/dev/null
        _omz::log warn "could not rebase PR #$1 on top of master."
        _omz::log warn "you might not see the latest stable changes."
        _omz::log info "run \`zsh\` to test the changes."
        return 1
      }
    } always {
      case "$gpgsign" in
      "") command git config --unset commit.gpgsign ;;
      *) command git config commit.gpgsign "$gpgsign" ;;
      esac
    }

    _omz::log info "fetch of PR #${1} successful."
  )

  # If there was an error, abort running zsh to test the PR
  [[ $? -eq 0 ]] || return 1

  # Run zsh to test the changes
  _omz::log info "running \`zsh\` to test the changes. Run \`exit\` to go back."
  command zsh -l

  # After testing, go back to the previous HEAD if the user wants
  _omz::confirm "do you want to go back to the previous branch? [Y/n] "
  # Only proceed if the answer is a valid yes option
  [[ "$REPLY" != [yY$'\n'] ]] && return

  (
    set -e
    builtin cd -q "$ZSH"

    command git checkout "$branch" -- || {
      _omz::log error "could not go back to the previous branch ('$branch')."
      return 1
    }
  )
}

function _omz::shop {
  local shop_url="https://commitgoods.com/collections/oh-my-zsh"
  
  _omz::log info "Opening Oh My Zsh shop in your browser..."
  _omz::log info "$shop_url"
  
  open_command "$shop_url"
}

function _omz::reload {
  # Delete current completion cache
  command rm -f $_comp_dumpfile $ZSH_COMPDUMP

  # Old zsh versions don't have ZSH_ARGZERO
  local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}"
  # Check whether to run a login shell
  [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}

function _omz::theme {
  (( $# > 0 && $+functions[$0::$1] )) || {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}} <command> [options]

Available commands:

  list            List all available Oh My Zsh themes
  set <theme>     Set a theme in your .zshrc file
  use <theme>     Load a theme

EOF
    return 1
  }

  local command="$1"
  shift

  $0::$command "$@"
}

function _omz::theme::list {
  local -a custom_themes builtin_themes
  custom_themes=("$ZSH_CUSTOM"/**/*.zsh-theme(-.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::))
  builtin_themes=("$ZSH"/themes/*.zsh-theme(-.N:t:r))

  # If the command is being piped, print all found line by line
  if [[ ! -t 1 ]]; then
    print -l ${(q-)custom_themes} ${(q-)builtin_themes}
    return
  fi

  # Print theme in use
  if [[ -n "$ZSH_THEME" ]]; then
    print -Pn "%U%BCurrent theme%b%u: "
    [[ $ZSH_THEME = random ]] && echo "$RANDOM_THEME (via random)" || echo "$ZSH_THEME"
    echo
  fi

  # Print custom themes if there are any
  if (( ${#custom_themes} )); then
    print -P "%U%BCustom themes%b%u:"
    print -lac ${(q-)custom_themes}
    echo
  fi

  # Print built-in themes
  print -P "%U%BBuilt-in themes%b%u:"
  print -lac ${(q-)builtin_themes}
}

function _omz::theme::set {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <theme>"
    return 1
  fi

  # Check that theme exists
  if [[ ! -f "$ZSH_CUSTOM/$1.zsh-theme" ]] \
    && [[ ! -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]] \
    && [[ ! -f "$ZSH/themes/$1.zsh-theme" ]]; then
    _omz::log error "%B$1%b theme not found"
    return 1
  fi

  # Enable theme in .zshrc
  local awk_script='
!set && /^[ \t]*ZSH_THEME=[^#]+.*$/ {
  set=1
  sub(/^[ \t]*ZSH_THEME=[^#]+.*$/, "ZSH_THEME=\"'$1'\" # set by `omz`")
  print $0
  next
}

{ print $0 }

END {
  # If no ZSH_THEME= line was found, return an error
  if (!set) exit 1
}
'

  local zdot="${ZDOTDIR:-$HOME}"
  local zshrc="${${:-"${zdot}/.zshrc"}:A}"
  awk "$awk_script" "$zshrc" > "$zdot/.zshrc.new" \
  || {
    # Prepend ZSH_THEME= line to .zshrc if it doesn't exist
    cat <<EOF
ZSH_THEME="$1" # set by \`omz\`

EOF
    cat "$zdot/.zshrc"
  } > "$zdot/.zshrc.new" \
  && command cp -f "$zshrc" "$zdot/.zshrc.bck" \
  && command mv -f "$zdot/.zshrc.new" "$zshrc"

  # Exit if the new .zshrc file wasn't created correctly
  [[ $? -eq 0 ]] || {
    local ret=$?
    _omz::log error "error setting theme."
    return $ret
  }

  # Exit if the new .zshrc file has syntax errors
  if ! command zsh -n "$zdot/.zshrc"; then
    _omz::log error "broken syntax in '"${zdot/#$HOME/\~}/.zshrc"'. Rolling back changes..."
    command mv -f "$zdot/.zshrc.bck" "$zshrc"
    return 1
  fi

  # Restart the zsh session if there were no errors
  _omz::log info "'$1' theme set correctly."

  # Only reload zsh if run in an interactive session
  [[ ! -o interactive ]] || _omz::reload
}

function _omz::theme::use {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} <theme>"
    return 1
  fi

  # Respect compatibility with old lookup order
  if [[ -f "$ZSH_CUSTOM/$1.zsh-theme" ]]; then
    source "$ZSH_CUSTOM/$1.zsh-theme"
  elif [[ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]]; then
    source "$ZSH_CUSTOM/themes/$1.zsh-theme"
  elif [[ -f "$ZSH/themes/$1.zsh-theme" ]]; then
    source "$ZSH/themes/$1.zsh-theme"
  else
    _omz::log error "%B$1%b theme not found"
    return 1
  fi

  # Update theme settings
  ZSH_THEME="$1"
  [[ $1 = random ]] || unset RANDOM_THEME
}

function _omz::update {
  # Check if git command is available
  (( $+commands[git] )) || {
    _omz::log error "git is not installed. Aborting..."
    return 1
  }

  # Check if --unattended was passed
  [[ "$1" != --unattended ]] || {
    _omz::log error "the \`\e[2m--unattended\e[0m\` flag is no longer supported, use the \`\e[2mupgrade.sh\e[0m\` script instead."
    _omz::log error "for more information see https://github.com/ohmyzsh/ohmyzsh/wiki/FAQ#how-do-i-update-oh-my-zsh"
    return 1
  }

  local last_commit=$(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null)
  [[ $? -eq 0 ]] || {
    _omz::log error "\`$ZSH\` is not a git directory. Aborting..."
    return 1
  }

  # Run update script
  zstyle -s ':omz:update' verbose verbose_mode || verbose_mode=default
  ZSH="$ZSH" command zsh -f "$ZSH/tools/upgrade.sh" -i -v $verbose_mode || return $?

  # Update last updated file
  zmodload zsh/datetime
  echo "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >! "${ZSH_CACHE_DIR}/.zsh-update"
  # Remove update lock if it exists
  command rm -rf "$ZSH/log/update.lock"

  # Restart the zsh session if there were changes
  if [[ "$(builtin cd -q "$ZSH"; git rev-parse HEAD)" != "$last_commit" ]]; then
    # Old zsh versions don't have ZSH_ARGZERO
    local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}"
    # Check whether to run a login shell
    [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
  fi
}

function _omz::version {
  (
    builtin cd -q "$ZSH"

    # Get the version name:
    # 1) try tag-like version
    # 2) try branch name
    # 3) try name-rev (tag~<rev> or branch~<rev>)
    local version
    version=$(command git describe --tags HEAD 2>/dev/null) \
    || version=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) \
    || version=$(command git name-rev --no-undefined --name-only --exclude="remotes/*" HEAD 2>/dev/null) \
    || version="<detached>"

    # Get short hash for the current HEAD
    local commit=$(command git rev-parse --short HEAD 2>/dev/null)

    # Show version and commit hash
    printf "%s (%s)\n" "$version" "$commit"
  )
}
