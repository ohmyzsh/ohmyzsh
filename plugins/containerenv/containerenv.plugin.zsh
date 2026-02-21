# Container Environment Plugin for Oh-My-Zsh
# Provides functions to access container environment variables from /run/.containerenv
# Usage: containerenv_engine, containerenv_name, containerenv_id, etc.

# Check if we're in a container and the file exists
_containerenv_file="/run/.containerenv"

# Function to read a specific key from the containerenv file
_containerenv_get() {
    local key="$1"
    
    if [[ ! -f "$_containerenv_file" ]]; then
        echo "Error: Not running in a container or $_containerenv_file not found" >&2
        return 1
    fi
    
    local value=$(grep "^${key}=" "$_containerenv_file" | cut -d'=' -f2-)
    
    if [[ -z "$value" ]]; then
        echo "Error: Key '$key' not found in $_containerenv_file" >&2
        return 1
    fi
    
    # Strip surrounding double quotes if present (e.g. name="container-name" in file)
    value="${value#\"}"
    value="${value%\"}"

    echo "$value"
}

# Individual accessor functions
containerenv_engine() {
    _containerenv_get "engine"
}

containerenv_name() {
    _containerenv_get "name"
}

containerenv_id() {
    _containerenv_get "id"
}

containerenv_image() {
    _containerenv_get "image"
}

containerenv_imageid() {
    _containerenv_get "imageid"
}

containerenv_rootless() {
    local raw ret
    raw="$(_containerenv_get "rootless" 2>/dev/null)"
    ret=$?
    if [[ $ret -ne 0 || -z "$raw" ]]; then
        echo "false"
        return 0
    fi
    case "${(L)raw}" in
        (1|true|yes)  echo "true" ;;
        (*)            echo "false" ;;
    esac
}

containerenv_graphrootmounted() {
    _containerenv_get "graphRootMounted"
}

# Function to display all container environment variables
containerenv_all() {
    if [[ ! -f "$_containerenv_file" ]]; then
        echo "Error: Not running in a container or $_containerenv_file not found" >&2
        return 1
    fi
    
    cat "$_containerenv_file"
}

# Function to check if running in a container
is_containerized() {
    [[ -f "$_containerenv_file" ]]
}

# Optional: Add a prompt segment function for use with oh-my-zsh themes
containerenv_prompt_info() {
    if is_containerized; then
        local container_name=$(containerenv_name 2>/dev/null)
        if [[ -n "$container_name" ]]; then
            local segment="📦"
            [[ "$(containerenv_rootless 2>/dev/null)" == "true" ]] && segment="${segment} 🔓"
            echo "${segment} ${container_name}"
        fi
    fi
}
