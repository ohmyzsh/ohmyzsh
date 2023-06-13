#!/usr/bin/env zunit

@setup {
  load ../alias-finder.plugin.zsh
}

@test 'default:find alias when input and alias are same' {
  run unalias -a
  alias glgm='git log --graph --max-count=10'

  run alias-finder "git log --graph --max-count=10"

  assert "${#lines[@]}" equals 1
}

@test 'exact:find alias when partial input is in alias list' {
  run unalias -a
  alias g='git'
  alias glgm='git log --graph --max-count=10'

  run alias-finder "git log --graph --max-count=10"

  assert "${#lines[@]}" equals 2
}

@test 'exact:find only exact alias when e option is given' {
  run unalias -a
  alias g='git'
  alias glgm='git log --graph --max-count=10'

  run alias-finder -e "git log --graph --max-count=10"

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "glgm='git log --graph --max-count=10'"
}

@test 'longer:find alias not longer than input' {
  run unalias -a
  alias g='git'
  alias glgm='git log --graph --max-count=10'

  run alias-finder git log

  assert "${#lines[@]}" equals 1
  assert "${lines[1]}" same_as "g=git"
}

@test 'longer:find alias longer than input when l option is given' {
  run unalias -a
  alias g='git'
  alias glgm='git log --graph --max-count=10'

  run alias-finder -l git log

  assert "${#lines[@]}" equals 2
}
