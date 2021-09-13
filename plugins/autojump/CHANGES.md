## Summary of release changes, see commit history for more details:
## https://github.com/wting/autojump/commits/master/

### Release v22.4.0:
- minor zsh performance improvement

### Release v22.3.0:
- use colors only if stdout is a terminal
- updated RedHat docs
- misc bug fixes for fish and Clink versions

### Release v22.2.2:

#### Backwards Incompatible

- install.sh -> install.py
    - `--auto` option removed
    - `--local` option removed, defaults to local user install
    - `--global` option renamed to `--system`
    - install.py modifies autojump.sh accordingly for custom installations
    - it is recommended that maintainers use install.py with `--destdir` and
      `--prefix` accordingly. Two stage installations requires manually updating
      autojump.sh.
- uninstall.sh -> uninstall.py
    - automatically removes user and system installations
    - now removes custom installations cleanly when passed appropriate
      `--destdir` and/or `--prefix` options.
    - new `--userdata` option to remove autojump database
- all user environmental options removed:
    - AUTOJUMP_DATA_DIR
    - AUTOJUMP_IGNORE_CASE
    - AUTOJUMP_KEEP_SYMLINKS
- misc bug fixes

#### Features and Bug Fixes

- fish shell support added
- defaults to smartcasing
    - If any uppercase characters are detected, then search is case sensitive.
      Otherwise searches default to case insensitive.
- defaults to symlinks
    - symlinks are not resolved to real path and thus results in duplicate
      database entries but ensuring that short paths will be used
- autojump now uses ~/Library/autojump for storing data on OS X instead of
  incorrectly using Linux's $XDG_DATA_HOME. Existing data should automatically
  be migrated to the new location.
- Past behavior jumped to the highest weight database entry when not passed any
  arguments. The new behavior is to stay in the current directory.


### Release v21.6.8:

- fix --increase and --decrease options
- heavy refactoring
- remove unused unit tests

### Release v21.5.8:

- fix security bug: http://www.openwall.com/lists/oss-security/2013/04/25/14
- minor documentation updates, optimization performances, bug fixes

### Release v21.5.1:

- add options to manually increase or decrease weight of the current directory
  with --increase or --decrease
- add `_j` back, necessary for zsh tab completion

### Release v21.4.2:

- add options to open file explorer windows with `jo`, `jco` which maps to jump
  open, jump child open.
- remove `_j`

### Release v21.3.0:

- `jumpapplet` removed.
- performance improvements when using network mounts (e.g. sshfs)

### Release v21.2.0:

- Add `jc` command (jump child). Jumps to a subdirectory of the current working
  directory.

### Release v21.1.0:

- install.sh is rewritten to add support for --path and --destdir options,
  making it easier for package maintainers to install autojump specifically into
  certain locations. Thanks to jjk-jacky for his contributions.

### Release v21.0.0:

- Switch to semantic versioning (http://semver.org/): major.minor.micro
- Migration code for v17 or older users has been removed.

    During testing, it was apparent that the migration code wasn't working to
    begin with. The major distros (Debian, RedHat) have already moved to v18+
    for LTS. Rolling release distros and Homebrew / Macports are regularly kept
    up to date.

    Users upgrading from v17 or older will start with a new database.

- Approximate matching introduced. Matching priority is now:

    1. exact match
    2. case insensitive match
    3. approximate match

- The `j` function now accepts autojump arguments (e.g. --help, --stat).

    As a result, the `jumpstat` alias is now removed. The preferred method is `j
    --stat` or `j -s`. Consequently, autojump cannot jump to directories
    beginning with a hyphen '-'.

- Always use case insensitive search with AUTOJUMP_IGNORE_CASE=1

    As mentioned earlier, normal priority is to prefer exact match and then
    check for case insensitive match. For users who prefer case insensitivity
    can now modify the program behavior.

- Prevent database decay with AUTOJUMP_KEEP_ALL_ENTRIES=1

    The database is regularly trimmed for performance reasons. However users can
    prevent database maintenance with the above environmental variable.

- ZSH tab completion fixed.

    ZSH behavior now matches Bash behavior. However it requires the `compinit`
    module to be loaded. Add the following line to ~/.zshrc:

    autoload -U compinit; compinit

    To use type:

    j<space><tab><tab>

    A menu showing the top database entries will be displayed. Type in any
    number followed by <tab> to complete the entry.

- Database entry weight growth changed form linear to logarithmic scale.

    A combination of low total weight ceiling and linear growth resulted in a
    few, commonly used directories to be responsible for 50%+ of the total
    database weight. This caused unnecessary trimming of long tail entries.

    Switching to logarithmic growth combined with regular decay meant that
    commonly used directories still climbed database ranking appropriately with
    a more even weight distribution.

- Vendorize argparse so now Python v2.6+ is supported (from v2.7).
- Unit testing suite added.
- Miscellaneous refactoring, bug fixes, documentation updates.

### Release v20.0.0:

- Python versions supported is now v2.7+ and v3.2+ due to rewrite using
  argparse.

- Man page and --help has been overhauled to provide better documentation and
  usage scenarios.

- Installation scripts now act dependent on current environmental settings.

    If run as root, will do a global install. Installation script also detects
    which version to install (bash or zsh) dependent on $SHELL.  Both of these
    behaviors can be overrode using --local/--global or --bash/--zsh arguments.

- Uninstallation script added, will remove both global and local installations
  but ignores database.

- Allow symlink database entries with AUTOJUMP_KEEP_SYMLINKS=1

    Normally symlinks are resolved to full path to prevent duplicate database
    entries. However users who prefer symlink paths can modify behavior with the
    above environmental variable.

- This ChangeLog added to better help package maintainers keep track of changes
  between releases.

- Miscellaneous bug fixes.

### Release v19.0.0:

- prototype `cp` and `mv` directory tab completion
- Debian post-installation instructions
- minor Mac OS X fixes

### Release v18.0.0:

- add automated version numbering
- performance tweaks to reduce filesystem checks
- add local installation option
- unicode fixes
- ugly fixes for Python 3
- migrate to new database format
