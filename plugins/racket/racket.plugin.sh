#compdef racket raco

#
# This file defines zsh completions for `racket' and `raco'.
#
# To give it a quick try, load this file with the "source" command.
#
# The proper way to install it is to copy it to a file called "_racket" in one
# the zsh function directories which you can find with "echo $fpath".  For
# example: "cp racket-completion.zsh ${fpath[1]}/_racket".  If all of the
# $fpath entries are system directories that you can't write to, you can add
# your own path by adding something like "fpath+=~/.zsh" in your ".zshrc" file.
# You can also use "source" as described above, but then it's not auto-loaded.
# (Note that sourcing this file will load the completion system if it's not
# already done.)
#
# These completions include useful hints for flags, and for types of arguments.
# To see the latter, you can something like add the following to your ".zshrc":
#   zstyle ':completion:*' verbose yes
#   zstyle ':completion:*:descriptions' format '--- %U%d%u ---'
#
# The completions below cover all of the `racket' and `raco' commands.  It also
# includes a simple test facility: if you run "_racket --self-test", it will go
# over all --help outputs, and compare them with the outputs that were in
# effect when this script was updated.  This a simple checksum test, and
# failures are usually due to added flags and text tweaks.  (It is mostly
# useful to keep track of command-line changes between releases.)
#
# If you want to include a new raco command, you need to define a function that
# is called "_raco_cmd_<new-command>", see below for many examples.  To have
# your code autoloaded, place the function's *body* in a file that has the
# function's name, in one of the "$fpath" directories, and make sure that the
# first line is "#autoload".  (Autoloaded functions in zsh have their body
# saved in a file that has the function name.  This file uses a common trick:
# it defines the `_racket' function which zsh will not overwrite, and it calls
# the function since it's loaded on first use.)
#

# Identify zsh as the completion client
export RACKET_COMPLETION_CLIENT=zsh

###############################################################################

_racket_file_expander() {
  if [[ -d "$REPLY" ]]; then return 0
  elif [[ "$REPLY" = *.(rkt|ss) ]]; then reply="${REPLY%.*}"
  elif [[ "$REPLY" = *.(scrbl|scm) ]]; then return 0
  else return 1; fi
}

_racket_call() {
  local tag="$1"; shift; local prog="$*"
  local -a flags; local f
  flags=()
  if [[ "$service" = "racket" ]]; then
    for f in "-"{X,S,A,C,U} "--"{collects,search,addon,links,no-user-path}; do
      (( $+opt_args[$f] )) && flags+=("$f" "${opt_args[$f]}")
    done
  fi
  _call_program "$tag" racket "${(@)flags}" -I racket/base -q -e '$prog'
}

_racket_read_libfile_or_collect() {
  local -a dirs
  dirs=(
    "${(f)$(_racket_call directories '(require (submod shell-completion/list-collects main))')}"
  )
  local -a ignored
  ignored=('*.dep' '*.zo' 'compiled' '*/compiled')
  case "$1" in
  ( "dir" ) _wanted collections expl collection _files -W dirs -F ignored -/ \
            && return 0 ;;
  ( "file" ) _wanted libraries expl library-file _files \
               -W dirs -F ignored -g '*(+_racket_file_expander)' \
             && return 0 ;;
  esac
  return 1
}
_racket_read_libfile() { _racket_read_libfile_or_collect file; }
_racket_read_collect() { _racket_read_libfile_or_collect dir; }
_racket_read_path()    { _files; }

_racket_do_state() {
  if [[ -n $state ]] && (( $+functions[_racket_read_$state] )); then
    _racket_read_$state
  else
    return 1
  fi
}

RACKET_CHECKSUMS=()
_racket_self_test() {
  if (( $# )) { RACKET_CHECKSUMS+="$*"; } else
    echo "Testing..."
    local t command expected filter checksum
    for t in $RACKET_CHECKSUMS; do
      cmd=${t%%:*}
      expected=${t#*:}
      if [[ $expected = *:* ]]; then
        filter=${expected#*:}
        expected=${expected%%:*}
      else
        filter=cat
      fi
      # leave only alphanumerics, so it's insensitive to space & punctuations
      checksum=$(${(Q)"${(z)cmd}"} --help |& ${(Q)"${(z)filter}"} \
                   |& tr -cd '[:alnum:]' | cksum)
      checksum=${${(z)checksum}[1]}
      printf '  %s: ' "$cmd"
      if [[ "$checksum" = "$expected" ]]; then printf 'ok\n'
      else printf '*** error, expected: %s, got %s\n' "$expected" "$checksum"
      fi
    done
    echo "Done."
  fi
}

###############################################################################

_racket_self_test 'racket:3785877773:grep -v "Welcome to Racket"'

RACKET_COMMON=( -C -s -w -S : '(- : *)'{-h,--help}'[Display help]' )
RACKET_ARGS=( "$RACKET_COMMON[@]" )

# File and expression options:
RACKET_ARGS+=(
  '*'{-e,--eval}'[Evaluate expression]:expression: '
  '*'{-f,--load}'+[Load a file]:file:_files'
  '*'{-t,--require}'+[Require a file]:file:_files'
  '*'{-l,--lib}'+[Require a library file]:library-file:->libfile'
  '*'-p'+[Require a planet package]:planet-package: '
  '(- *)'{-r,--script}'+[Load a script (same as -f F -n F --)]:file:_files'
  '(- *)'{-u,--require-script}'+[Require a script (same as -tN- F -N F --)]:file:_files'
  # No need to do `-k' -- it's for internal use by launchers
  '(-m --main)'{-m,--main}'[Call `main'"'"' with command-line arguments]'
)

# Interaction options:
RACKET_ARGS+=(
  '(-i --repl)'{-i,--repl}'[Run interactive read-eval-print loop]'
  '(-n --no-lib)'{-n,--no-lib}'[Skip requiring init-lib for -i/-e/-f/-r]'
  '(-v --version)'{-v,--version}'[Show version]'
  '(-V --no-yield)'{-V,--no-yield}'[Skip yield handler on exit]'
)

# Configuration options:
RACKET_ARGS+=(
  '(-c --no-compiled)'{-c,--no-compiled}'[Disable loading of compiled files]'
  '(-q --no-init-file)'{-q,--no-init-file}'[Skip loading ~/.racketrc for -i]'
  '(-I)'-I'+[Set init-lib]:library-file:->libfile'
  '(-X --collects)'{-X,--collects}'+[Main collects dir ("" disables all)]:directory:_files -/'
  '*'{-S,--search}'+[More collects dir (after main)]:directory:_files -/'
  '(-A --addon)'{-A,--addon}'+[Addon directory]:directory:_files -/'
  '(-R --compiled)'{-A,--addon}'+[Set compiled-file search roots to directory]:directory:_files -/'
  '(-C --links)'{-C,--links}'+[User-specific collection links file]:file:_files'
  '(-U --no-user-path)'{-U,--no-user-path}'[Ignore user-specific collects, etc.]'
  '(-N --name)'{-N,--name}'+[Sets (find-system-path '"'"'run-file)]:file:_files'
  '(-j --no-jit)'{-j,--no-jit}'[Disable the just-in-time compiler]'
  '(-d --no-delay)'{-d,--no-delay}'[Disable on-demand loading of syntax and code]'
  '(-b --binary)'{-b,--binary}'[Read stdin and write stdout/stderr in binary mode]'
  '(-W --warn)'{-W,--warn}'+[Set stderr logging level]:log-level:(none fatal error warning info debug)'
  '(-L --syslog)'{-L,--syslog}'+[Set syslog logging level]:log-level:(none fatal error warning info debug)'
)

# Main arguments:
RACKET_ARGS+=(
  '(-)1:racket-file:_files'
  '*::script-argument: _normal'
)

_racket_main() {
  _arguments "${RACKET_ARGS[@]}" && return 0
  _racket_do_state
}

###############################################################################

_racket_self_test 'raco:3382393175'
_raco() {
  if (( CURRENT > 2 )); then
    local subcmd="${words[2]}"
    curcontext="${curcontext%:*:*}:raco-$subcmd"
    (( CURRENT-- ))
    shift words
    if [[ $subcmd = -(h|-help) ]]; then _message 'no more arguments'
    elif (( $+functions[_raco_cmd_$subcmd] )); then _raco_cmd_$subcmd
    else _normal
    fi
  else
    local hline
    local -a cmdlist
    cmdlist=(
      {-h,--help}:'Display help'
      "${(f)$(_racket_call raco-command '
               (require raco/all-tools)
               (hash-for-each (all-tools)
                              (lambda (k v) (printf "~a:~a\n" k (caddr v))))')}"
    )
    _describe -t raco-commands 'raco command' cmdlist
  fi
}

_racket_self_test 'raco docs:2277531825'
_raco_cmd_docs() {
  _arguments "$RACKET_COMMON[@]" \
    '*:search-term: ' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco setup:2092236815:tail -n +2' # full path for this one
_raco_cmd_setup() {
  _arguments "$RACKET_COMMON[@]" \
    '(-c --clean)'{-c,--clean}'[Delete existing compiled files; implies -nxi]' \
    '(-j --workers)'{-j,--workers}'+[Use N parallel jobs]:cores: ' \
    '(-n --no-zo)'{-n,--no-zo}'[Do not produce .zo files]' \
    '(-x --no-launcher)'{-x,--no-launcher}'[Do not produce launcher programs]' \
    '(-i --no-install)'{-i,--no-install}'[Do not call collection-specific pre-installers]' \
    '(-I --no-post-install)'{-I,--no-post-install}'[Do not call collection-specific post-installers]' \
    '(-d --no-info-domain)'{-d,--no-info-domain}'[Do not produce info-domain caches]' \
    '(-D --no-docs)'{-D,--no-docs}'[Do not compile .scrbl files and do not build documentation]' \
    '(-U --no-user)'{-U,--no-user}'[Do not setup user-specific collections (implies --no-planet)]' \
    '(--no-planet)'--no-planet'[Do not setup PLaneT packages]' \
    '(--avoid-main)'--avoid-main'[Do not make main-installation files]' \
    '(-v --verbose)'{-v,--verbose}'[See names of compiled files and info printfs]' \
    '(-m --make-verbose)'{-m,--make-verbose}'[See make and compiler usual messages]' \
    '(-r --compile-verbose)'{-r,--compile-verbose}'[See make and compiler verbose messages]' \
    '(--trust-zos)'--trust-zos'[Trust existing .zos (use only with prepackaged .zos)]' \
    '(-p --pause)'{-p,--pause}'[Pause at the end if there are any errors]' \
    '(--force)'--force'[Treat version mismatches for archives as mere warnings]' \
    '(-a --all-users)'{-a,--all-users}'[Install archives to main (not user-specific) installation]' \
    '(--mode)'--mode'+[Select a compilation mode]:log-level:(errortrace)' \
    '(--doc-pdf)'--doc-pdf'+[Write doc PDF to directory]:directory:_files -/' \
    '(-l)'-l'+[Setup specific collections only]:*:collection:->collect' \
    '(-A)'-A'+[Unpack and install .plt archives]:plt-archive:_files -g \*.plt' \
    '*'-P'+[Setup specified PLaneT packages only]:owner: :package-name: :major-version: :minor-version: ' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco scribble:611326287'
_raco_cmd_scribble() {
  _arguments "$RACKET_COMMON[@]" \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--html'[Generate HTML-format output file (default)]' \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--htmls'[Generate HTML-format output directory]' \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--pdf'[Generate PDF-format output (with PDFLaTeX)]' \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--latex'[Generate LaTeX-format output]' \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--latex-section'+[Generate LaTeX-format output for section depth N]:section-depth: ' \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--text'[Generate text-format output]' \
    '(--html --htmls --latex --pdf --latex-section --text --markdown)'--markdown'[Generate markdown-format output]' \
    '(--dest)'--dest'+[Write output in directory]:directory:_files -/' \
    '(--dest-name)'--dest-name'+[Write output as name]:name: ' \
    '(--dest-base)'--dest-base'+[Start support-file names with prefix]:prefix: ' \
    '*'++style'+[Add given .css/.tex file after others]:style-file:_files -g \*.\(css\|tex\)' \
    '*'--style'+[Use given base .css/.tex file]:style-file:_files -g \*.\(css\|tex\)' \
    '*'--prefix'+[Use given .html/.tex prefix (for doctype/documentclass)]:prefix-file:_files -g \*.\(html\|htm\|tex\)' \
    '*'++extra'+[Add given file]:file:_files' \
    '*'--redirect-main'+[Redirect main doc links to url]:url: ' \
    '*'--redirect'+[Redirect external links to tag search via url]:url: ' \
    '(+m ++main-xref-in)'{+m,++main-xref-in}'[load format-speficic cross-ref info for all installed library collections]' \
    '*'++xref-in'+[Load format-specific cross-ref info by]:module-path:->libfile:proc-id: ' \
    '*'--info-out'+[Write format-specific cross-ref info to file]:file:_file' \
    '*'++info-in'+[Load format-specific cross-ref info from file]:file:_file' \
    '(--quiet)'--quiet'[Suppress output-file and undefined-tag reporting]' \
    '*:scribble-file:_files -g \*.scrbl' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco exe:614832725'
_raco_cmd_exe() {
  _arguments "$RACKET_COMMON[@]" \
    '(-o)'-o'+[Write executable as file]:output-executable:_files' \
    '(--gui)'--gui'+[Generate GUI executable]' \
    '(-l --launcher)'{-l,--launcher}'[Generate a launcher]' \
    '(--collects-path)'--collects-path'+[Set path as main collects for executable]:collection:->collect' \
    '(--collects-dest)'--collects-dest'+[Write collection code to directory]:directory:_files -/' \
    '(--ico)'--ico'+[Set Windows icon for executable]:ico-file:_files -g \*.ico' \
    '(--icns)'--icns'+[Set Mac OS X icon for executable]:icns-file:_files -g \*.icns' \
    '(--orig-exe)'--orig-exe'[Use original executable instead of stub]' \
    '(--3m --cgc)'--3m'[Generate using 3m variant]' \
    '(--3m --cgc)'--cgc'[Generate using CGC variant]' \
    '*'++aux'+[Extra executable info (based on aux-file suffix)]:aux-file:_files' \
    '*'++lib'+[Embed lib in executable]:lib-file:_files' \
    '*'++exf'+[Add flag to embed in executable]:flag: ' \
    '*'--exf'+[Remove flag to embed in executable]:flag: ' \
    '*'--exf-clear'[Clear flags to embed in executable]' \
    '*'--exf-show'[Show flags to embed in executable]' \
    '(-v)'-v'[Verbose mode]' \
    '(--vv)'--vv'[Very verbose mode]' \
    '*:source-file:_files -g \*.\(rkt\|ss\|scm\)' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco make:3358542168'
_raco_cmd_make() {
  _arguments "$RACKET_COMMON[@]" \
    '(-j)'-j'+[Use N parallel jobs]:cores: ' \
    '(--disable-inline)'--disable-inline'[Disable procedure inlining during compilation]' \
    '(--disable-constant)'--disable-constant'[Disable enforcement of module constants]' \
    '(--no-deps)'--no-deps'[Compile immediate files without updating dependencies]' \
    '(-p --prefix)'{-p,--prefix}'+[Add elaboration-time prefix file for --no-deps]:prefix-file:_files' \
    '(--no-prim)'--no-prim'[Do not assume `scheme'"'"' bindings at top level for --no-deps]' \
    '(-v)'-v'[Verbose mode]' \
    '(--vv)'--vv'[Very verbose mode]' \
    '*:source-files:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco ctool:1038338951'
_raco_cmd_ctool() {
  _arguments "$RACKET_COMMON[@]" \
    '(--cc --ld -x --xform --c-mods)'--xx'[Compile arbitrary file(s) for an extension: .c -> .o]' \
    '(--cc --ld -x --xform --c-mods)'--ld'+[Link arbitrary file(s) to create extension: .o -> .so]:extension-file:_files' \
    '(--cc --ld -x --xform --c-mods)'{-x,--xform}'[Convert for 3m compilation: .c -> .c]' \
    '(--cc --ld -x --xform --c-mods)'--c-mods'+[Write C-embeddable module bytecode to file]:file:_files' \
    '(--3m --cgc)'--3m'[Compile/link for 3m (default)]' \
    '(--3m --cgc)'--cgc'[Compile/link for CGC]' \
    '(-n --name)'{-n,--name}'+[Use name as extra part of public low-level names]:name: ' \
    '(-d --destination)'{-d,--destination}'+[Output --cc/--ld/-x file(s) to directory]:destination-directory:_files -/' \
    '(--tool)'--tool'+[Use pre-defined tool as C compiler/linker]:tool:(gcc cc)' \
    '(--compiler)'--compiler'+[Use specified C compiler]:compiler-path:_files' \
    '*'++ccf'+[Add C compiler flag]:flag: ' \
    '*'--ccf'+[Remove C compiler flag]:flag: ' \
    '*'--ccf-clear'[Clear C compiler flags]' \
    '*'--ccf-show'[Show C compiler flags]' \
    '(--linker)'--linker'+[Use specified C linker]:linker-path:_files' \
    '*'++ldf'+[Add C linker flag]:flag: ' \
    '*'--ldf'+[Remove C linker flag]:flag: ' \
    '*'--ldf-clear'[Clear C linker flags]' \
    '*'--ldf-show'[Show C linker flags]' \
    '*'++ldl'+[Add C linker library]:library-file:_files' \
    '*'--ldl-show'[Show C linker libraries]' \
    '*'++cppf'+[Add C preprocess (xform) flag]:flag: ' \
    '*'--cppf'+[Remove C preprocess (xform) flag]:flag: ' \
    '*'--cppf-clear'[Clear C preprocess (xform) flags]' \
    '*'--cppf-show'[Show C preprocess (xform) flags]' \
    '*'++lib'+[Embed lib in --c-mods output]:lib-file:_files' \
    '(-v)'-v'[Slightly verbose mode, including version banner and output files]' \
    '(--vv)'--vv'[Very verbose mode]' \
    '*:file:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco distribute:1034282712'
_raco_cmd_distribute() {
  _arguments "$RACKET_COMMON[@]" \
    '(--collects-path)'--collects-path'+[Set path as main collects for executables]:collection:->collect' \
    '*'++collects-copy'+[Add collects in dir to directory]:collection:->collect' \
    '(-v)'-v'[Verbose mode]' \
    '1:destination-directory:_files -/' \
    '*:executable:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco link:1334896662'
_raco_cmd_link() {
  _arguments "$RACKET_COMMON[@]" \
    '(-l --list)'{-l,--list}'[Show the link table (after changes)]' \
    '(-n --name -d --root)'{-n,--name}'+[Collection name to add (single dir) or remove]:name: ' \
    '(-n --name -d --root)'{-d,--root}'[Treat dir as a collection root]' \
    '(-x --version-regexp)'{-x,--version-regexp}'+[Set the version pregexp]:regexp: ' \
    '(-r --remove)'{-r,--remove}'[Remove links for the specified directories]' \
    '(-u --user -i --installation -f --file)'{-u,--user}'[Adjust/list user-specific links]' \
    '(-u --user -i --installation -f --file)'{-i,--installation}'[Adjust/list installation-wide links]' \
    '(-u --user -i --installation -f --file)'{-f,--file}'+[Select an alternate link file]:file:_files -g \*.rktd' \
    '(--repair)'--repair'[Enable repair mode to fix existing links]' \
    '*:directory:_files -/' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco pack:1977512558'
_raco_cmd_pack() {
  _arguments "$RACKET_COMMON[@]" \
    '(--collect)'--collect'[paths specify collections instead of files/dirs]' \
    '(--plt-name)'--plt-name'+[Set the printed name describing the archive]:archive-name: ' \
    '(--replace)'--replace'[Files in archive replace existing files when unpacked]' \
    '(--at-plt)'--at-plt'[Files/dirs in archive are relative to user'"'"'s add-ons directory]' \
    '(--all-users --force-all-users)'--all-users'[Files/dirs in archive go to PLT installation if writable]' \
    '(--all-users --force-all-users)'--force-all-users'[Files/dirs forced to PLT installation]' \
    '(--include-compiled)'--include-compiled'[Include "compiled" subdirectories in the archive]' \
    '*'++setup'+[Setup given collect after the archive is unpacked]:collection:->collect' \
    '(-v)'-v'[Verbose mode]' \
    '1:destination-archive:_files -g \*.plt' \
    '*:file-or-directory:->rest' \
  && return 0
  echo "$state" > /tmp/zzz
  if [[ "$state" = "rest" ]]; then
    if (( $+opt_args[--collect] )); then state="collect"; else state="path"; fi
  fi
  _racket_do_state
}

_racket_self_test 'raco unpack:2639538734'
_raco_cmd_unpack() {
  _arguments "$RACKET_COMMON[@]" \
    '(-l --list)'{-l,--list}'[List archive content]' \
    '(-c --config)'{-c,--config}'[Show archive configuration]' \
    '(-f --force)'{-f,--force}'[Replace existing files when unpacking]' \
    '*:plt-archive:_files -g \*.plt' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco expand:1935188678'
_raco_cmd_expand() {
  _arguments "$RACKET_COMMON[@]" \
    '*:source-file:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco decompile:1342114717'
_raco_cmd_decompile() {
  _arguments "$RACKET_COMMON[@]" \
    '*:source-or-bytecode-file:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco demodularize:33137783'
_raco_cmd_demodularize() {
  _arguments "$RACKET_COMMON[@]" \
    '*'{-e,--exclude-modules}'+[Exclude module from flattening]:module-path:->libfile' \
    '(-o)'-o'+[Write output as dest-filename]:dest-filename:_files' \
    '*:file:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco test:2458495009'
_raco_cmd_test() {
  _arguments "$RACKET_COMMON[@]" \
    '(-s --submodule)'{-s,--submodule}'+[Runs submodule name (defaults to `test'"'"')]:submodule: ' \
    '(-r --run-if-absent -x --no-run-if-absent)'{-r,--run-if-absent}'[Require module if submodule is absent (on by default)]' \
    '(-r --run-if-absent -x --no-run-if-absent)'{-x,--no-run-if-absent}'[Require nothing if submodule is absent]' \
    '(-q --quiet)'{-q,--quiet}'+[Suppress `Running ...'"'"' message]' \
    '(-c --collection)'{-c,--collection}'+[Interpret arguments as collections]' \
    '(-p --package)'{-p,--package}'+[Interpret arguments as packages]' \
    '*:source-file-or-directory:_files' \
  && return 0
  _racket_do_state
}

_racket_self_test 'raco planet:1582997403'
_raco_cmd_planet() {
  if (( CURRENT > 2 )); then
    local subcmd="${words[2]}"
    curcontext="${curcontext%:*:*}:raco-planet-$subcmd"
    (( CURRENT-- ))
    shift words
    if [[ $subcmd = -(h|-help) ]]; then _message 'no more arguments'
    elif (( $+functions[_raco_cmd_planet_$subcmd] )); then _raco_cmd_planet_$subcmd
    else _normal
    fi
  else
    local hline
    local -a cmdlist
    local pfx='^  raco planet '
    cmdlist=(
      {-h,--help}:'Display help'
      ${(f)"$(raco planet | grep "$pfx" \
                          | sed -e "s/$pfx"'\([^ ]*\) *\(.*\)/\1:\2/')"}
    )
    _describe -t raco-planet-commands 'raco planet command' cmdlist
  fi
}

_racket_self_test 'raco planet clearlinks:145158300'
_raco_cmd_planet_clearlinks() {
  _arguments "$RACKET_COMMON[@]" \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet create:3318289542'
_raco_cmd_planet_create() {
  _arguments "$RACKET_COMMON[@]" \
    '(-f --force)'{-f,--force}'[force a package to be created even if its info.rkt file contains errors.]' \
    '1:destination-archive:_files -g \*.plt' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet fetch:4273560882'
_raco_cmd_planet_fetch() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):owner: ' \
    ':package-name: ' \
    ':major-version: ' \
    ':minor-version: ' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet fileinject:3090983232'
_raco_cmd_planet_fileinject() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):owner: ' \
    ':plt-archive:_files -g \*.plt' \
    ':major-version: ' \
    ':minor-version: ' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet install:1001510693'
_raco_cmd_planet_install() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):owner: ' \
    ':package-name: ' \
    ':major-version: ' \
    ':minor-version: ' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet link:2118742145'
_raco_cmd_planet_link() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):owner: ' \
    ':package-name: ' \
    ':major-version: ' \
    ':minor-version: ' \
    ':directory:_files -/' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet open:4239735370'
_raco_cmd_planet_open() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):plt-archive:_files -g \*.plt' \
    ':target-directory:_files -/' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet print:2975791845'
_raco_cmd_planet_print() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):plt-archive:_files -g \*.plt' \
    ':path-in-plt-aarchive: ' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet remove:3543578058'
_raco_cmd_planet_remove() {
  _arguments "$RACKET_COMMON[@]" \
    '(-e --erase)'{-e,--erase}'[also remove the package'"'"'s distribution file from the uninstalled-package cache]' \
    '(-):owner: ' \
    ':package-name: ' \
    ':major-version: ' \
    ':minor-version: ' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet show:3911537255'
_raco_cmd_planet_show() {
  _arguments "$RACKET_COMMON[@]" \
    '(-p --packages -l --linkage -a --all)'{-p,--packages}'[show packages only (default)]' \
    '(-p --packages -l --linkage -a --all)'{-l,--linkage}'[show linkage table only]' \
    '(-p --packages -l --linkage -a --all)'{-a,--all}'[show packages and linkage]' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet structure:561630587'
_raco_cmd_planet_structure() {
  _arguments "$RACKET_COMMON[@]" \
    ':plt-archive:_files -g \*.plt' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet unlink:1307144701'
_raco_cmd_planet_unlink() {
  _arguments "$RACKET_COMMON[@]" \
    '(-q --quiet)'{-q,--quiet}'[don'"'"'t signal an error on nonexistent links]' \
    '(-):owner: ' \
    ':package-name: ' \
    ':major-version: ' \
    ':minor-version: ' \
  && return 0
  _racket_do_state
}
_racket_self_test 'raco planet url:3825697949'
_raco_cmd_planet_url() {
  _arguments "$RACKET_COMMON[@]" \
    '(-):owner: ' \
    ':package-name: ' \
    ':major-version: ' \
    ':minor-version: ' \
  && return 0
  _racket_do_state
}

###############################################################################

_racket() {
  if [[ $1 = --self-test ]]; then _racket_self_test; return; fi
  local curcontext="$curcontext" context state line
  typeset -A opt_args
  case "$service" in
  ( "racket" ) _racket_main "$@" ;;
  ( "raco"   ) _raco "$@" ;;
  ( * ) return 1 ;;
  esac
}

if [[ -n $service ]]; then _racket "$@"
else # loaded directly => define the completion (load if needed)
  if (( ! $+functions[compdef] )); then autoload -U compinit; compinit; fi
  compdef _racket racket raco
fi
