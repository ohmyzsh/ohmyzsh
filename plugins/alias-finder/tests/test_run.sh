#!/usr/bin/env zunit

@setup {
  load ../alias-finder.plugin.zsh

  set_git_aliases() {
    unalias -a # all
    alias g="git"
    alias gc="git commit"
    alias gcv="git commit -v"
    alias gcvs="git commit -v -S"
  }
}

@test 'find aliases that contain input' {
  set_git_aliases

  run alias-finder "git"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "g=git"
}

@test 'find aliases that contain input with whitespaces at ends' {
  set_git_aliases

  run alias-finder "   git     "

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "g=git"
}

@test 'find aliases that contain multiple words' {
  set_git_aliases

  run alias-finder "git commit -v"

  assert "${#lines[@]}" equals 3
  assert "${lines[1]}" same_as "gcv='git commit -v'"
  assert "${lines[2]}" same_as "gc='git commit'"
  assert "${lines[3]}" same_as "g=git"
}

@test 'find aliases when the command starts with another alias' {
  set_git_aliases

  run alias-finder "g commit -v"

  assert "${#lines[@]}" equals 3
  assert "${lines[1]}" same_as "gcv='git commit -v'"
  assert "${lines[2]}" same_as "gc='git commit'"
  assert "${lines[3]}" same_as "g=git"
}

@test 'expand chained aliases' {
  set_git_aliases
  alias gg=g

  run alias-finder -e "gg commit -v"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "gcv='git commit -v'"
}

@test 'find aliases when the leading alias has a trailing space' {
  unalias -a
  alias k='kubectl '
  alias kgp='kubectl get pods'

  run alias-finder -e "k get pods"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "kgp='kubectl get pods'"
}

@test 'find alias that is the same with input when --exact option is set' {
  set_git_aliases

  run alias-finder -e "git"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "g=git"
}

@test 'find alias that is the same with multiple words input when --exact option is set' {
  set_git_aliases

  run alias-finder -e "git commit -v"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "gcv='git commit -v'"
}

@test 'find alias that is the same with or longer than input when --longer option is set' {
  set_git_aliases

  run alias-finder -l "git"

  assert "${#lines[@]}" equals 4
  assert "${lines[1]}" same_as "g=git"
  assert "${lines[2]}" same_as "gc='git commit'"
  assert "${lines[3]}" same_as "gcv='git commit -v'"
  assert "${lines[4]}" same_as "gcvs='git commit -v -S'"
}

@test 'find alias that is the same with or longer than multiple words input when --longer option is set' {
  set_git_aliases

  run alias-finder -l "git commit -v"

  assert "${#lines[@]}" equals 2
  assert "${lines[1]}" same_as "gcv='git commit -v'"
  assert "${lines[2]}" same_as "gcvs='git commit -v -S'"
}

@test 'find aliases including expensive (longer) than input' {
  set_git_aliases
  alias expensiveCommands="git commit"

  run alias-finder "git commit -v"

  assert "${#lines[@]}" equals 4
  assert "${lines[1]}" same_as "gcv='git commit -v'"
  assert "${lines[2]}" same_as "expensiveCommands='git commit'"
  assert "${lines[3]}" same_as "gc='git commit'"
  assert "${lines[4]}" same_as "g=git"
}

@test 'find aliases excluding expensive (longer) than input when --cheap option is set' {
  set_git_aliases
  alias expensiveCommands="git commit"

  run alias-finder -c "git commit -v"

  assert "${#lines[@]}" equals 3
  assert "${lines[1]}" same_as "gcv='git commit -v'"
  assert "${lines[2]}" same_as "gc='git commit'"
  assert "${lines[3]}" same_as "g=git"
}

@test 'compare alias length with the typed command when --cheap is set' {
  unalias -a
  alias k=kubectl
  alias kgp='kubectl get pods'

  run alias-finder -c "k get pods"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "kgp='kubectl get pods'"
}
