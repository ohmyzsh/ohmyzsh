#compdef hub

# Zsh will source this file when attempting to autoload the "_hub" function,
# typically on the first attempt to complete the hub command.  We define two new
# setup helper routines (one for the zsh-distributed version, one for the
# git-distributed, bash-based version).  Then we redefine the "_hub" function to
# call "_git" after some other interception.
#
# This is pretty fragile, if you think about it.  Any number of implementation
# changes in the "_git" scripts could cause problems down the road.  It would be
# better if the stock git completions were just a bit more permissive about how
# it allowed third-party commands to be added.

(( $+functions[__hub_setup_zsh_fns] )) ||
__hub_setup_zsh_fns () {
  (( $+functions[_git-alias] )) ||
  _git-alias () {
    _arguments \
      '-s[output shell script suitable for eval]' \
      '1::shell:(zsh bash csh)'
  }

  (( $+functions[_git-browse] )) ||
  _git-browse () {
    _arguments \
      '-u[output the URL]' \
      '2::subpage:(wiki commits issues)'
  }

  (( $+functions[_git-compare] )) ||
  _git-compare () {
    _arguments \
      '-u[output the URL]' \
      ':[start...]end range:'
  }

  (( $+functions[_git-create] )) ||
  _git-create () {
    _arguments \
      '::name (REPOSITORY or ORGANIZATION/REPOSITORY):' \
      '-p[make repository private]' \
      '-d[description]:description' \
      '-h[home page]:repository home page URL:_urls'
  }

  (( $+functions[_git-fork] )) ||
  _git-fork () {
    _arguments \
      '--no-remote[do not add a remote for the new fork]'
  }

  (( $+functions[_git-pull-request] )) ||
  _git-pull-request () {
    _arguments \
      '-f[force (skip check for local commits)]' \
      '-b[base]:base ("branch", "owner\:branch", "owner/repo\:branch"):' \
      '-h[head]:head ("branch", "owner\:branch", "owner/repo\:branch"):' \
      - set1 \
        '-m[message]' \
        '-F[file]' \
        '-a[user]' \
        '-M[milestone]' \
        '-l[labels]' \
      - set2 \
        '-i[issue]:issue number:' \
      - set3 \
        '::issue-url:_urls'
  }

  # stash the "real" command for later
  functions[_hub_orig_git_commands]=$functions[_git_commands]

  # Replace it with our own wrapper.
  declare -f _git_commands >& /dev/null && unfunction _git_commands
  _git_commands () {
    local ret=1
    # call the original routine
    _call_function ret _hub_orig_git_commands

    # Effectively "append" our hub commands to the behavior of the original
    # _git_commands function.  Using this wrapper function approach ensures
    # that we only offer the user the hub subcommands when the user is
    # actually trying to complete subcommands.
    hub_commands=(
      alias:'show shell instructions for wrapping git'
      pull-request:'open a pull request on GitHub'
      fork:'fork origin repo on GitHub'
      create:'create new repo on GitHub for the current project'
      browse:'browse the project on GitHub'
      compare:'open GitHub compare view'
      ci-status:'lookup commit in GitHub Status API'
      sync:'update local branches from upstream'
    )
    _describe -t hub-commands 'hub command' hub_commands && ret=0

    return ret
  }
}

(( $+functions[__hub_setup_bash_fns] )) ||
__hub_setup_bash_fns () {
  # TODO more bash-style fns needed here to complete subcommand args.  They take
  # the form "_git_CMD" where "CMD" is something like "pull-request".

  # Duplicate and rename the 'list_all_commands' function
  eval "$(declare -f __git_list_all_commands | \
        sed 's/__git_list_all_commands/__git_list_all_commands_without_hub/')"

  # Wrap the 'list_all_commands' function with extra hub commands
  __git_list_all_commands() {
    cat <<-EOF
alias
pull-request
fork
create
browse
compare
ci-status
sync
EOF
    __git_list_all_commands_without_hub
  }

  # Ensure cached commands are cleared
  __git_all_commands=""
}

# redefine _hub to a much smaller function in the steady state
_hub () {
  # only attempt to intercept the normal "_git" helper functions once
  (( $+__hub_func_replacement_done )) ||
    () {
      # At this stage in the shell's execution the "_git" function has not yet
      # been autoloaded, so the "_git_commands" or "__git_list_all_commands"
      # functions will not be defined.  Call it now (with a bogus no-op service
      # to prevent premature completion) so that we can wrap them.
      if declare -f _git >& /dev/null ; then
        _hub_noop () { __hub_zsh_provided=1 }       # zsh-provided will call this one
        __hub_noop_main () { __hub_git_provided=1 } # git-provided will call this one
        local service=hub_noop
        _git
        unfunction _hub_noop
        unfunction __hub_noop_main
        service=git
      fi

      if (( $__hub_zsh_provided )) ; then
        __hub_setup_zsh_fns
      elif (( $__hub_git_provided )) ; then
        __hub_setup_bash_fns
      fi

      __hub_func_replacement_done=1
    }

  # Now perform the actual completion, allowing the "_git" function to call our
  # replacement "_git_commands" function as needed.  Both versions expect
  # service=git or they will call nonexistent routines or end up in an infinite
  # loop.
  service=git
  declare -f _git >& /dev/null && _git
}

# make sure we actually attempt to complete on the first "tab" from the user
_hub
