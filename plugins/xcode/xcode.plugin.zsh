alias xcb='xcodebuild'
alias xcdd='rm -rf ~/Library/Developer/Xcode/DerivedData/*'
alias xcp='xcode-select --print-path'
alias xcsel='sudo xcode-select --switch'

# original author: @subdigital
# source: https://gist.github.com/subdigital/5420709
function xc {
  local xcode_files
  xcode_files=(${1:-.}/{*.{xcworkspace,xcodeproj,swiftpm},Package.swift}(N))

  if [[ ${#xcode_files} -eq 0 ]]; then
    echo "No Xcode files found in ${1:-the current directory}." >&2
    return 1
  fi

  local active_path
  active_path=${"$(xcode-select -p)"%%/Contents/Developer*}
  echo "Found ${xcode_files[1]}. Opening with ${active_path}"

  # If Xcode is already opened in another Desk, we need this double call
  # with -g to open the project window in the current Desk and focus it.
  # See https://github.com/ohmyzsh/ohmyzsh/issues/10384
  if command pgrep -q "^Xcode"; then
    open -g -a "$active_path" "${xcode_files[1]}"
  fi
  open -a "$active_path" "${xcode_files[1]}"
}

# Opens a file or files in the Xcode IDE. Multiple files are opened in multi-file browser
# original author: @possen
function xx {
  if [[ $# == 0 ]]; then
    echo "Specify file(s) to open in xcode."
    return 1
  fi
  echo "${xcode_files}"
  open -a "Xcode.app" "$@"
}

# "Xcode-Select by Version" - select Xcode by just version number
# Uses naming convention:
#  - different versions of Xcode are named Xcode-<version>.app or stored
#     in a folder named Xcode-<version>
#  - the special version name "default" refers to the "default" Xcode.app with no suffix
function xcselv {
  emulate -L zsh
  if [[ $# == 0 ]]; then
    echo "xcselv: error: no option or argument given" >&2
    echo "xcselv: see 'xcselv -h' for help" >&2
    return 1
  elif [[ $1 == "-p" ]]; then
    _omz_xcode_print_active_version
    return
  elif [[ $1 == "-l" ]]; then
    _omz_xcode_list_versions
    return
  elif [[ $1 == "-L" ]]; then
    _omz_xcode_list_versions short
    return
  elif [[ $1 == "-h" ]]; then
    _omz_xcode_print_xcselv_usage
    return 0
  elif [[ $1 == -* && $1 != "-" ]]; then
    echo "xcselv: error: unrecognized option: $1" >&2
    echo "xcselv: see 'xcselv -h' for help" >&2
    return 1
  fi
  # Main case: "xcselv <version>" to select a version
  local version=$1
  local -A xcode_versions
  _omz_xcode_locate_versions
  if [[ -z ${xcode_versions[$version]} ]]; then
    echo "xcselv: error: Xcode version '$version' not found" >&2
    return 1
  fi
  app="${xcode_versions[$version]}"
  echo "selecting Xcode $version: $app"
  xcsel "$app"
}

function _omz_xcode_print_xcselv_usage {
  cat << EOF >&2
Usage:
  xcselv <version>
  xcselv [options]

Options:
  <version> set the active Xcode version
  -h        print this help message and exit
  -p        print the active Xcode version
  -l        list installed Xcode versions (long human-readable form)
  -L        list installed Xcode versions (short form, version names only)
EOF
}

# Parses the Xcode version from a filename based on our conventions
# Only meaningful when called from other _omz_xcode functions
function _omz_xcode_parse_versioned_file {
  local file=$1
  local basename=${app:t}
  local dir=${app:h}
  local parent=${dir:t}
  #echo "parent=$parent basename=$basename verstr=$verstr ver=$ver" >&2
  local verstr
  if [[ $parent == Xcode* ]]; then
    if [[ $basename == "Xcode.app" ]]; then
      # "Xcode-<version>/Xcode.app" format
      verstr=$parent
    else
      # Both file and parent dir are versioned. Reject.
      return 1;
    fi
  elif [[ $basename == Xcode*.app ]]; then
    # "Xcode-<version>.app" format
    verstr=${basename:r}
  else
    # Invalid naming pattern
    return 1;
  fi

  local ver=${verstr#Xcode}
  ver=${ver#[- ]}
  if [[ -z $ver ]]; then
    # Unversioned "default" installation location
    ver="default"
  fi
  print -- "$ver"
}

# Print the active version, using xcselv's notion of versions
function _omz_xcode_print_active_version {
  emulate -L zsh
  local -A xcode_versions
  local versions version active_path
  _omz_xcode_locate_versions
  active_path=$(xcode-select -p)
  active_path=${active_path%%/Contents/Developer*}
  versions=(${(kni)xcode_versions})
  for version ($versions); do
    if [[ "${xcode_versions[$version]}" == $active_path ]]; then
      printf "%s (%s)\n" $version $active_path
      return
    fi
  done
  printf "%s (%s)\n" "<unknown>" $active_path
}

# Locates all the installed versions of Xcode on this system, for this
# plugin's internal use.
# Populates the $xcode_versions associative array variable
# Caller should local-ize $xcode_versions with `local -A xcode_versions`
function _omz_xcode_locate_versions {
  emulate -L zsh
  local -a app_dirs
  local app_dir apps app xcode_ver
  # In increasing precedence order:
  app_dirs=(/Applications $HOME/Applications)
  for app_dir ($app_dirs); do
    apps=( $app_dir/Xcode*.app(N) $app_dir/Xcode*/Xcode.app(N) )
    for app ($apps); do
      xcode_ver=$(_omz_xcode_parse_versioned_file $app)
      if [[ $? != 0 ]]; then
        continue
      fi
      xcode_versions[$xcode_ver]=$app
    done
  done
}

function _omz_xcode_list_versions {
  emulate -L zsh
  local -A xcode_versions
  _omz_xcode_locate_versions
  local width=1 width_i versions do_short=0
  if [[ $1 == "short" ]]; then
    do_short=1
  fi
  versions=(${(kni)xcode_versions})
  for version ($versions); do
    if [[ $#version > $width ]]; then
      width=$#version;
    fi
  done
  for version ($versions); do
    if [[ $do_short == 1 ]]; then
      printf "%s\n" $version
    else
      printf "%-${width}s -> %s\n" "$version" "${xcode_versions[$version]}"
    fi
  done
}

function simulator {
  local devfolder
  devfolder="$(xcode-select -p)"

  # Xcode ≤ 5.x
  if [[ -d "${devfolder}/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app" ]]; then
    open "${devfolder}/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app"
  # Xcode ≥ 6.x
  elif [[ -d "${devfolder}/Applications/iOS Simulator.app" ]]; then
    open "${devfolder}/Applications/iOS Simulator.app"
  # Xcode ≥ 7.x
  else
    open "${devfolder}/Applications/Simulator.app"
  fi
}
