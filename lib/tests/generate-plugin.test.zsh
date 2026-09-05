#!/usr/bin/zsh -df

# Tests for `omz generate plugin`. Run with: zsh lib/tests/generate-plugin.test.zsh

ZSH="${0:A:h:h:h}"
ZSH_CUSTOM="$(mktemp -d)"
trap 'command rm -rf "$ZSH_CUSTOM"' EXIT

source "$ZSH/lib/cli.zsh"

failures=0
pass() { print -u2 "\e[32mSuccess\e[0m: $1" }
fail() { print -u2 "\e[31mError\e[0m: $1"; (( failures++ )) }

# assert_files <plugin> <expected files, space separated>
assert_files() {
  local actual="$(print -l "$ZSH_CUSTOM"/plugins/$1/*(N:t) "$ZSH_CUSTOM"/plugins/$1/_*(N:t) | sort -u | tr '\n' ' ')"
  local expected="$(print -l ${=2} | sort -u | tr '\n' ' ')"
  if [[ "$actual" == "$expected" ]]; then
    pass "$1 has files: $expected"
  else
    fail "$1 has files '$actual', expected '$expected'"
  fi
}

# assert_syntax <plugin>: every generated file must pass zsh -n, like CI does
assert_syntax() {
  local file
  for file in "$ZSH_CUSTOM"/plugins/$1/*.plugin.zsh(N) "$ZSH_CUSTOM"/plugins/$1/_*(N); do
    if zsh -n "$file"; then
      pass "${file:t} passes zsh -n"
    else
      fail "${file:t} fails zsh -n"
    fi
  done
}

# assert_contains <file> <literal string>
assert_contains() {
  if grep -qF -- "$2" "$1"; then
    pass "${1:t} contains '$2'"
  else
    fail "${1:t} does not contain '$2'"
  fi
}

## Templates must be valid zsh even before substitution (CI checks this too)

for file in "$ZSH"/templates/generators/plugin/*.zsh-template; do
  if zsh -n "$file"; then
    pass "template ${file:t} passes zsh -n"
  else
    fail "template ${file:t} fails zsh -n"
  fi
done

## A plugin that wraps a command

description='Shortcuts & stuff $(id) `id` 100%'
if omz generate plugin foo -d "$description" -c foo --yes >/dev/null 2>&1; then
  pass "generates a command-wrapping plugin"
else
  fail "generating a command-wrapping plugin failed"
fi
assert_files foo "README.md _foo foo.plugin.zsh"
assert_syntax foo
assert_contains "$ZSH_CUSTOM/plugins/foo/README.md" 'plugins=(... foo)'
assert_contains "$ZSH_CUSTOM/plugins/foo/README.md" "$description"
assert_contains "$ZSH_CUSTOM/plugins/foo/foo.plugin.zsh" "$description"
assert_contains "$ZSH_CUSTOM/plugins/foo/foo.plugin.zsh" '$+commands[foo]'
assert_contains "$ZSH_CUSTOM/plugins/foo/_foo" '#compdef foo'
if grep -q '%[a-z]*%' "$ZSH_CUSTOM"/plugins/foo/*; then
  fail "foo still has unfilled placeholders"
else
  pass "foo has no unfilled placeholders"
fi

## Values that look like placeholders are written literally

omz generate plugin lit -d '%compgen% and %name% stay' -c lit --yes >/dev/null 2>&1
assert_contains "$ZSH_CUSTOM/plugins/lit/README.md" '%compgen% and %name% stay'
assert_contains "$ZSH_CUSTOM/plugins/lit/lit.plugin.zsh" '%compgen% and %name% stay'

## A plugin with no command

if omz generate plugin bar --yes >/dev/null 2>&1; then
  pass "generates a generic plugin"
else
  fail "generating a generic plugin failed"
fi
assert_files bar "README.md bar.plugin.zsh"
assert_syntax bar
assert_contains "$ZSH_CUSTOM/plugins/bar/README.md" 'This plugin does not add any aliases.'
assert_contains "$ZSH_CUSTOM/plugins/bar/bar.plugin.zsh" 'bar plugin for Oh My Zsh'

## --no-completion, and the rails-style output

output="$(omz generate plugin baz -c baz --no-completion --yes 2>/dev/null)"
assert_files baz "README.md baz.plugin.zsh"
create_lines=$(print -r -- "$output" | grep -c '^      create  ')
if (( create_lines == 3 )); then
  pass "prints one create line per path"
else
  fail "expected 3 create lines, got $create_lines"
fi
if [[ "$output" == *"omz plugin load baz"* ]]; then
  pass "prints next steps"
else
  fail "next steps missing from output"
fi

## Bad names are rejected without touching the filesystem

before="$(print -l "$ZSH_CUSTOM"/plugins/*(N:t))"
for bad in '' 'Foo' 'a b' '../evil' 'a/b' '.hidden' '.' '..' '-x' 'foo`id`' 'foo"$(id)"' $'a\nb' "$(printf 'x%.0s' {1..65})"; do
  if omz generate plugin "$bad" --yes >/dev/null 2>&1; then
    fail "accepted bad name ${(qq)bad}"
  else
    pass "rejected bad name ${(qq)bad}"
  fi
done
after="$(print -l "$ZSH_CUSTOM"/plugins/*(N:t))"
if [[ "$before" == "$after" ]]; then
  pass "bad names created nothing"
else
  fail "bad names changed \$ZSH_CUSTOM/plugins"
fi

## Bad command names are rejected

for bad in 'a b' '../x' 'foo;id' 'foo$(id)'; do
  if omz generate plugin qux -c "$bad" --yes >/dev/null 2>&1; then
    fail "accepted bad command ${(qq)bad}"
  else
    pass "rejected bad command ${(qq)bad}"
  fi
done

## Existing plugin, unknown option, missing templates

if omz generate plugin foo --yes >/dev/null 2>&1; then
  fail "overwrote an existing plugin"
else
  pass "refuses to overwrite an existing plugin"
fi

if omz generate plugin quux --bogus --yes >/dev/null 2>&1; then
  fail "accepted an unknown option"
else
  pass "rejects an unknown option"
fi

if ( ZSH=/nonexistent; omz generate plugin quux --yes >/dev/null 2>&1 ); then
  fail "ran without templates"
else
  pass "fails cleanly when templates are missing"
fi
[[ -e "$ZSH_CUSTOM/plugins/quux" ]] && fail "quux was created by a failed run"

## A failure after the first file is written removes everything it created

broken="$(mktemp -d)"
mkdir -p "$broken/templates/generators/plugin" "$broken/plugins"
cp "$ZSH/templates/generators/plugin/plugin.zsh-template" \
   "$ZSH/templates/generators/plugin/completion-note.zsh-template" "$broken/templates/generators/plugin/"
# README.md-template is missing, so the plugin file is written and then the README fails
if ( ZSH="$broken"; omz generate plugin partial -c partial --yes >/dev/null 2>&1 ); then
  fail "succeeded with a missing README template"
else
  pass "fails when a later template is missing"
fi
if [[ -e "$ZSH_CUSTOM/plugins/partial" ]]; then
  fail "partial plugin directory was left behind: $(ls "$ZSH_CUSTOM/plugins/partial")"
else
  pass "cleans up the partial plugin directory"
fi
command rm -rf "$broken"

## The prompt helper

_omz::generate::plugin::ask "Q" "dflt" 2>/dev/null < <(print '')
[[ "$REPLY" == "dflt" ]] && pass "ask: empty answer takes the default" || fail "ask: got '$REPLY', expected 'dflt'"

_omz::generate::plugin::ask "Q" "dflt" 2>/dev/null < <(print '  hi there  ')
[[ "$REPLY" == "hi there" ]] && pass "ask: trims whitespace" || fail "ask: got '$REPLY', expected 'hi there'"

if _omz::generate::plugin::ask "Q" 2>/dev/null < /dev/null; then
  fail "ask: did not fail on EOF"
else
  pass "ask: fails on EOF"
fi

print -u2
if (( failures )); then
  print -u2 "\e[31m$failures test(s) failed\e[0m"
  exit 1
fi
print -u2 "\e[32mAll tests passed\e[0m"
