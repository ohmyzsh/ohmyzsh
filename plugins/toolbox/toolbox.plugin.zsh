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

alias tbe="toolbox enter"
alias tbr="toolbox run"
