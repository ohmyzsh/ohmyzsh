#compdef ack ack2 ack-grep

function _ack2_completion() {
  declare -a ack_types
  declare -a arguments
  local type

  arguments=( \
              "--ackrc""[specify an alternative ackrc]"        \
                  {--after-context,-A}"[print NUM lines of trailing context after matching lines]"        \
                  "--bar""[check with the admiral for traps]"        \
                  {--before-context,-B}"[print NUM lines of leading context before matching lines]"        \
                  "--break""[print a break between results for different files]"        \
                  "--cathy""[chocolate, chocolate, chocolate!]"        \
                  {--color,--colour}"[highlight matching text]"        \
                  "--color-filename""[set color for filenames]"        \
                  "--color-lineno""[set color for line numbers]"        \
                  "--color-match""[set color for matches]"        \
                      "--column""[show column number of first match]"        \
                  {--context,-C}"[print NUM lines of context around matching lines]"        \
                  {--count,-c}"[print a count of matching lines for each input file]"        \
                  "--create-ackrc""[dumps default ack options to standard output]"        \
                  "--dump""[writes the list of loaded options and where they came from]"        \
                  "--env"        \
                  "--files-from""[specifies the list of files to search within FILE]"        \
                  {--files-with-matches,-l}"[only print filenames of matching files]"        \
                  {--files-without-matches,-L}"[only print filenames of non-matching files]"        \
                  "--filter""[force ack to behave as if it were receiving input via a pipe]"        \
                  "--flush""[flushes output immediately]"        \
                  "--follow""[follow symlinks]"        \
                  "--group""[group matches by filename]"        \
                  "--heading""[print a filename heading above each file's result]"        \
                  {--help,-\?}"[displays help]"        \
                  "--help-types""[print all known types]"        \
                  "--ignore-ack-defaults""[ignore default definitions provided with ack]"        \
                  {--ignore-case,-i}"[ignore case in matches]"        \
                      {--ignore-directory,--ignore-dir}"[ignore directories (at any level) named DIRNAME]"        \
                  "--ignore-file""[ignore files matching FILTERTYPE:FILTERARGS]"        \
                  {--invert-match,-v}"[select non-matching lines]"        \
                  "--lines""[print only line NUM of each file]"        \
                  {--literal,-Q}"[quote all metacharacters in PATTERN]"        \
                  "--man""[displays the ack man page]"        \
                  "--match""[specify PATTERN explicitly]"        \
                  {--max-count,-m}"[stop reading after NUM matches]"        \
                  {--no-filename,-h}"[don't print filenames on output]"        \
                  {--no-recurse,-n}        \
                  "--nobreak"        \
                  "--nocolor"        \
                  "--nocolour"        \
                  "--nocolumn"        \
                  "--noenv""[don't consider ackrc files/environment variables for configuration]"        \
                  "--nofilter"        \
                  "--nofollow"        \
                  "--nogroup"        \
                  "--noheading"        \
                  "--noignore-dir"        \
                  "--noignore-directory"        \
                  "--nopager"        \
                  "--nosmart-case"        \
                  "--output""[output the evaluation of EXPR for each line]"        \
                  "--pager""[direct ack's output through PAGER]"        \
                  "--passthru""[print all lines, whether or not they match the expression, highlighting matches]"        \
                  "--print0""[seperate output lines with NUL characters]"        \
                  {--recurse,-r,-R}"[recurse into subdirectories]"        \
                  "--show-types""[outputs the filetypes that ack associates with each file]"        \
                  "--smart-case""[ignores case in search strings if PATTERN contains no uppercase characters]"        \
                  "--sort-files""[sorts found files lexicographically]"        \
                  "--thpppt""[display the Bill The Cat logo.]"        \
                      "--type-add""[add a type definition]"        \
                  "--type-del""[removes a type definition]"        \
                  "--type-set""[add a type definition]"        \
                  "--version""[displays version and copyright information]"        \
                  {--with-filename,-H}"[print the filename for each match]"        \
                  {--word-regexp,-w}"[force PATTERN to match only whole words]"        \
                  "-1""[stops after reporting first match]"        \
                                                      "-f""[only print files that would be searched]"        \
                  "-g""[only print files whose names match PATTERN]"        \
                                      "-o""[only print the part of each matching line that matches PATTERN]"        \
                      "-s""[suppress error messages about nonexistent or unreadable files]"        \
                          "-x""[search files specified on standard input]"        \
      )

  while read LINE; do
      case $LINE in
          --*)
              type="${LINE%% *}"
              type=${type/--\[no\]/}
              arguments[$(( ${#arguments[@]} + 1 ))]="--${type}[restrict to files of type $type]"
              arguments[$(( ${#arguments[@]} + 1 ))]="--no${type}[restrict to files other than type $type]"
              ack_types[$(( ${#ack_types[@]} + 1 ))]="$type"
          ;;
      esac
  done < <(ack --help-types)

  arguments[$(( ${#arguments[@]} + 1 ))]="--type=[restrict to files of given type]:filetype:(${ack_types[@]})"
  arguments[$(( ${#arguments[@]} + 1 ))]="--notype=[restrict to files other than given type]:notfiletype:(${ack_types[@]})"
  arguments[$(( ${#arguments[@]} + 1 ))]="*:files:_files"

  _arguments -S $arguments
}

compdef _ack2_completion ack