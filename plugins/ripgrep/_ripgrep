#compdef rg

##
# zsh completion function for ripgrep
#
# Run ci/test-complete after building to ensure that the options supported by
# this function stay in synch with the `rg` binary.
#
# For convenience, a completion reference guide is included at the bottom of
# this file.
#
# Originally based on code from the zsh-users project — see copyright notice
# below.

_rg() {
  local curcontext=$curcontext no='!' descr ret=1
  local -a context line state state_descr args tmp suf
  local -A opt_args

  # ripgrep has many options which negate the effect of a more common one — for
  # example, `--no-column` to negate `--column`, and `--messages` to negate
  # `--no-messages`. There are so many of these, and they're so infrequently
  # used, that some users will probably find it irritating if they're completed
  # indiscriminately, so let's not do that unless either the current prefix
  # matches one of those negation options or the user has the `complete-all`
  # style set. Note that this prefix check has to be updated manually to account
  # for all of the potential negation options listed below!
  if
    # We also want to list all of these options during testing
    [[ $_RG_COMPLETE_LIST_ARGS == (1|t*|y*) ]] ||
    # (--[imnp]* => --ignore*, --messages, --no-*, --pcre2-unicode)
    [[ $PREFIX$SUFFIX == --[imnp]* ]] ||
    zstyle -t ":complete:$curcontext:*" complete-all
  then
    no=
  fi

  # We make heavy use of argument groups here to prevent the option specs from
  # growing unwieldy. These aren't supported in zsh <5.4, though, so we'll strip
  # them out below if necessary. This makes the exclusions inaccurate on those
  # older versions, but oh well — it's not that big a deal
  args=(
    + '(exclusive)' # Misc. fully exclusive options
    '(: * -)'{-h,--help}'[display help information]'
    '(: * -)'{-V,--version}'[display version information]'
    '(: * -)'--pcre2-version'[print the version of PCRE2 used by ripgrep, if available]'

    + '(buffered)' # buffering options
    '--line-buffered[force line buffering]'
    $no"--no-line-buffered[don't force line buffering]"
    '--block-buffered[force block buffering]'
    $no"--no-block-buffered[don't force block buffering]"

    + '(case)' # Case-sensitivity options
    {-i,--ignore-case}'[search case-insensitively]'
    {-s,--case-sensitive}'[search case-sensitively]'
    {-S,--smart-case}'[search case-insensitively if pattern is all lowercase]'

    + '(context-a)' # Context (after) options
    '(context-c)'{-A+,--after-context=}'[specify lines to show after each match]:number of lines'

    + '(context-b)' # Context (before) options
    '(context-c)'{-B+,--before-context=}'[specify lines to show before each match]:number of lines'

    + '(context-c)' # Context (combined) options
    '(context-a context-b)'{-C+,--context=}'[specify lines to show before and after each match]:number of lines'

    + '(column)' # Column options
    '--column[show column numbers for matches]'
    $no"--no-column[don't show column numbers for matches]"

    + '(count)' # Counting options
    {-c,--count}'[only show count of matching lines for each file]'
    '--count-matches[only show count of individual matches for each file]'
    '--include-zero[include files with zero matches in summary]'

    + '(encoding)' # Encoding options
    {-E+,--encoding=}'[specify text encoding of files to search]: :_rg_encodings'
    $no'--no-encoding[use default text encoding]'

    + '(engine)' # Engine choice options
    '--engine=[select which regex engine to use]:when:((
      default\:"use default engine"
      pcre2\:"identical to --pcre2"
      auto\:"identical to --auto-hybrid-regex"
    ))'

    + file # File-input options
    '(1)*'{-f+,--file=}'[specify file containing patterns to search for]: :_files'

    + '(file-match)' # Files with/without match options
    '(stats)'{-l,--files-with-matches}'[only show names of files with matches]'
    '(stats)--files-without-match[only show names of files without matches]'

    + '(file-name)' # File-name options
    {-H,--with-filename}'[show file name for matches]'
    {-I,--no-filename}"[don't show file name for matches]"

    + '(file-system)' # File system options
    "--one-file-system[don't descend into directories on other file systems]"
    $no'--no-one-file-system[descend into directories on other file systems]'

    + '(fixed)' # Fixed-string options
    {-F,--fixed-strings}'[treat pattern as literal string instead of regular expression]'
    $no"--no-fixed-strings[don't treat pattern as literal string]"

    + '(follow)' # Symlink-following options
    {-L,--follow}'[follow symlinks]'
    $no"--no-follow[don't follow symlinks]"

    + glob # File-glob options
    '*'{-g+,--glob=}'[include/exclude files matching specified glob]:glob'
    '*--iglob=[include/exclude files matching specified case-insensitive glob]:glob'

    + '(glob-case-insensitive)' # File-glob case sensitivity options
    '--glob-case-insensitive[treat -g/--glob patterns case insensitively]'
    $no'--no-glob-case-insensitive[treat -g/--glob patterns case sensitively]'

    + '(heading)' # Heading options
    '(pretty-vimgrep)--heading[show matches grouped by file name]'
    "(pretty-vimgrep)--no-heading[don't show matches grouped by file name]"

    + '(hidden)' # Hidden-file options
    '--hidden[search hidden files and directories]'
    $no"--no-hidden[don't search hidden files and directories]"

    + '(hybrid)' # hybrid regex options
    '--auto-hybrid-regex[dynamically use PCRE2 if necessary]'
    $no"--no-auto-hybrid-regex[don't dynamically use PCRE2 if necessary]"

    + '(ignore)' # Ignore-file options
    "(--no-ignore-global --no-ignore-parent --no-ignore-vcs --no-ignore-dot)--no-ignore[don't respect ignore files]"
    $no'(--ignore-global --ignore-parent --ignore-vcs --ignore-dot)--ignore[respect ignore files]'

    + '(ignore-file-case-insensitive)' # Ignore-file case sensitivity options
    '--ignore-file-case-insensitive[process ignore files case insensitively]'
    $no'--no-ignore-file-case-insensitive[process ignore files case sensitively]'

    + '(ignore-exclude)' # Local exclude (ignore)-file options
    "--no-ignore-exclude[don't respect local exclude (ignore) files]"
    $no'--ignore-exclude[respect local exclude (ignore) files]'

    + '(ignore-global)' # Global ignore-file options
    "--no-ignore-global[don't respect global ignore files]"
    $no'--ignore-global[respect global ignore files]'

    + '(ignore-parent)' # Parent ignore-file options
    "--no-ignore-parent[don't respect ignore files in parent directories]"
    $no'--ignore-parent[respect ignore files in parent directories]'

    + '(ignore-vcs)' # VCS ignore-file options
    "--no-ignore-vcs[don't respect version control ignore files]"
    $no'--ignore-vcs[respect version control ignore files]'

    + '(require-git)' # git specific settings
    "--no-require-git[don't require git repository to respect gitignore rules]"
    $no'--require-git[require git repository to respect gitignore rules]'

    + '(ignore-dot)' # .ignore options
    "--no-ignore-dot[don't respect .ignore files]"
    $no'--ignore-dot[respect .ignore files]'

    + '(ignore-files)' # custom global ignore file options
    "--no-ignore-files[don't respect --ignore-file flags]"
    $no'--ignore-files[respect --ignore-file files]'

    + '(json)' # JSON options
    '--json[output results in JSON Lines format]'
    $no"--no-json[don't output results in JSON Lines format]"

    + '(line-number)' # Line-number options
    {-n,--line-number}'[show line numbers for matches]'
    {-N,--no-line-number}"[don't show line numbers for matches]"

    + '(line-terminator)' # Line-terminator options
    '--crlf[use CRLF as line terminator]'
    $no"--no-crlf[don't use CRLF as line terminator]"
    '(text)--null-data[use NUL as line terminator]'

    + '(max-columns-preview)' # max column preview options
    '--max-columns-preview[show preview for long lines (with -M)]'
    $no"--no-max-columns-preview[don't show preview for long lines (with -M)]"

    + '(max-depth)' # Directory-depth options
    '--max-depth=[specify max number of directories to descend]:number of directories'
    '!--maxdepth=:number of directories'

    + '(messages)' # Error-message options
    '(--no-ignore-messages)--no-messages[suppress some error messages]'
    $no"--messages[don't suppress error messages affected by --no-messages]"

    + '(messages-ignore)' # Ignore-error message options
    "--no-ignore-messages[don't show ignore-file parse error messages]"
    $no'--ignore-messages[show ignore-file parse error messages]'

    + '(mmap)' # mmap options
    '--mmap[search using memory maps when possible]'
    "--no-mmap[don't search using memory maps]"

    + '(multiline)' # Multiline options
    {-U,--multiline}'[permit matching across multiple lines]'
    $no'(multiline-dotall)--no-multiline[restrict matches to at most one line each]'

    + '(multiline-dotall)' # Multiline DOTALL options
    '(--no-multiline)--multiline-dotall[allow "." to match newline (with -U)]'
    $no"(--no-multiline)--no-multiline-dotall[don't allow \".\" to match newline (with -U)]"

    + '(only)' # Only-match options
    {-o,--only-matching}'[show only matching part of each line]'

    + '(passthru)' # Pass-through options
    '(--vimgrep)--passthru[show both matching and non-matching lines]'
    '!(--vimgrep)--passthrough'

    + '(pcre2)' # PCRE2 options
    {-P,--pcre2}'[enable matching with PCRE2]'
    $no'(pcre2-unicode)--no-pcre2[disable matching with PCRE2]'

    + '(pcre2-unicode)' # PCRE2 Unicode options
    $no'(--no-pcre2 --no-pcre2-unicode)--pcre2-unicode[enable PCRE2 Unicode mode (with -P)]'
    '(--no-pcre2 --pcre2-unicode)--no-pcre2-unicode[disable PCRE2 Unicode mode (with -P)]'

    + '(pre)' # Preprocessing options
    '(-z --search-zip)--pre=[specify preprocessor utility]:preprocessor utility:_command_names -e'
    $no'--no-pre[disable preprocessor utility]'

    + pre-glob # Preprocessing glob options
    '*--pre-glob[include/exclude files for preprocessing with --pre]'

    + '(pretty-vimgrep)' # Pretty/vimgrep display options
    '(heading)'{-p,--pretty}'[alias for --color=always --heading -n]'
    '(heading passthru)--vimgrep[show results in vim-compatible format]'

    + regexp # Explicit pattern options
    '(1 file)*'{-e+,--regexp=}'[specify pattern]:pattern'

    + '(replace)' # Replacement options
    {-r+,--replace=}'[specify string used to replace matches]:replace string'

    + '(sort)' # File-sorting options
    '(threads)--sort=[sort results in ascending order (disables parallelism)]:sort method:((
      none\:"no sorting"
      path\:"sort by file path"
      modified\:"sort by last modified time"
      accessed\:"sort by last accessed time"
      created\:"sort by creation time"
    ))'
    '(threads)--sortr=[sort results in descending order (disables parallelism)]:sort method:((
      none\:"no sorting"
      path\:"sort by file path"
      modified\:"sort by last modified time"
      accessed\:"sort by last accessed time"
      created\:"sort by creation time"
    ))'
    '!(threads)--sort-files[sort results by file path (disables parallelism)]'

    + '(stats)' # Statistics options
    '(--files file-match)--stats[show search statistics]'
    $no"--no-stats[don't show search statistics]"

    + '(text)' # Binary-search options
    {-a,--text}'[search binary files as if they were text]'
    "--binary[search binary files, don't print binary data]"
    $no"--no-binary[don't search binary files]"
    $no"(--null-data)--no-text[don't search binary files as if they were text]"

    + '(threads)' # Thread-count options
    '(sort)'{-j+,--threads=}'[specify approximate number of threads to use]:number of threads'

    + '(trim)' # Trim options
    '--trim[trim any ASCII whitespace prefix from each line]'
    $no"--no-trim[don't trim ASCII whitespace prefix from each line]"

    + type # Type options
    '*'{-t+,--type=}'[only search files matching specified type]: :_rg_types'
    '*--type-add=[add new glob for specified file type]: :->typespec'
    '*--type-clear=[clear globs previously defined for specified file type]: :_rg_types'
    # This should actually be exclusive with everything but other type options
    '(: *)--type-list[show all supported file types and their associated globs]'
    '*'{-T+,--type-not=}"[don't search files matching specified file type]: :_rg_types"

    + '(word-line)' # Whole-word/line match options
    {-w,--word-regexp}'[only show matches surrounded by word boundaries]'
    {-x,--line-regexp}'[only show matches surrounded by line boundaries]'

    + '(unicode)' # Unicode options
    $no'--unicode[enable Unicode mode]'
    '--no-unicode[disable Unicode mode]'

    + '(zip)' # Compression options
    '(--pre)'{-z,--search-zip}'[search in compressed files]'
    $no"--no-search-zip[don't search in compressed files]"

    + misc # Other options — no need to separate these at the moment
    '(-b --byte-offset)'{-b,--byte-offset}'[show 0-based byte offset for each matching line]'
    '--color=[specify when to use colors in output]:when:((
      never\:"never use colors"
      auto\:"use colors or not based on stdout, TERM, etc."
      always\:"always use colors"
      ansi\:"always use ANSI colors (even on Windows)"
    ))'
    '*--colors=[specify color and style settings]: :->colorspec'
    '--context-separator=[specify string used to separate non-continuous context lines in output]:separator'
    $no"--no-context-separator[don't print context separators]"
    '--debug[show debug messages]'
    '--trace[show more verbose debug messages]'
    '--dfa-size-limit=[specify upper size limit of generated DFA]:DFA size (bytes)'
    "(1 stats)--files[show each file that would be searched (but don't search)]"
    '*--ignore-file=[specify additional ignore file]:ignore file:_files'
    '(-v --invert-match)'{-v,--invert-match}'[invert matching]'
    '(-M --max-columns)'{-M+,--max-columns=}'[specify max length of lines to print]:number of bytes'
    '(-m --max-count)'{-m+,--max-count=}'[specify max number of matches per file]:number of matches'
    '--max-filesize=[specify size above which files should be ignored]:file size (bytes)'
    "--no-config[don't load configuration files]"
    '(-0 --null)'{-0,--null}'[print NUL byte after file names]'
    '--path-separator=[specify path separator to use when printing file names]:separator'
    '(-q --quiet)'{-q,--quiet}'[suppress normal output]'
    '--regex-size-limit=[specify upper size limit of compiled regex]:regex size (bytes)'
    '*'{-u,--unrestricted}'[reduce level of "smart" searching]'

    + operand # Operands
    '(--files --type-list file regexp)1: :_guard "^-*" pattern'
    '(--type-list)*: :_files'
  )

  # This is used with test-complete to verify that there are no options
  # listed in the help output that aren't also defined here
  [[ $_RG_COMPLETE_LIST_ARGS == (1|t*|y*) ]] && {
    print -rl - $args
    return 0
  }

  # Strip out argument groups where unsupported (see above)
  [[ $ZSH_VERSION == (4|5.<0-3>)(.*)# ]] &&
  args=( ${(@)args:#(#i)(+|[a-z0-9][a-z0-9_-]#|\([a-z0-9][a-z0-9_-]#\))} )

  _arguments -C -s -S : $args && ret=0

  case $state in
    colorspec)
      if [[ ${IPREFIX#--*=}$PREFIX == [^:]# ]]; then
        suf=( -qS: )
        tmp=(
          'column:specify coloring for column numbers'
          'line:specify coloring for line numbers'
          'match:specify coloring for match text'
          'path:specify coloring for file names'
        )
        descr='color/style type'
      elif [[ ${IPREFIX#--*=}$PREFIX == (column|line|match|path):[^:]# ]]; then
        suf=( -qS: )
        tmp=(
          'none:clear color/style for type'
          'bg:specify background color'
          'fg:specify foreground color'
          'style:specify text style'
        )
        descr='color/style attribute'
      elif [[ ${IPREFIX#--*=}$PREFIX == [^:]##:(bg|fg):[^:]# ]]; then
        tmp=( black blue green red cyan magenta yellow white )
        descr='color name or r,g,b'
      elif [[ ${IPREFIX#--*=}$PREFIX == [^:]##:style:[^:]# ]]; then
        tmp=( {,no}bold {,no}intense {,no}underline )
        descr='style name'
      else
        _message -e colorspec 'no more arguments'
      fi

      (( $#tmp )) && {
        compset -P '*:'
        _describe -t colorspec $descr tmp $suf && ret=0
      }
      ;;

    typespec)
      if compset -P '[^:]##:include:'; then
        _sequence -s , _rg_types && ret=0
      # @todo This bit in particular could be better, but it's a little
      # complex, and attempting to solve it seems to run us up against a crash
      # bug — zsh # 40362
      elif compset -P '[^:]##:'; then
        _message 'glob or include directive' && ret=1
      elif [[ ! -prefix *:* ]]; then
        _rg_types -qS : && ret=0
      fi
      ;;
  esac

  return ret
}

# Complete encodings
_rg_encodings() {
  local -a expl
  local -aU _encodings

  # This is impossible to read, but these encodings rarely if ever change, so it
  # probably doesn't matter. They are derived from the list given here:
  # https://encoding.spec.whatwg.org/#concept-encoding-get
  _encodings=(
    {{,us-}ascii,arabic,chinese,cyrillic,greek{,8},hebrew,korean}
    logical visual mac {,cs}macintosh x-mac-{cyrillic,roman,ukrainian}
    866 ibm{819,866} csibm866
    big5{,-hkscs} {cn-,cs}big5 x-x-big5
    cp{819,866,125{0..8}} x-cp125{0..8}
    csiso2022{jp,kr} csiso8859{6,8}{e,i}
    csisolatin{{1..6},9} csisolatin{arabic,cyrillic,greek,hebrew}
    ecma-{114,118} asmo-708 elot_928 sun_eu_greek
    euc-{jp,kr} x-euc-jp cseuckr cseucpkdfmtjapanese
    {,x-}gbk csiso58gb231280 gb18030 {,cs}gb2312 gb_2312{,-80} hz-gb-2312
    iso-2022-{cn,cn-ext,jp,kr}
    iso8859{,-}{{1..11},13,14,15}
    iso-8859-{{1..11},{6,8}-{e,i},13,14,15,16} iso_8859-{{1..9},15}
    iso_8859-{1,2,6,7}:1987 iso_8859-{3,4,5,8}:1988 iso_8859-9:1989
    iso-ir-{58,100,101,109,110,126,127,138,144,148,149,157}
    koi{,8,8-r,8-ru,8-u,8_r} cskoi8r
    ks_c_5601-{1987,1989} ksc{,_}5691 csksc56011987
    latin{1..6} l{{1..6},9}
    shift{-,_}jis csshiftjis {,x-}sjis ms_kanji ms932
    utf{,-}8 utf-16{,be,le} unicode-1-1-utf-8
    windows-{31j,874,949,125{0..8}} dos-874 tis-620 ansi_x3.4-1968
    x-user-defined auto none
  )

  _wanted encodings expl encoding compadd -a "$@" - _encodings
}

# Complete file types
_rg_types() {
  local -a expl
  local -aU _types

  _types=( ${(@)${(f)"$( _call_program types rg --type-list )"}%%:*} )

  _wanted types expl 'file type' compadd -a "$@" - _types
}

_rg "$@"

################################################################################
# ZSH COMPLETION REFERENCE
#
# For the convenience of developers who aren't especially familiar with zsh
# completion functions, a brief reference guide follows. This is in no way
# comprehensive; it covers just enough of the basic structure, syntax, and
# conventions to help someone make simple changes like adding new options. For
# more complete documentation regarding zsh completion functions, please see the
# following:
#
# * http://zsh.sourceforge.net/Doc/Release/Completion-System.html
# * https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide
#
# OVERVIEW
#
# Most zsh completion functions are defined in terms of `_arguments`, which is a
# shell function that takes a series of argument specifications. The specs for
# `rg` are stored in an array, which is common for more complex functions; the
# elements of the array are passed to `_arguments` on invocation.
#
# ARGUMENT-SPECIFICATION SYNTAX
#
# The following is a contrived example of the argument specs for a simple tool:
#
#   '(: * -)'{-h,--help}'[display help information]'
#   '(-q -v --quiet --verbose)'{-q,--quiet}'[decrease output verbosity]'
#   '!(-q -v --quiet --verbose)--silent'
#   '(-q -v --quiet --verbose)'{-v,--verbose}'[increase output verbosity]'
#   '--color=[specify when to use colors]:when:(always never auto)'
#   '*:example file:_files'
#
# Although there may appear to be six specs here, there are actually nine; we
# use brace expansion to combine specs for options that go by multiple names,
# like `-q` and `--quiet`. This is customary, and ties in with the fact that zsh
# merges completion possibilities together when they have the same description.
#
# The first line defines the option `-h`/`--help`. With most tools, it isn't
# useful to complete anything after `--help` because it effectively overrides
# all others; the `(: * -)` at the beginning of the spec tells zsh not to
# complete any other operands (`:` and `*`) or options (`-`) after this one has
# been used. The `[...]` at the end associates a description with `-h`/`--help`;
# as mentioned, zsh will see the identical descriptions and merge these options
# together when offering completion possibilities.
#
# The next line defines `-q`/`--quiet`. Here we don't want to suppress further
# completions entirely, but we don't want to offer `-q` if `--quiet` has been
# given (since they do the same thing), nor do we want to offer `-v` (since it
# doesn't make sense to be quiet and verbose at the same time). We don't need to
# tell zsh not to offer `--quiet` a second time, since that's the default
# behaviour, but since this line expands to two specs describing `-q` *and*
# `--quiet` we do need to explicitly list all of them here.
#
# The next line defines a hidden option `--silent` — maybe it's a deprecated
# synonym for `--quiet`. The leading `!` indicates that zsh shouldn't offer this
# option during completion. The benefit of providing a spec for an option that
# shouldn't be completed is that, if someone *does* use it, we can correctly
# suppress completion of other options afterwards.
#
# The next line defines `-v`/`--verbose`; this works just like `-q`/`--quiet`.
#
# The next line defines `--color`. In this example, `--color` doesn't have a
# corresponding short option, so we don't need to use brace expansion. Further,
# there are no other options it's exclusive with (just itself), so we don't need
# to define those at the beginning. However, it does take a mandatory argument.
# The `=` at the end of `--color=` indicates that the argument may appear either
# like `--color always` or like `--color=always`; this is how most GNU-style
# command-line tools work. The corresponding short option would normally use `+`
# — for example, `-c+` would allow either `-c always` or `-calways`. For this
# option, the arguments are known ahead of time, so we can simply list them in
# parentheses at the end (`when` is used as the description for the argument).
#
# The last line defines an operand (a non-option argument). In this example, the
# operand can be used any number of times (the leading `*`), and it should be a
# file path, so we tell zsh to call the `_files` function to complete it. The
# `example file` in the middle is the description to use for this operand; we
# could use a space instead to accept the default provided by `_files`.
#
# GROUPING ARGUMENT SPECIFICATIONS
#
# Newer versions of zsh support grouping argument specs together. All specs
# following a `+` and then a group name are considered to be members of the
# named group. Grouping is useful mostly for organisational purposes; it makes
# the relationship between different options more obvious, and makes it easier
# to specify exclusions.
#
# We could rewrite our example above using grouping as follows:
#
#   '(: * -)'{-h,--help}'[display help information]'
#   '--color=[specify when to use colors]:when:(always never auto)'
#   '*:example file:_files'
#   + '(verbosity)'
#   {-q,--quiet}'[decrease output verbosity]'
#   '!--silent'
#   {-v,--verbose}'[increase output verbosity]'
#
# Here we take advantage of a useful feature of spec grouping — when the group
# name is surrounded by parentheses, as in `(verbosity)`, it tells zsh that all
# of the options in that group are exclusive with each other. As a result, we
# don't need to manually list out the exclusions at the beginning of each
# option.
#
# Groups can also be referred to by name in other argument specs; for example:
#
#   '(xyz)--aaa' '*: :_files'
#   + xyz --xxx --yyy --zzz
#
# Here we use the group name `xyz` to tell zsh that `--xxx`, `--yyy`, and
# `--zzz` are not to be completed after `--aaa`. This makes the exclusion list
# much more compact and reusable.
#
# CONVENTIONS
#
# zsh completion functions generally adhere to the following conventions:
#
# * Use two spaces for indentation
# * Combine specs for options with different names using brace expansion
# * In combined specs, list the short option first (as in `{-a,--text}`)
# * Use `+` or `=` as described above for options that take arguments
# * Provide a description for all options, option-arguments, and operands
# * Capitalise/punctuate argument descriptions as phrases, not complete
#   sentences — 'display help information', never 'Display help information.'
#   (but still capitalise acronyms and proper names)
# * Write argument descriptions as verb phrases — 'display x', 'enable y',
#   'use z'
# * Word descriptions to make it clear when an option expects an argument;
#   usually this is done with the word 'specify', as in 'specify x' or
#   'use specified x')
# * Write argument descriptions as tersely as possible — for example, articles
#   like 'a' and 'the' should be omitted unless it would be confusing
#
# Other conventions currently used by this function:
#
# * Order argument specs alphabetically by group name, then option name
# * Group options that are directly related, mutually exclusive, or frequently
#   referenced by other argument specs
# * Use only characters in the set [a-z0-9_-] in group names
# * Order exclusion lists as follows: short options, long options, groups
# * Use American English in descriptions
# * Use 'don't' in descriptions instead of 'do not'
# * Word descriptions for related options as similarly as possible. For example,
#   `--foo[enable foo]` and `--no-foo[disable foo]`, or `--foo[use foo]` and
#   `--no-foo[don't use foo]`
# * Word descriptions to make it clear when an option only makes sense with
#   another option, usually by adding '(with -x)' to the end
# * Don't quote strings or variables unnecessarily. When quotes are required,
#   prefer single-quotes to double-quotes
# * Prefix option specs with `$no` when the option serves only to negate the
#   behaviour of another option that must be provided explicitly by the user.
#   This prevents rarely used options from cluttering up the completion menu
################################################################################

# ------------------------------------------------------------------------------
# Copyright (c) 2011 Github zsh-users - http://github.com/zsh-users
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the zsh-users nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL ZSH-USERS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for ripgrep
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
#  * arcizan <ghostrevery@gmail.com>
#  * MaskRay <i@maskray.me>
#
# ------------------------------------------------------------------------------

# Local Variables:
# mode: shell-script
# coding: utf-8-unix
# indent-tabs-mode: nil
# sh-indentation: 2
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
