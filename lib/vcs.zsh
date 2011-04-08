function vcs_name() {
  for vcs in $VCS; do
    if ${vcs}_check; then
      echo $vcs
      break
    fi
  done
}

# get the name of the branch we are on

function vcs_prompt_info() {
  local vcs=$(vcs_name)
  [[ -n $vcs ]] && ${vcs}_prompt_info
}

function parse_vcs_dirty () {
  local vcs=$(vcs_name)
  [[ -n $vcs ]] && parse_${vcs}_dirty
}

# get the status of the working tree
function vcs_prompt_status() {
  local vcs=$(vcs_name)
  [[ -n $vcs ]] && ${vcs}_prompt_status
}
