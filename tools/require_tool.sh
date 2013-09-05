__require_tool_version_compare ()
{
  (
    # Locally ignore failures, otherwise we'll exit whenever $1 and $2
    # are not equal!
    set +e

awk_strverscmp='
  # Use only awk features that work with 7th edition Unix awk (1978).
  # My, what an old awk you have, Mr. Solaris!
  END {
    while (length(v1) || length(v2)) {
      # Set d1 to be the next thing to compare from v1, and likewise for d2.
      # Normally this is a single character, but if v1 and v2 contain digits,
      # compare them as integers and fractions as strverscmp does.
      if (v1 ~ /^[0-9]/ && v2 ~ /^[0-9]/) {
	# Split v1 and v2 into their leading digit string components d1 and d2,
	# and advance v1 and v2 past the leading digit strings.
	for (len1 = 1; substr(v1, len1 + 1) ~ /^[0-9]/; len1++) continue
	for (len2 = 1; substr(v2, len2 + 1) ~ /^[0-9]/; len2++) continue
	d1 = substr(v1, 1, len1); v1 = substr(v1, len1 + 1)
	d2 = substr(v2, 1, len2); v2 = substr(v2, len2 + 1)
	if (d1 ~ /^0/) {
	  if (d2 ~ /^0/) {
	    # Compare two fractions.
	    while (d1 ~ /^0/ && d2 ~ /^0/) {
	      d1 = substr(d1, 2); len1--
	      d2 = substr(d2, 2); len2--
	    }
	    if (len1 != len2 && ! (len1 && len2 && substr(d1, 1, 1) == substr(d2, 1, 1))) {
	      # The two components differ in length, and the common prefix
	      # contains only leading zeros.  Consider the longer to be less.
	      d1 = -len1
	      d2 = -len2
	    } else {
	      # Otherwise, compare as strings.
	      d1 = "x" d1
	      d2 = "x" d2
	    }
	  } else {
	    # A fraction is less than an integer.
	    exit 1
	  }
	} else {
	  if (d2 ~ /^0/) {
	    # An integer is greater than a fraction.
	    exit 2
	  } else {
	    # Compare two integers.
	    d1 += 0
	    d2 += 0
	  }
	}
      } else {
	# The normal case, without worrying about digits.
	if (v1 == "") d1 = v1; else { d1 = substr(v1, 1, 1); v1 = substr(v1,2) }
	if (v2 == "") d2 = v2; else { d2 = substr(v2, 1, 1); v2 = substr(v2,2) }
      }
      if (d1 < d2) exit 1
      if (d1 > d2) exit 2
    }
  }
'
    awk "$awk_strverscmp" v1="$1" v2="$2" /dev/null
    case $? in
      1)  echo '<';;
      0)  echo '=';;
      2)  echo '>';;
    esac
  )
}


__require_tool_fatal ()
{
    echo $@ >/dev/stderr
    return 1
}

# Usage: require_tool program version
# Returns: 0 if $1 version if greater equals than $2, 1 otherwise.
# In case of error, message is written on error output.
#
# Example: require_tool gcc 4.6
# Use GCC environment variable if defined instead of lookup for the tool
# in the environment.
require_tool ()
{
  envvar_name=$(echo $1 | tr '[:lower:]' '[:upper:]')
  tool=$(printenv $envvar_name || echo $1)
  local version=$($tool --version 2>/dev/null| \
    sed -n 's/.*[^0-9.]\([0-9]*\.[0-9.]*\).*/\1/p;q')
  if test x"$version" = x ; then
      echo "$tool is required" >/dev/stderr
      return 1
  fi
  case $(__require_tool_version_compare "$2" "$version") in
    '>')
	  echo "$1 $2 or better is required: this is $tool $version" >/dev/stderr
	  return 1
	  ;;
  esac
}

usage() {
    cat <<EOF
NAME
    require_tool.sh - Ensure version of a tool is greater than the one expected

SYNOPSYS
    require_tool.sh [ -h ]
                    [ --help ]
                    [ TOOL MIN_VERSION ]

DESCRIPTION
    TOOL is the name or path of the program to check. If the name is specified, its
    path is deduced from PATH environment variable. If environment variable TOOL
    (in upper-case characters) is defined, considers its value as path to the tool.

    MIN_VERSION is a string representing the minimum required version.

BEHAVIOR
    * locate path to the program.
    * execute $ TOOL_PATH --version
    * extract version from standard output.
    * compare this version to the expected one.

OPTIONS
    -h --help
        Display this message and exit 0

ERRORS
    if program is not found or its version is prior to expected version,
    a message is written to error output.

EXIT VALUE
    returns 0 if program version if greater equals than expected version,
    returns 1 otherwise.

EXAMPLE
    $ require_tool.sh emacs 23
    $ CC=g++ require_tool.sh cc 4.6
    $ require_tool.sh zsh 4.5

EOF
}

for arg in $@; do
    case $arg in
        -h|--help)
            usage
            exit 0
            ;;
    esac
done
if [ $# -gt 2 ] ; then
    echo "ERROR: expecting 2 parameters. Please see option --help"
    exit 1
fi

require_tool $@
