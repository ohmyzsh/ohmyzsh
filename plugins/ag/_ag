#compdef ag
#autoload

typeset -A opt_args

# Took the liberty of not listing every option… specially aliases and -D
_ag () {
  local -a _1st_arguments
  _1st_arguments=(
    '--ackmate:Print results in AckMate-parseable format'
    {'-A','--after'}':[LINES] Print lines after match (Default: 2)'
    {'-B','--before'}':[LINES] Print lines before match (Default: 2)'
    '--break:Print newlines between matches in different files'
    '--nobreak:Do not print newlines between matches in different files'
    {'-c','--count'}':Only print the number of matches in each file'
    '--color:Print color codes in results (Default: On)'
    '--nocolor:Do not print color codes in results'
    '--color-line-number:Color codes for line numbers (Default: 1;33)'
    '--color-match:Color codes for result match numbers (Default: 30;43)'
    '--color-path:Color codes for path names (Default: 1;32)'
    '--column:Print column numbers in results'
    {'-H','--heading'}':Print file names (On unless searching a single file)'
    '--noheading:Do not print file names (On unless searching a single file)'
    '--line-numbers:Print line numbers even for streams'
    {'-C','--context'}':[LINES] Print lines before and after matches (Default: 2)'
    '-g:[PATTERN] Print filenames matching PATTERN'
    {'-l','--files-with-matches'}':Only print filenames that contain matches'
    {'-L','--files-without-matches'}':Only print filenames that do not contain matches'
    '--no-numbers:Do not print line numbers'
    {'-o','--only-matching'}':Prints only the matching part of the lines'
    '--print-long-lines:Print matches on very long lines (Default: 2k characters)'
    '--passthrough:When searching a stream, print all lines even if they do not match'
    '--silent:Suppress all log messages, including errors'
    '--stats:Print stats (files scanned, time taken, etc.)'
    '--vimgrep:Print results like vim :vimgrep /pattern/g would'
    {'-0','--null'}':Separate filenames with null (for "xargs -0")'

    {'-a','--all-types'}':Search all files (does not include hidden files / .gitignore)'
    '--depth:[NUM] Search up to NUM directories deep (Default: 25)'
    {'-f','--follow'}':Follow symlinks'
    {'-G','--file-search-regex'}':[PATTERN] Limit search to filenames matching PATTERN'
    '--hidden:Search hidden files (obeys .*ignore files)'
    {'-i','--ignore-case'}':Match case insensitively'
    '--ignore:[PATTERN] Ignore files/directories matching PATTERN'
    {'-m','--max-count'}':[NUM] Skip the rest of a file after NUM matches (Default: 10k)'
    {'-p','--path-to-agignore'}':[PATH] Use .agignore file at PATH'
    {'-Q','--literal'}':Do not parse PATTERN as a regular expression'
    {'-s','--case-sensitive'}':Match case'
    {'-S','--smart-case'}':Insensitive match unless PATTERN has uppercase (Default: On)'
    '--search-binary:Search binary files for matches'
    {'-t','--all-text'}':Search all text files (Hidden files not included)'
    {'-u','--unrestricted'}':Search all files (ignore .agignore and _all_)'
    {'-U','--skip-vcs-ignores'}':Ignore VCS files (stil obey .agignore)'
    {'-v','--invert-match'}':Invert match'
    {'-w','--word-regexp'}':Only match whole words'
    {'-z','--search-zip'}':Search contents of compressed (e.g., gzip) files'

    '--list-file-types:list of supported file types'
  )

  if [[ $words[-1] =~ "^-" ]]; then
    _describe -t commands "ag options" _1st_arguments && ret=0
  else
    _files && ret=0
  fi
}
