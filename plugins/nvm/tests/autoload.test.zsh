#!/usr/bin/env zsh

emulate -LR zsh

plugin=${1:-${0:A:h:h}/nvm.plugin.zsh}
plugin=${plugin:A}
test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT

export NVM_DIR="$test_dir/nvm" NVM_TEST_CALLS="$test_dir/calls"
mkdir -p "$NVM_DIR/alias" "$test_dir/project/nested" "$test_dir/outside" "$test_dir/system"
for version in v1.2.3 v2.0.0; do
  mkdir -p "$NVM_DIR/versions/node/$version/bin"
  print -r -- "#!/bin/sh
printf '%s\\n' '$version'" > "$NVM_DIR/versions/node/$version/bin/node"
  chmod +x "$NVM_DIR/versions/node/$version/bin/node"
done
print -r -- '#!/bin/sh
printf "%s\n" v1.2.3' > "$test_dir/system/node"
chmod +x "$test_dir/system/node"

# Record resolver calls, including those made in command substitutions.
cat > "$NVM_DIR/nvm.sh" <<'EOF'
nvm_find_nvmrc() {
  local dir=$PWD
  while [[ $dir != / ]]; do
    [[ -f $dir/.nvmrc ]] && { print -r -- "$dir/.nvmrc"; return; }
    dir=${dir:h}
  done
}
nvm() {
  print -r -- "$*" >> "$NVM_TEST_CALLS"
  local target=${2:-current}
  case $1 in
    version)
      [[ $target == current ]] && { command node --version; return; }
      [[ -f $NVM_DIR/alias/$target ]] && target=$(<"$NVM_DIR/alias/$target")
      case $target in
        default|1|1.2|1.2.3) target=v1.2.3 ;;
      esac
      [[ -x $NVM_DIR/versions/node/$target/bin/node ]] && print -r -- "$target" || print N/A
      ;;
    use)
      if [[ $target == --silent ]]; then
        target=$(nvm version "$(<"$(nvm_find_nvmrc)")")
      else
        target=$(nvm version "$target")
      fi
      path=("$NVM_DIR/versions/node/$target/bin" ${path:#$NVM_DIR/versions/node/*/bin})
      ;;
    install) return 1 ;;
  esac
}
EOF

path=("$NVM_DIR/versions/node/v1.2.3/bin" $path)
builtin cd -q "$test_dir/outside"
compdef() { :; }
zstyle ':omz:plugins:nvm' autoload yes
zstyle ':omz:plugins:nvm' silent-autoload yes
source "$plugin"

typeset -i failures=0 tests=0
check() {
  local description=$1
  shift
  (( tests++ ))
  if "$@"; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    (( failures++ ))
  fi
}
has_call() { [[ "$(<"$NVM_TEST_CALLS")" == *"$1"* ]]; }
reset_calls() { : > "$NVM_TEST_CALLS"; }

print -r -- v1.2.3 > "$test_dir/project/.nvmrc"
reset_calls
builtin cd "$test_dir/project/nested"
check 'matching exact version in parent skips resolver' test ! -s "$NVM_TEST_CALLS"
check 'matching version stays selected' test "$(command node --version)" = v1.2.3

print -r -- v2.0.0 > "$test_dir/project/.nvmrc"
reset_calls
load-nvmrc
check 'editing version file switches runtime' test "$(command node --version)" = v2.0.0
check 'switch calls nvm use' has_call 'use --silent'

reset_calls
load-nvmrc
check 'newly selected exact version skips resolver on repeat' test ! -s "$NVM_TEST_CALLS"

reset_calls
builtin cd "$test_dir/outside"
check 'leaving project restores default' test "$(command node --version)" = v1.2.3
check 'default restoration uses nvm' has_call 'use default --silent'

builtin cd -q "$test_dir/project"
for requested in default 1 1.2 1.2.3 $'v1.2.3\r'; do
  print -r -- "$requested" > .nvmrc
  reset_calls
  load-nvmrc
  check "resolver retained for ${(qqq)requested}" has_call 'version '
done

print -r -- v1.2.3 > .nvmrc
print -r -- v2.0.0 > "$NVM_DIR/alias/v1.2.3"
reset_calls
load-nvmrc
check 'numeric alias overrides apparent exact version' test "$(command node --version)" = v2.0.0
rm "$NVM_DIR/alias/v1.2.3"
nvm use default --silent

path=("$test_dir/system" $path)
reset_calls
load-nvmrc
check 'same-version system executable still uses resolver' has_call 'version v1.2.3'
path=(${path:#$test_dir/system})

node() { command node "$@"; }
reset_calls
load-nvmrc
check 'node function retains resolver' has_call 'version v1.2.3'
unfunction node

alias node='command node'
reset_calls
load-nvmrc
check 'node alias retains resolver' has_call 'version v1.2.3'
unalias node

print -r -- '#!/bin/sh
printf "%s\n" v2.0.0' > "$NVM_DIR/versions/node/v1.2.3/bin/node"
reset_calls
load-nvmrc
check 'executable version mismatch retains resolver' has_call 'version v1.2.3'

print -r -- '#!/bin/sh
printf "%s\n" v1.2.3' > "$NVM_DIR/versions/node/v1.2.3/bin/node"
chmod -x "$NVM_DIR/versions/node/v1.2.3/bin/node"
reset_calls
load-nvmrc
check 'non-executable runtime keeps install path' has_call install
chmod +x "$NVM_DIR/versions/node/v1.2.3/bin/node"

print -r -- v99.0.0 > .nvmrc
reset_calls
load-nvmrc
check 'missing version keeps install path' has_call install

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
