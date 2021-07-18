#compdef _chezmoi chezmoi


function _chezmoi {
  local -a commands

  _arguments -C \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    "1: :->cmnds" \
    "*::arg:->args"

  case $state in
  cmnds)
    commands=(
      "add:Add an existing file, directory, or symlink to the source state"
      "apply:Update the destination directory to match the target state"
      "archive:Write a tar archive of the target state to stdout"
      "cat:Print the target contents of a file or symlink"
      "cd:Launch a shell in the source directory"
      "chattr:Change the attributes of a target in the source state"
      "completion:Write shell completion code for the specified shell (bash, fish, or zsh) to stdout"
      "data:Print the template data"
      "diff:Print the diff between the target state and the destination state"
      "docs:Print documentation"
      "doctor:Check your system for potential problems"
      "dump:Write a dump of the target state to stdout"
      "edit:Edit the source state of a target"
      "edit-config:Edit the configuration file"
      "execute-template:Write the result of executing the given template(s) to stdout"
      "forget:Remove a target from the source state"
      "git:Run git in the source directory"
      "help:Print help about a command"
      "hg:Run mercurial in the source directory"
      "import:Import a tar archive into the source state"
      "init:Setup the source directory and update the destination directory to match the target state"
      "managed:List the managed files in the destination directory"
      "merge:Perform a three-way merge between the destination state, the source state, and the target state"
      "purge:Purge all of chezmoi's configuration and data"
      "remove:Remove a target from the source state and the destination directory"
      "secret:Interact with a secret manager"
      "source:Run the source version control system command in the source directory"
      "source-path:Print the path of a target in the source state"
      "unmanaged:List the unmanaged files in the destination directory"
      "update:Pull changes from the source VCS and apply any changes"
      "upgrade:Upgrade chezmoi"
      "verify:Exit with success if the destination state matches the target state, fail otherwise"
    )
    _describe "command" commands
    ;;
  esac

  case "$words[1]" in
  add)
    _chezmoi_add
    ;;
  apply)
    _chezmoi_apply
    ;;
  archive)
    _chezmoi_archive
    ;;
  cat)
    _chezmoi_cat
    ;;
  cd)
    _chezmoi_cd
    ;;
  chattr)
    _chezmoi_chattr
    ;;
  completion)
    _chezmoi_completion
    ;;
  data)
    _chezmoi_data
    ;;
  diff)
    _chezmoi_diff
    ;;
  docs)
    _chezmoi_docs
    ;;
  doctor)
    _chezmoi_doctor
    ;;
  dump)
    _chezmoi_dump
    ;;
  edit)
    _chezmoi_edit
    ;;
  edit-config)
    _chezmoi_edit-config
    ;;
  execute-template)
    _chezmoi_execute-template
    ;;
  forget)
    _chezmoi_forget
    ;;
  git)
    _chezmoi_git
    ;;
  help)
    _chezmoi_help
    ;;
  hg)
    _chezmoi_hg
    ;;
  import)
    _chezmoi_import
    ;;
  init)
    _chezmoi_init
    ;;
  managed)
    _chezmoi_managed
    ;;
  merge)
    _chezmoi_merge
    ;;
  purge)
    _chezmoi_purge
    ;;
  remove)
    _chezmoi_remove
    ;;
  secret)
    _chezmoi_secret
    ;;
  source)
    _chezmoi_source
    ;;
  source-path)
    _chezmoi_source-path
    ;;
  unmanaged)
    _chezmoi_unmanaged
    ;;
  update)
    _chezmoi_update
    ;;
  upgrade)
    _chezmoi_upgrade
    ;;
  verify)
    _chezmoi_verify
    ;;
  esac
}

function _chezmoi_add {
  _arguments \
    '(-a --autotemplate)'{-a,--autotemplate}'[auto generate the template when adding files as templates]' \
    '(-e --empty)'{-e,--empty}'[add empty files]' \
    '--encrypt[encrypt files]' \
    '(-x --exact)'{-x,--exact}'[add directories exactly]' \
    '(-f --force)'{-f,--force}'[overwrite source state, even if template would be lost]' \
    '(-p --prompt)'{-p,--prompt}'[prompt before adding]' \
    '(-r --recursive)'{-r,--recursive}'[recurse in to subdirectories]' \
    '(-T --template)'{-T,--template}'[add files as templates]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_apply {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_archive {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_cat {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_cd {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_chattr {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :("empty" "-empty" "+empty" "noempty" "e" "-e" "+e" "noe" "encrypt" "-encrypt" "+encrypt" "noencrypt" "exact" "-exact" "+exact" "noexact" "executable" "-executable" "+executable" "noexecutable" "x" "-x" "+x" "nox" "private" "-private" "+private" "noprivate" "p" "-p" "+p" "nop" "template" "-template" "+template" "notemplate" "t" "-t" "+t" "not")' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files ' \
    '9: :_files '
}

function _chezmoi_completion {
  _arguments \
    '(-h --help)'{-h,--help}'[help for completion]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :("bash" "fish" "zsh")'
}

function _chezmoi_data {
  _arguments \
    '(-f --format)'{-f,--format}'[format (JSON, TOML, or YAML)]:' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_diff {
  _arguments \
    '(-f --format)'{-f,--format}'[format, "chezmoi" or "git"]:' \
    '--no-pager[disable pager]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_docs {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_doctor {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_dump {
  _arguments \
    '(-f --format)'{-f,--format}'[format (JSON, TOML, or YAML)]:' \
    '(-r --recursive)'{-r,--recursive}'[recursive]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_edit {
  _arguments \
    '(-a --apply)'{-a,--apply}'[apply edit after editing]' \
    '(-d --diff)'{-d,--diff}'[print diff after editing]' \
    '(-p --prompt)'{-p,--prompt}'[prompt before applying (implies --diff)]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_edit-config {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_execute-template {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_forget {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_git {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_help {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_hg {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_import {
  _arguments \
    '(-x --exact)'{-x,--exact}'[import directories exactly]' \
    '(-r --remove-destination)'{-r,--remove-destination}'[remove destination before import]' \
    '--strip-components[strip components]:' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files -g "*.tar" -g "*.tar.bz2" -g "*.tar.gz" -g "*.tgz"'
}

function _chezmoi_init {
  _arguments \
    '--apply[update destination directory]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_managed {
  _arguments \
    '(*-i *--include)'{\*-i,\*--include}'[include]:' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_merge {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_purge {
  _arguments \
    '(-f --force)'{-f,--force}'[remove without prompting]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_remove {
  _arguments \
    '(-f --force)'{-f,--force}'[remove without prompting]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}


function _chezmoi_secret {
  local -a commands

  _arguments -C \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    "1: :->cmnds" \
    "*::arg:->args"

  case $state in
  cmnds)
    commands=(
      "bitwarden:Execute the Bitwarden CLI (bw)"
      "generic:Execute a generic secret command"
      "gopass:Execute the gopass CLI"
      "keepassxc:Execute the KeePassXC CLI (keepassxc-cli)"
      "keyring:Interact with keyring"
      "lastpass:Execute the LastPass CLI (lpass)"
      "onepassword:Execute the 1Password CLI (op)"
      "pass:Execute the pass CLI"
      "vault:Execute the Hashicorp Vault CLI (vault)"
    )
    _describe "command" commands
    ;;
  esac

  case "$words[1]" in
  bitwarden)
    _chezmoi_secret_bitwarden
    ;;
  generic)
    _chezmoi_secret_generic
    ;;
  gopass)
    _chezmoi_secret_gopass
    ;;
  keepassxc)
    _chezmoi_secret_keepassxc
    ;;
  keyring)
    _chezmoi_secret_keyring
    ;;
  lastpass)
    _chezmoi_secret_lastpass
    ;;
  onepassword)
    _chezmoi_secret_onepassword
    ;;
  pass)
    _chezmoi_secret_pass
    ;;
  vault)
    _chezmoi_secret_vault
    ;;
  esac
}

function _chezmoi_secret_bitwarden {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_generic {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_gopass {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_keepassxc {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}


function _chezmoi_secret_keyring {
  local -a commands

  _arguments -C \
    '--service[service]:' \
    '--user[user]:' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    "1: :->cmnds" \
    "*::arg:->args"

  case $state in
  cmnds)
    commands=(
      "get:Get a password from keyring"
      "set:Set a password in keyring"
    )
    _describe "command" commands
    ;;
  esac

  case "$words[1]" in
  get)
    _chezmoi_secret_keyring_get
    ;;
  set)
    _chezmoi_secret_keyring_set
    ;;
  esac
}

function _chezmoi_secret_keyring_get {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '--service[service]:' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '--user[user]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_keyring_set {
  _arguments \
    '--password[password]:' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '--service[service]:' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '--user[user]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_lastpass {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_onepassword {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_pass {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_secret_vault {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_source {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_source-path {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

function _chezmoi_unmanaged {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_update {
  _arguments \
    '(-a --apply)'{-a,--apply}'[apply after pulling]' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_upgrade {
  _arguments \
    '(-f --force)'{-f,--force}'[force upgrade]' \
    '(-m --method)'{-m,--method}'[set method]:' \
    '(-o --owner)'{-o,--owner}'[set owner]:' \
    '(-r --repo)'{-r,--repo}'[set repo]:' \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]'
}

function _chezmoi_verify {
  _arguments \
    '--color[colorize diffs]:' \
    '(-c --config)'{-c,--config}'[config file]:' \
    '--debug[write debug logs]' \
    '(-D --destination)'{-D,--destination}'[destination directory]:' \
    '(-n --dry-run)'{-n,--dry-run}'[dry run]' \
    '--follow[follow symlinks]' \
    '--remove[remove targets]' \
    '(-S --source)'{-S,--source}'[source directory]:' \
    '(-v --verbose)'{-v,--verbose}'[verbose]' \
    '1: :_files ' \
    '2: :_files ' \
    '3: :_files ' \
    '4: :_files ' \
    '5: :_files ' \
    '6: :_files ' \
    '7: :_files ' \
    '8: :_files '
}

