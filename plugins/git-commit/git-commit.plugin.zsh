# Add git-commit commands directory to path
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
path=("${0:a:h}/git-commands" $path)

# Append completions for custom git commands
() {
  local -a git_user_commands
  zstyle -a ':completion:*:*:git:*' user-commands 'git_user_commands' \
    || git_user_commands=()
  git_user_commands+=(
    build:'Commit with a message indicating a build' \
    chore:'Commit with a message indicating a chore' \
    ci:'Commit with a message indicating a CI change' \
    docs:'Commit with a message indicating an update to the documentation' \
    feat:'Commit with a message indicating a feature' \
    fix:'Commit with a message indicating a fix' \
    perf:'Commit with a message indicating a performance enhancement' \
    refactor:'Commit with a message indicating a refactor' \
    revert:'Commit with a message indicating a revert' \
    style:'Commit with a message indicating a style change' \
    test:'Commit with a message indicating updates to tests' \
    wip:'Commit with a message indicating a work in progress'
  )
  zstyle ':completion:*:*:git:*' user-commands "${git_user_commands[@]}"
}

########################################################################################
### Remove below after Jan 2025:
########################################################################################
# Clean up aliases from the prior implementation of git-commit. Can be safely removed
# once everyone's .gitconfig has been restored.
() {
  git config --global --get oh-my-zsh.git-commit-alias &> /dev/null || return 0
  local -a old_git_aliases=(
    'build'  'chore'     'ci'
    'docs'   'feat'      'fix'
    'perf'   'refactor'  'rev'
    'style'  'test'      'wip'
  )
  local git_alias
  for git_alias in $old_git_aliases; do
    if [[ "$(git config --global --get alias.$git_alias | tr '\n' ' ')" == "!a() { local _scope _attention _message"* ]]; then
      git config --global --unset alias.$git_alias
    fi
  done
  git config --global --unset oh-my-zsh.git-commit-alias
}
