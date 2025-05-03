function toolbox_prompt_info() {
  [[ -f /run/.toolboxenv ]] && echo "⬢"
}

function toolbox_prompt_name() {
  [[ -f /run/.containerenv ]] || return

  # This command reads the /run/.containerenv file line by line and extracts the
  # container name from it by looking for the `name="..."` line, and uses -F\" to
  # split the line by double quotes. Then all % characters are replaced with %%
  # to escape them for the prompt.
  awk -F\" '/name/ { gsub(/%/, "%%", $2); print $2 }' /run/.containerenv
}

function toolbox_prompt() {
  if [[ -f /run/.containerenv ]]; then
    local toolbox_name=$(toolbox_prompt_name)
    if [[ -n "$toolbox_name" ]]; then
      # Modify the HOST variable to display toolbox name in the prompt
      # This ensures that '%m' in prompt formats shows "toolbx-{name}" instead of just "toolbx"
      HOST="toolbx-$toolbox_name"
    fi
  fi
}

# Modify prompt to include toolbox name when inside a toolbox container
toolbox_prompt

alias tbe="toolbox enter"
alias tbr="toolbox run"
