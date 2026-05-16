#!/usr/bin/zsh -df

run_awk() {
  local -a dis_plugins=(${=1})
  local input_text="$2"

  (( ! DEBUG )) || set -xv

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

  command awk "$awk_script" <<< "$input_text"

  (( ! DEBUG )) || set +xv
}

# runs awk against stdin, checks if the resulting file is not empty and then checks if the file has valid zsh syntax
run_awk_and_test() {
  local description="$1"
  local plugins_to_disable="$2"
  local input_text="$3"
  local expected_output="$4"

  local tmpfile==(:)

  {
    print -u2 "Test: $description"
    DEBUG=0 run_awk "$plugins_to_disable" "$input_text" >| $tmpfile

    if [[ ! -s "$tmpfile" ]]; then
      print -u2 "\e[31mError\e[0m: output file empty"
      return 1
    fi

    if ! zsh -n $tmpfile; then
      print -u2 "\e[31mError\e[0m: zsh syntax error"
      diff -u $tmpfile <(echo "$expected_output")
      return 1
    fi

    if ! diff -u --color=always $tmpfile <(echo "$expected_output"); then
      if (( DEBUG )); then
        print -u2 ""
        DEBUG=1 run_awk "$plugins_to_disable" "$input_text"
        print -u2 ""
      fi
      print -u2 "\e[31mError\e[0m: output file does not match expected output"
      return 1
    fi

    print -u2 "\e[32mSuccess\e[0m"
  } always {
    print -u2 ""
    command rm -f "$tmpfile"
  }
}

# These tests are for the `omz plugin disable` command
run_awk_and_test \
  "it should delete a single plugin in oneline format" \
  "git" \
  "plugins=(git)" \
  "plugins=()"

run_awk_and_test \
  "it should delete a single plugin in multiline format" \
  "github" \
"plugins=(
  github
)" \
"plugins=(
)"

run_awk_and_test \
  "it should delete multiple plugins in oneline format" \
  "github git z" \
  "plugins=(github git z)" \
  "plugins=()"

run_awk_and_test \
  "it should delete multiple plugins in multiline format" \
  "github git z" \
"plugins=(
  github
  git
  z
)" \
"plugins=(
)"

run_awk_and_test \
  "it should delete a single plugin among multiple in oneline format" \
  "git" \
  "plugins=(github git z)" \
  "plugins=(github z)"

run_awk_and_test \
  "it should delete a single plugin among multiple in multiline format" \
  "git" \
"plugins=(
  github
  git
  z
)" \
"plugins=(
  github
  z
)"

run_awk_and_test \
  "it should delete multiple plugins in mixed format" \
  "git z" \
"plugins=(github
git z)" \
"plugins=(github
)"

run_awk_and_test \
  "it should delete multiple plugins in mixed format 2" \
  "github z" \
"plugins=(github
  git
z)" \
"plugins=(
  git
)"
