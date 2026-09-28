# Shopify CLI: completion, aliases and guard rails.
# https://shopify.dev/docs/api/shopify-cli

if (( ! $+commands[shopify] )); then
  return
fi

# Prefer a project-local CLI: app and Hydrogen projects pin their own version.
# The walk stops at $HOME so a stray ~/node_modules cannot hijack every project.
# $commands avoids resolving back to the wrapper function below.
function _shopify_bin() {
  local dir="$PWD"
  while [[ -n "$dir" && "$dir" != "/" && "$dir" != "$HOME" ]]; do
    if [[ -x "$dir/node_modules/.bin/shopify" ]]; then
      print -r -- "$dir/node_modules/.bin/shopify"
      return 0
    fi
    dir="${dir:h}"
  done
  print -r -- "$commands[shopify]"
}

# Print the project type in $PWD: hydrogen, app or theme.
# Hydrogen is tested first because those projects usually carry a
# shopify.app.toml too. shopify.theme.toml is not a theme marker: it only
# exists once environments are configured.
function _shopify_project_type() {
  local dir="$PWD"
  local -a app_config

  while [[ -n "$dir" && "$dir" != "/" && "$dir" != "$HOME" ]]; do
    if [[ -x "$dir/node_modules/.bin/h2" ]] ||
      [[ -r "$dir/package.json" && "$(<"$dir/package.json")" == *'"@shopify/hydrogen"'* ]]; then
      return 0
    fi

    app_config=("$dir"/shopify.app*.toml(N))
    if (( $#app_config )); then
      print -r -- app
      return 0
    fi

    if [[ -f "$dir/config/settings_schema.json" && -f "$dir/layout/theme.liquid" ]]; then
      print -r -- theme
      return 0
    fi

    dir="${dir:h}"
  done

  return 1
}

# Does this invocation need confirming? Sets REPLY to the reason.
function _shopify_is_destructive() {
  zstyle -T ':omz:plugins:shopify' confirm-destructive || return 1

  # Nobody to answer: CI and pipelines are unaffected.
  [[ -t 0 ]] || return 1

  local topic="$1" subcommand="$2" arg
  local -a long
  local short=""

  # Short flags can be bundled, so collect them as characters: -al counts as l.
  for arg in "${@[3,-1]}"; do
    [[ "$arg" == "--" ]] && break
    case "$arg" in
      --*) long+=("${arg%%=*}") ;;
      -?*) short+="${${arg%%=*}#-}" ;;
    esac
  done

  # An explicit force flag states the intent already.
  if (( long[(I)--force] )) || [[ "$short" == *f* ]]; then
    return 1
  fi

  case "$topic $subcommand" in
    "theme push")
      if (( long[(I)--live] || long[(I)--publish] )) || [[ "$short" == *[lp]* ]]; then
        REPLY="this overwrites or publishes the live theme on the storefront."
        return 0
      fi
      ;;
    "theme delete")
      REPLY="deleting a theme cannot be undone."
      return 0
      ;;
    "app deploy")
      if (( long[(I)--allow-deletes] )); then
        REPLY="this can permanently remove app extensions."
        return 0
      fi
      ;;
  esac

  return 1
}

# Adds a confirmation prompt before irreversible operations. Everything else
# passes straight through, so `theme dev` stays interactive and pipes stay clean.
function shopify() {
  local REPLY
  if _shopify_is_destructive "$@"; then
    print -u2 -- "shopify: $REPLY"
    if ! read -q "?Continue? [y/N] "; then
      print -u2 -- ""
      return 130
    fi
    print -u2 -- ""
  fi

  "$(_shopify_bin)" "$@"
}

# Print the commands worth running in the current directory.
function shopify_here() {
  local project_type
  project_type="$(_shopify_project_type)"

  case "$project_type" in
    theme)
      print -- "Shopify theme project."
      print -- "  shopify theme dev     Preview locally with live reload"
      print -- "  shopify theme check   Lint the theme"
      print -- "  shopify theme list    List the themes on the store"
      print -- "  shopify theme pull    Download a remote theme into this folder"
      print -- "  shopify theme push    Upload this folder to a remote theme"
      ;;
    app)
      print -- "Shopify app project."
      print -- "  shopify app dev       Run the app against a development store"
      print -- "  shopify app info      Show how the app is configured"
      print -- "  shopify app deploy    Deploy the app and its extensions"
      print -- "  shopify app logs      Stream app logs"
      ;;
    hydrogen)
      print -- "Hydrogen storefront."
      print -- "  shopify hydrogen dev      Run the storefront locally"
      print -- "  shopify hydrogen build    Build for production"
      print -- "  shopify hydrogen deploy   Deploy to Oxygen"
      print -- "  shopify hydrogen link     Link this project to a storefront"
      ;;
    *)
      print -- "No Shopify project found here."
      print -- "  shopify theme init      Start a new theme"
      print -- "  shopify app init        Start a new app"
      print -- "  shopify hydrogen init   Start a new Hydrogen storefront"
      ;;
  esac
}

# Run the dev server for whichever kind of project this is.
function shopd() {
  local project_type
  if ! project_type="$(_shopify_project_type)"; then
    print -u2 -- "shopd: not inside a Shopify theme, app or Hydrogen project."
    return 1
  fi
  shopify "$project_type" dev "$@"
}

# Show what the current project is connected to.
function shopi() {
  local project_type
  if ! project_type="$(_shopify_project_type)"; then
    print -u2 -- "shopi: not inside a Shopify theme, app or Hydrogen project."
    return 1
  fi
  case "$project_type" in
    hydrogen) shopify hydrogen list "$@" ;;
    *) shopify "$project_type" info "$@" ;;
  esac
}

# Complete the helpers like the commands they stand in for.
if (( $+functions[compdef] )); then
  _shopd() {
    local project_type
    project_type="$(_shopify_project_type)" || return 1
    words=(shopify "$project_type" dev ${words[2,-1]})
    (( CURRENT += 2 ))
    _shopify
  }

  _shopi() {
    local project_type
    project_type="$(_shopify_project_type)" || return 1
    if [[ "$project_type" == hydrogen ]]; then
      words=(shopify hydrogen list ${words[2,-1]})
    else
      words=(shopify "$project_type" info ${words[2,-1]})
    fi
    (( CURRENT += 2 ))
    _shopify
  }

  compdef _shopd shopd
  compdef _shopi shopi
fi

alias shop='shopify'
