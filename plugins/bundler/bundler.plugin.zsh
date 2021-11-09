## Aliases

alias ba="bundle add"
alias bck="bundle check"
alias bcn="bundle clean"
alias be="bundle exec"
alias bi="bundle_install"
alias bl="bundle list"
alias bo="bundle open"
alias bout="bundle outdated"
alias bp="bundle package"
alias bu="bundle update"

## Functions

bundle_install() {
  # Bail out if bundler is not installed
  if (( ! $+commands[bundle] )); then
    echo "Bundler is not installed"
    return 1
  fi

  # Bail out if not in a bundled project
  if ! _within-bundled-project; then
    echo "Can't 'bundle install' outside a bundled project"
    return 1
  fi

  # Check the bundler version is at least 1.4.0
  autoload -Uz is-at-least
  local bundler_version=$(bundle version | cut -d' ' -f3)
  if ! is-at-least 1.4.0 "$bundler_version"; then
    bundle install "$@"
    return $?
  fi

  # If bundler is at least 1.4.0, use all the CPU cores to bundle install
  if [[ "$OSTYPE" = (darwin|freebsd)* ]]; then
    local cores_num="$(sysctl -n hw.ncpu)"
  else
    local cores_num="$(nproc)"
  fi
  BUNDLE_JOBS="$cores_num" bundle install "$@"
}

## Gem wrapper

bundled_commands=(
  annotate
  cap
  capify
  cucumber
  foodcritic
  guard
  hanami
  irb
  jekyll
  kitchen
  knife
  middleman
  nanoc
  pry
  puma
  rackup
  rainbows
  rake
  rspec
  rubocop
  shotgun
  sidekiq
  spec
  spork
  spring
  strainer
  tailor
  taps
  thin
  thor
  unicorn
  unicorn_rails
)

# Remove $UNBUNDLED_COMMANDS from the bundled_commands list
bundled_commands=(${bundled_commands:|UNBUNDLED_COMMANDS})
unset UNBUNDLED_COMMANDS

# Add $BUNDLED_COMMANDS to the bundled_commands list
bundled_commands+=($BUNDLED_COMMANDS)
unset BUNDLED_COMMANDS

# Check if in the root or a subdirectory of a bundled project
_within-bundled-project() {
  local check_dir="$PWD"
  while [[ "$check_dir" != "/" ]]; do
    if [[ -f "$check_dir/Gemfile" || -f "$check_dir/gems.rb" ]]; then
      return 0
    fi
    check_dir="${check_dir:h}"
  done
  return 1
}

_run-with-bundler() {
  if (( ! $+commands[bundle] )) || ! _within-bundled-project; then
    "$@"
    return $?
  fi

  if [[ -f "./bin/${1}" ]]; then
    ./bin/${^^@}
  else
    bundle exec "$@"
  fi
}

for cmd in $bundled_commands; do
  # Create wrappers for bundled and unbundled execution
  eval "function unbundled_$cmd () { \"$cmd\" \"\$@\"; }"
  eval "function bundled_$cmd () { _run-with-bundler \"$cmd\" \"\$@\"; }"
  alias "$cmd"="bundled_$cmd"

  # Bind completion function to wrapped gem if available
  if (( $+functions[_$cmd] )); then
    compdef "_$cmd" "bundled_$cmd"="$cmd"
  fi
done
unset cmd bundled_commands
