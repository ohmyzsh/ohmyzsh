# Global variables to cache the last known .terraform directory and its corresponding workspace name
__TERRAFORM_WORKSPACE_CACHE=""
__TERRAFORM_DIRECTORY_CACHE=""

# Function to find the .terraform directory in the current or any parent directory
__find_terraform_directory() {
  local current_dir="$PWD"
  while [[ "$current_dir" != "/" ]]; do
    if [[ -d "${current_dir}/.terraform" ]]; then
      echo "${current_dir}/.terraform"
      return
    fi
    current_dir="$(dirname "$current_dir")"
  done
}

# Function to update the Terraform workspace prompt based on the current working directory, utilizing the global cache variables
__update_terraform_workspace_prompt() {
  local terraform_dir="$(__find_terraform_directory)"
  if [[ -n "$terraform_dir" && "$terraform_dir" != "$__TERRAFORM_DIRECTORY_CACHE" ]]; then
    __TERRAFORM_DIRECTORY_CACHE="$terraform_dir"
    local workspace="$(terraform -chdir="$(dirname "${terraform_dir%/}")" workspace show 2>/dev/null)"
    __TERRAFORM_WORKSPACE_CACHE="$workspace"
  elif [[ -z "$terraform_dir" ]]; then
    __TERRAFORM_DIRECTORY_CACHE=""
    __TERRAFORM_WORKSPACE_CACHE=""
  fi
}

# Hooks to call the update function when the working directory changes or before each prompt is displayed
autoload -Uz add-zsh-hook
add-zsh-hook chpwd __update_terraform_workspace_prompt
add-zsh-hook precmd __update_terraform_workspace_prompt

complete -o nospace -C $(which terraform) terraform