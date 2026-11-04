#compdef skopeo
compdef _skopeo skopeo

# zsh completion for skopeo                               -*- shell-script -*-

__skopeo_debug() {
  local file="$BASH_COMP_DEBUG_FILE"
  if [[ -n ${file} ]]; then
    echo "$*" >> "${file}"
  fi
}

_skopeo() {
  local shell_comp_directive_error=1
  local shell_comp_directive_no_space=2
  local shell_comp_directive_no_file_comp=4
  local shell_comp_directive_filter_file_ext=8
  local shell_comp_directive_filter_dirs=16
  local shell_comp_directive_keep_order=32

  local last_param last_char flag_prefix request_comp out directive comp last_comp no_space keep_order
  local -a completions

  __skopeo_debug "\n========= starting completion logic =========="
  __skopeo_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

  # The user could have moved the cursor backwards on the command-line.
  # We need to trigger completion from the $CURRENT location, so we need
  # to truncate the command-line ($words) up to the $CURRENT location.
  # (We cannot use $CURSOR as its value does not work when a command is an alias.)
  words=("${=words[1,CURRENT]}")
  __skopeo_debug "Truncated words[*]: ${words[*]},"

  last_param=${words[-1]}
  last_char=${last_param[-1]}
  __skopeo_debug "last_param: ${last_param}, last_char: ${last_char}"

  # For zsh, when completing a flag with an = (e.g., skopeo -n=<TAB>)
  # completions must be prefixed with the flag
  setopt local_options BASH_REMATCH
  if [[ "${last_param}" =~ '-.*=' ]]; then
    # We are dealing with a flag with an =
    flag_prefix="-P ${BASH_REMATCH}"
  fi

  # Prepare the command to obtain completions
  request_comp="${words[1]} __complete ${words[2,-1]}"
  if [ "${last_char}" = "" ]; then
    # If the last parameter is complete (there is a space following it)
    # We add an extra empty parameter so we can indicate this to the go completion code.
    __skopeo_debug "Adding extra empty parameter"
    request_comp="${request_comp} \"\""
  fi

  __skopeo_debug "About to call: eval ${request_comp}"

  # Use eval to handle any environment variables and such
  out=$(eval ${request_comp} 2>/dev/null)
  __skopeo_debug "completion output: ${out}"

  # Extract the directive integer following a : from the last line
  local last_line
  while IFS='\n' read -r line; do
    last_line=${line}
  done < <(printf "%s\n" "${out[@]}")
  __skopeo_debug "last line: ${last_line}"

  if [ "${last_line[1]}" = : ]; then
    directive=${last_line[2,-1]}
    # Remove the directive including the : and the newline
    local suffix
    (( suffix=${#last_line}+2))
    out=${out[1,-$suffix]}
  else
    # There is no directive specified.  Leave $out as is.
    __skopeo_debug "No directive found.  Setting do default"
    directive=0
  fi

  __skopeo_debug "directive: ${directive}"
  __skopeo_debug "completions: ${out}"
  __skopeo_debug "flag_prefix: ${flag_prefix}"

  if [ $((directive & shell_comp_directive_error)) -ne 0 ]; then
    __skopeo_debug "Completion received error. Ignoring completions."
    return
  fi

  local active_help_marker="_active_help_ "
  local end_index=${#active_help_marker}
  local start_index=$((${#active_help_marker}+1))
  local has_active_help=0
  while IFS='\n' read -r comp; do
    # Check if this is an active_help statement (i.e., prefixed with $active_help_marker)
    if [ "${comp[1,$end_index]}" = "$active_help_marker" ];then
      __skopeo_debug "Active_help found: $comp"
      comp="${comp[$start_index,-1]}"
      if [ -n "$comp" ]; then
        compadd -x "${comp}"
        __skopeo_debug "Active_help will need delimiter"
        has_active_help=1
      fi

      continue
    fi

    if [ -n "$comp" ]; then
      # If requested, completions are returned with a description.
      # The description is preceded by a TAB character.
      # For zsh's _describe, we need to use a : instead of a TAB.
      # We first need to escape any : as part of the completion itself.
      comp=${comp//:/\\:}

      local tab="$(printf '\t')"
      comp=${comp//$tab/:}

      __skopeo_debug "Adding completion: ${comp}"
      completions+=${comp}
      last_comp=$comp
    fi
  done < <(printf "%s\n" "${out[@]}")

  # Add a delimiter after the active_help statements, but only if:
  # - there are completions following the active_help statements, or
  # - file completion will be performed (so there will be choices after the active_help)
  if [ $has_active_help -eq 1 ]; then
    if [ ${#completions} -ne 0 ] || [ $((directive & shell_comp_directive_no_file_comp)) -eq 0 ]; then
      __skopeo_debug "Adding active_help delimiter"
      compadd -x "--"
      has_active_help=0
    fi
  fi

  if [ $((directive & shell_comp_directive_no_space)) -ne 0 ]; then
    __skopeo_debug "Activating nospace."
    no_space="-S ''"
  fi

  if [ $((directive & shell_comp_directive_keep_order)) -ne 0 ]; then
    __skopeo_debug "Activating keep order."
    keep_order="-V"
  fi

  if [ $((directive & shell_comp_directive_filter_file_ext)) -ne 0 ]; then
    # File extension filtering
    local filtering_cmd
    filtering_cmd='_files'
    for filter in ${completions[@]}; do
      if [ ${filter[1]} != '*' ]; then
        # zsh requires a glob pattern to do file filtering
        filter="\*.$filter"
      fi
      filtering_cmd+=" -g $filter"
    done
    filtering_cmd+=" ${flag_prefix}"

    __skopeo_debug "File filtering command: $filtering_cmd"
    _arguments '*:filename:'"$filtering_cmd"
  elif [ $((directive & shell_comp_directive_filter_dirs)) -ne 0 ]; then
    # File completion for directories only
    local subdir
    subdir="${completions[1]}"
    if [ -n "$subdir" ]; then
      __skopeo_debug "Listing directories in $subdir"
      pushd "${subdir}" >/dev/null 2>&1
    else
      __skopeo_debug "Listing directories in ."
    fi

    local result
    _arguments '*:dirname:_files -/'" ${flag_prefix}"
    result=$?
    if [ -n "$subdir" ]; then
      popd >/dev/null 2>&1
    fi
    return $result
  else
    __skopeo_debug "Calling _describe"
    if eval _describe $keep_order "completions" completions $flag_prefix $no_space; then
      __skopeo_debug "_describe found some completions"

      # Return the success of having called _describe
      return 0
    else
      __skopeo_debug "_describe did not find completions."
      __skopeo_debug "Checking if we should do file completion."
      if [ $((directive & shell_comp_directive_no_file_comp)) -ne 0 ]; then
        __skopeo_debug "deactivating file completion"

        # We must return an error code here to let zsh know that there were no
        # completions found by _describe; this is what will trigger other
        # matching algorithms to attempt to find completions.
        # For example zsh can match letters in the middle of words.
        return 1
      else
        # Perform file completion
        __skopeo_debug "Activating file completion"

        # We must return the result of this command, so it must be the
        # last command, or else we must store its result to return it.
        _arguments '*:filename:_files'" ${flag_prefix}"
      fi
    fi
  fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_skopeo" ]; then
  _skopeo
fi

