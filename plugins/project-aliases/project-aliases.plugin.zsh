# project-aliases - Zsh plugin to auto-load and clean project-specific aliases from .proj_aliases, keeping your shell organized and project-ready.
# Copyright (C) 2025 David Vigo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

# ===========================
#  Project Aliases Plugin
# ===========================
# Loads aliases defined in .proj_aliases of each project when entering its folder.
# Cleans previous aliases when leaving the project.
# ===========================

CURRENT_PROJECT=""
PROJECT_ALIASES_LIST=()
TRUST_DB="${XDG_CONFIG_HOME:-$HOME/.config}/project-aliases/trusted"

# Find project root (contains .proj_aliases or .git)
function find_project_root() {
    local dir="$1"
    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.proj_aliases" || -d "$dir/.git" ]]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
    echo ""
}

# Remove aliases from previous project
function unset_project_aliases() {
    for alias_name in "${PROJECT_ALIASES_LIST[@]}"; do
        unalias "$alias_name" 2>/dev/null
    done
    PROJECT_ALIASES_LIST=()
}

# Calculate hash of a file portably
function _project_aliases_hash() {
    local file="$1"
    if (( $+commands[shasum] )); then
        shasum -a 256 "$file" 2>/dev/null | awk '{print $1}'
    elif (( $+commands[sha256sum] )); then
        sha256sum "$file" 2>/dev/null | awk '{print $1}'
    elif (( $+commands[md5sum] )); then
        md5sum "$file" 2>/dev/null | awk '{print $1}'
    elif (( $+commands[md5] )); then
        md5 -q "$file" 2>/dev/null
    else
        # Safe fallback if no hashing command exists (uses file modification time and size)
        local stats
        stats=$(stat -f "%m%z" "$file" 2>/dev/null || stat -c "%Y%s" "$file" 2>/dev/null || echo "00")
        echo "legacy-$stats"
    fi
}

# Check if a .proj_aliases file is trusted
function check_project_aliases_trusted() {
    local file="$1"
    local abs_path
    abs_path=$(realpath "$file" 2>/dev/null || readlink -f "$file" 2>/dev/null || echo "$file")
    
    if [[ ! -f "$TRUST_DB" ]]; then
        return 1
    fi
    
    local current_hash
    current_hash=$(_project_aliases_hash "$file")
    
    local line
    local found=1
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        local entry_hash="${line%% *}"
        local entry_path="${line#* }"
        # Strip leading/trailing space
        entry_path="${entry_path#${entry_path%%[![:space:]]*}}"
        entry_path="${entry_path%${entry_path##*[![:space:]]}}"
        
        if [[ "$entry_hash" == "$current_hash" && "$entry_path" == "$abs_path" ]]; then
            found=0
            break
        fi
    done < "$TRUST_DB"
    return $found
}

# Add current .proj_aliases to trusted database
function allow_project_aliases() {
    local file="$CURRENT_PROJECT/.proj_aliases"
    local abs_path
    abs_path=$(realpath "$file" 2>/dev/null || readlink -f "$file" 2>/dev/null || echo "$file")
    
    local current_hash
    current_hash=$(_project_aliases_hash "$file")
    
    mkdir -p "$(dirname "$TRUST_DB")"
    
    if [[ -f "$TRUST_DB" ]]; then
        local temp_db="${TRUST_DB}.tmp"
        local line
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local entry_path="${line#* }"
            entry_path="${entry_path#${entry_path%%[![:space:]]*}}"
            entry_path="${entry_path%${entry_path##*[![:space:]]}}"
            if [[ "$entry_path" != "$abs_path" ]]; then
                echo "$line" >> "$temp_db"
            fi
        done < "$TRUST_DB"
        mv "$temp_db" "$TRUST_DB" 2>/dev/null
    fi
    
    echo "${current_hash} ${abs_path}" >> "$TRUST_DB"
}

# Remove current .proj_aliases from trusted database
function deny_project_aliases() {
    local file="$CURRENT_PROJECT/.proj_aliases"
    local abs_path
    abs_path=$(realpath "$file" 2>/dev/null || readlink -f "$file" 2>/dev/null || echo "$file")
    
    if [[ -f "$TRUST_DB" ]]; then
        local temp_db="${TRUST_DB}.tmp"
        local line
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local entry_path="${line#* }"
            entry_path="${entry_path#${entry_path%%[![:space:]]*}}"
            entry_path="${entry_path%${entry_path##*[![:space:]]}}"
            if [[ "$entry_path" != "$abs_path" ]]; then
                echo "$line" >> "$temp_db"
            fi
        done < "$TRUST_DB"
        mv "$temp_db" "$TRUST_DB" 2>/dev/null
    fi
}

# Load aliases from a file and store names
function load_project_aliases_file() {
    local file="$1"
    # Extract alias names from the file
    local names=($(grep -oE '^alias[[:space:]]+[a-zA-Z0-9_-]+' "$file" | awk '{print $2}'))
    
    # Source the file to define the aliases
    source "$file"

    # Store names in PROJECT_ALIASES_LIST
    for name in "${names[@]}"; do
        PROJECT_ALIASES_LIST+=("$name")
    done
}

# Load aliases for the current project
function load_project_aliases() {
    local dir=$(pwd)
    local root=$(find_project_root "$dir")

    # Not in any project -> clean aliases
    if [[ -z "$root" ]]; then
        if [[ -n "$CURRENT_PROJECT" ]]; then
            unset_project_aliases
            CURRENT_PROJECT=""
            echo "[project-aliases] Project aliases removed."
        fi
        return
    fi

    # Changed project -> clean and reload
    if [[ "$root" != "$CURRENT_PROJECT" ]]; then
        unset_project_aliases
        CURRENT_PROJECT="$root"
        if [[ -f "$root/.proj_aliases" ]]; then
            if check_project_aliases_trusted "$root/.proj_aliases"; then
                load_project_aliases_file "$root/.proj_aliases"
                echo "[project-aliases] Aliases loaded from $root/.proj_aliases"
            else
                echo "[project-aliases] Warning: Untrusted .proj_aliases found. Run 'palias allow' to trust and load it."
            fi
        fi
    fi
}

# Command to list, edit, reload, allow, or deny aliases
function palias() {
    case "$1" in
        list)
            if [[ ${#PROJECT_ALIASES_LIST[@]} -eq 0 ]]; then
                echo "No active project aliases."
            else
                echo "Active project aliases:"
                for name in "${PROJECT_ALIASES_LIST[@]}"; do
                    alias "$name"
                done
            fi
            ;;
        edit)
            if [[ -n "$CURRENT_PROJECT" && -f "$CURRENT_PROJECT/.proj_aliases" ]]; then
                ${EDITOR:-nano} "$CURRENT_PROJECT/.proj_aliases"
            else
                echo "No .proj_aliases file found in the current project."
            fi
            ;;
        reload)
            if [[ -n "$CURRENT_PROJECT" && -f "$CURRENT_PROJECT/.proj_aliases" ]]; then
                if check_project_aliases_trusted "$CURRENT_PROJECT/.proj_aliases"; then
                    unset_project_aliases
                    load_project_aliases_file "$CURRENT_PROJECT/.proj_aliases"
                    echo "[project-aliases] Aliases reloaded from $CURRENT_PROJECT/.proj_aliases"
                else
                    echo "[project-aliases] Warning: .proj_aliases is not trusted. Run 'palias allow' to trust and load it."
                fi
            else
                echo "[project-aliases] No active project or missing .proj_aliases file."
            fi
            ;;
        allow)
            if [[ -n "$CURRENT_PROJECT" && -f "$CURRENT_PROJECT/.proj_aliases" ]]; then
                allow_project_aliases
                unset_project_aliases
                load_project_aliases_file "$CURRENT_PROJECT/.proj_aliases"
                echo "[project-aliases] Loaded and trusted aliases for project: $CURRENT_PROJECT"
            else
                echo "[project-aliases] No active project or missing .proj_aliases file."
            fi
            ;;
        deny|disallow)
            if [[ -n "$CURRENT_PROJECT" && -f "$CURRENT_PROJECT/.proj_aliases" ]]; then
                deny_project_aliases
                unset_project_aliases
                echo "[project-aliases] Untrusted and unloaded aliases for project: $CURRENT_PROJECT"
            else
                echo "[project-aliases] No active project or missing .proj_aliases file."
            fi
            ;;
        *)
            echo "Usage: palias [list|edit|reload|allow|deny]"
            ;;
    esac
}

# Hook when changing directory
autoload -U add-zsh-hook
add-zsh-hook chpwd load_project_aliases

# Initial load
load_project_aliases
