#!/usr/bin/env zsh
# EternalHist Plugin for Oh My Zsh
# Advanced persistent command history with multi-remote synchronization

# Default configuration
ETERNALHIST_LOCAL_FILE="${ETERNALHIST_LOCAL_FILE:-$HOME/.eternal_history}"
ETERNALHIST_DEFAULT_REMOTE="${ETERNALHIST_DEFAULT_REMOTE:-}"
ETERNALHIST_SYNC_ALL_REMOTES="${ETERNALHIST_SYNC_ALL_REMOTES:-false}"
ETERNALHIST_AUTO_SYNC="${ETERNALHIST_AUTO_SYNC:-false}"
ETERNALHIST_SEARCH_LIMIT="${ETERNALHIST_SEARCH_LIMIT:-100}"
ETERNALHIST_COLOR_OUTPUT="${ETERNALHIST_COLOR_OUTPUT:-true}"

# Internal variables
_ETERNALHIST_PLUGIN_DIR="${0:A:h}"

# Utility functions
_eternalhist_log() {
    local level="$1"
    shift
    if [[ "$ETERNALHIST_DEBUG" == "true" ]]; then
        echo "[eternalhist:$level] $*" >&2
    fi
}

_eternalhist_error() {
    echo "eternalhist: error: $*" >&2
}

_eternalhist_warn() {
    echo "eternalhist: warning: $*" >&2
}

_eternalhist_colorize() {
    if [[ "$ETERNALHIST_COLOR_OUTPUT" == "true" ]]; then
        case "$1" in
            "red") echo -e "\033[31m$2\033[0m" ;;
            "green") echo -e "\033[32m$2\033[0m" ;;
            "yellow") echo -e "\033[33m$2\033[0m" ;;
            "blue") echo -e "\033[34m$2\033[0m" ;;
            "purple") echo -e "\033[35m$2\033[0m" ;;
            "cyan") echo -e "\033[36m$2\033[0m" ;;
            *) echo "$2" ;;
        esac
    else
        echo "$2"
    fi
}

# Core eternal history functions
_eternalhist_ensure_file() {
    touch "$ETERNALHIST_LOCAL_FILE"
    chmod 600 "$ETERNALHIST_LOCAL_FILE"
}

_eternalhist_add_entry() {
    local cmd="$1"
    local timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local pwd="$(pwd)"
    local exit_code="${2:-0}"
    
    _eternalhist_ensure_file
    echo "$timestamp|$pwd|$exit_code|$cmd" >> "$ETERNALHIST_LOCAL_FILE"
    _eternalhist_log "debug" "Added entry: $cmd"
}

_eternalhist_search_local() {
    local search_terms=("$@")
    local search_cmd="cat '$ETERNALHIST_LOCAL_FILE'"
    
    _eternalhist_ensure_file
    
    for term in "${search_terms[@]}"; do
        search_cmd="$search_cmd | grep -i '$term'"
    done
    
    if [[ -n "$ETERNALHIST_SEARCH_LIMIT" ]] && [[ "$ETERNALHIST_SEARCH_LIMIT" -gt 0 ]]; then
        search_cmd="$search_cmd | tail -n $ETERNALHIST_SEARCH_LIMIT"
    fi
    
    eval "$search_cmd"
}

# Remote configuration functions
_eternalhist_get_remotes() {
    if [[ -n "$ETERNALHIST_REMOTES" ]]; then
        echo "$ETERNALHIST_REMOTES" | tr ',' ' '
    fi
}

_eternalhist_get_remote_var() {
    local remote="$1"
    local var="$2"
    local remote_upper="$(echo "$remote" | tr '[:lower:]' '[:upper:]')"
    local var_name="ETERNALHIST_${remote_upper}_${var}"
    echo "${(P)var_name}"
}

_eternalhist_is_remote_enabled() {
    local remote="$1"
    local enabled="$(_eternalhist_get_remote_var "$remote" "ENABLED")"
    [[ "$enabled" == "true" ]]
}

_eternalhist_list_remotes() {
    local remotes=($(_eternalhist_get_remotes))
    
    if [[ ${#remotes[@]} -eq 0 ]]; then
        echo "No remotes configured."
        return 0
    fi
    
    printf "%-15s %-10s %-10s %-20s %s\n" "NAME" "ENABLED" "PRIORITY" "PROVIDER" "PATH"
    printf "%-15s %-10s %-10s %-20s %s\n" "----" "-------" "--------" "--------" "----"
    
    for remote in "${remotes[@]}"; do
        local enabled="$(_eternalhist_get_remote_var "$remote" "ENABLED")"
        local priority="$(_eternalhist_get_remote_var "$remote" "PRIORITY")"
        local provider="$(_eternalhist_get_remote_var "$remote" "PROVIDER")"
        local path="$(_eternalhist_get_remote_var "$remote" "PATH")"
        
        enabled="${enabled:-false}"
        priority="${priority:-0}"
        provider="${provider:-unknown}"
        path="${path:-unknown}"
        
        local color="red"
        [[ "$enabled" == "true" ]] && color="green"
        
        printf "%-15s %s %-10s %-20s %s\n" \
            "$remote" \
            "$(_eternalhist_colorize "$color" "$enabled")" \
            "$priority" \
            "$provider" \
            "$path"
    done
}

_eternalhist_test_remote() {
    local remote="$1"
    local provider="$(_eternalhist_get_remote_var "$remote" "PROVIDER")"
    
    case "$provider" in
        "ssh")
            local host="$(_eternalhist_get_remote_var "$remote" "HOST")"
            local user="$(_eternalhist_get_remote_var "$remote" "USER")"
            local ssh_key="$(_eternalhist_get_remote_var "$remote" "SSH_KEY")"
            local port="${$(_eternalhist_get_remote_var "$remote" "PORT"):-22}"
            
            local ssh_opts="-o ConnectTimeout=10 -o BatchMode=yes"
            [[ -n "$ssh_key" ]] && ssh_opts="$ssh_opts -i $ssh_key"
            [[ -n "$port" ]] && ssh_opts="$ssh_opts -p $port"
            
            if ssh $ssh_opts "${user}@${host}" "echo 'Connection test successful'" 2>/dev/null; then
                _eternalhist_colorize "green" "✓ SSH connection to $remote successful"
                return 0
            else
                _eternalhist_colorize "red" "✗ SSH connection to $remote failed"
                return 1
            fi
            ;;
        "dropbox"|"gdrive"|"s3")
            _eternalhist_warn "Test not implemented for provider: $provider"
            return 1
            ;;
        *)
            _eternalhist_error "Unknown provider: $provider"
            return 1
            ;;
    esac
}

# Sync functions (placeholder implementations)
_eternalhist_sync_remote() {
    local remote="$1"
    local provider="$(_eternalhist_get_remote_var "$remote" "PROVIDER")"
    
    if ! _eternalhist_is_remote_enabled "$remote"; then
        _eternalhist_log "debug" "Remote $remote is disabled, skipping sync"
        return 0
    fi
    
    _eternalhist_log "info" "Syncing with remote: $remote ($provider)"
    
    case "$provider" in
        "ssh")
            _eternalhist_sync_ssh "$remote"
            ;;
        "dropbox")
            _eternalhist_sync_dropbox "$remote"
            ;;
        "gdrive")
            _eternalhist_sync_gdrive "$remote"
            ;;
        "s3")
            _eternalhist_sync_s3 "$remote"
            ;;
        *)
            _eternalhist_error "Unsupported provider: $provider"
            return 1
            ;;
    esac
}

_eternalhist_sync_ssh() {
    local remote="$1"
    local host="$(_eternalhist_get_remote_var "$remote" "HOST")"
    local user="$(_eternalhist_get_remote_var "$remote" "USER")"
    local remote_path="$(_eternalhist_get_remote_var "$remote" "PATH")"
    local ssh_key="$(_eternalhist_get_remote_var "$remote" "SSH_KEY")"
    local port="$(_eternalhist_get_remote_var "$remote" "PORT")"
    
    local ssh_opts="-o ConnectTimeout=30"
    [[ -n "$ssh_key" ]] && ssh_opts="$ssh_opts -i $ssh_key"
    [[ -n "$port" ]] && ssh_opts="$ssh_opts -p $port"
    
    # Simple sync: upload local file to remote
    if scp $ssh_opts "$ETERNALHIST_LOCAL_FILE" "${user}@${host}:${remote_path}" 2>/dev/null; then
        _eternalhist_colorize "green" "✓ Successfully synced to $remote"
        return 0
    else
        _eternalhist_colorize "red" "✗ Failed to sync to $remote"
        return 1
    fi
}

# Placeholder sync functions for other providers
_eternalhist_sync_dropbox() {
    local remote="$1"
    _eternalhist_warn "Dropbox sync not yet implemented for remote: $remote"
    return 1
}

_eternalhist_sync_gdrive() {
    local remote="$1"
    _eternalhist_warn "Google Drive sync not yet implemented for remote: $remote"
    return 1
}

_eternalhist_sync_s3() {
    local remote="$1"
    _eternalhist_warn "S3 sync not yet implemented for remote: $remote"
    return 1
}

# Main eternalhist command
eternalhist() {
    # Handle empty command (show recent history)
    if [[ $# -eq 0 ]]; then
        _eternalhist_search_local | tail -n "${ETERNALHIST_SEARCH_LIMIT:-20}"
        return 0
    fi
    
    local cmd="$1"
    
    # Check for escape mechanism: \command means search for "command" literally
    if [[ "$cmd" = \\* ]]; then
        # Remove the escape backslash and treat as search term
        local escaped_term="${cmd#\\}"
        _eternalhist_search_local "$escaped_term" "${@:2}"
        
        # Also search current session history
        echo
        _eternalhist_colorize "blue" "=== Current Session History ==="
        local hist_cmd="history | grep -i '$escaped_term'"
        for term in "${@:2}"; do
            hist_cmd="$hist_cmd | grep -i '$term'"
        done
        eval "$hist_cmd"
        return 0
    fi
    
    # Check if first argument is a known command
    case "$cmd" in
        "add")
            shift
            local entry="$*"
            [[ -z "$entry" ]] && entry="$(history | tail -n 1 | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')"
            _eternalhist_add_entry "$entry"
            ;;
        "clear")
            read -q "?Are you sure you want to clear eternal history? (y/N) "
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                > "$ETERNALHIST_LOCAL_FILE"
                echo "Eternal history cleared."
            fi
            ;;
        "show")
            shift
            local limit="${1:-20}"
            tail -n "$limit" "$ETERNALHIST_LOCAL_FILE"
            ;;
        "stats")
            _eternalhist_ensure_file
            local total_lines="$(wc -l < "$ETERNALHIST_LOCAL_FILE")"
            local unique_commands="$(cut -d'|' -f4 "$ETERNALHIST_LOCAL_FILE" | sort | uniq | wc -l)"
            local oldest_entry="$(head -n 1 "$ETERNALHIST_LOCAL_FILE" | cut -d'|' -f1)"
            local newest_entry="$(tail -n 1 "$ETERNALHIST_LOCAL_FILE" | cut -d'|' -f1)"
            
            echo "Eternal History Statistics:"
            echo "  Total entries: $total_lines"
            echo "  Unique commands: $unique_commands"
            echo "  Oldest entry: ${oldest_entry:-N/A}"
            echo "  Newest entry: ${newest_entry:-N/A}"
            echo "  File location: $ETERNALHIST_LOCAL_FILE"
            ;;
        "sync")
            shift
            local target_remotes=("$@")
            if [[ ${#target_remotes[@]} -eq 0 ]]; then
                if [[ "$ETERNALHIST_SYNC_ALL_REMOTES" == "true" ]]; then
                    target_remotes=($(_eternalhist_get_remotes))
                elif [[ -n "$ETERNALHIST_DEFAULT_REMOTE" ]]; then
                    target_remotes=("$ETERNALHIST_DEFAULT_REMOTE")
                else
                    _eternalhist_error "No remotes specified and no default remote configured"
                    return 1
                fi
            fi
            
            for remote in "${target_remotes[@]}"; do
                _eternalhist_sync_remote "$remote"
            done
            ;;
        "remotes")
            shift
            local subcmd="$1"
            shift
            case "$subcmd" in
                "list"|"")
                    _eternalhist_list_remotes
                    ;;
                "test")
                    local remote="$1"
                    if [[ -z "$remote" ]]; then
                        _eternalhist_error "Remote name required for test"
                        return 1
                    fi
                    _eternalhist_test_remote "$remote"
                    ;;
                "add"|"remove"|"enable"|"disable")
                    _eternalhist_error "Remote management commands not yet implemented"
                    return 1
                    ;;
                *)
                    _eternalhist_error "Unknown remotes subcommand: $subcmd"
                    return 1
                    ;;
            esac
            ;;
        "config")
            echo "EternalHist Configuration:"
            echo "  Local file: $ETERNALHIST_LOCAL_FILE"
            echo "  Default remote: ${ETERNALHIST_DEFAULT_REMOTE:-none}"
            echo "  Auto sync: $ETERNALHIST_AUTO_SYNC"
            echo "  Configured remotes: ${ETERNALHIST_REMOTES:-none}"
            ;;
        "help"|"-h"|"--help")
            cat << 'EOF'
EternalHist - Advanced persistent command history

USAGE:
    eternalhist [SEARCH_TERMS...]   # Search eternal history (default behavior)
    eternalhist [COMMAND] [OPTIONS] # Execute specific command

COMMANDS:
    add [COMMAND]        Add command to eternal history
    clear               Clear all eternal history
    show [LIMIT]        Show recent eternal history entries
    stats               Display eternal history statistics
    sync [REMOTE...]    Synchronize with remote storage
    remotes             Manage remote configurations
        list            List all configured remotes
        test REMOTE     Test connection to remote
    config              Show current configuration
    help                Show this help message

SEARCH BEHAVIOR:
    eternalhist git commit          # Search for "git" AND "commit"
    eternalhist "git commit"        # Search for exact phrase "git commit"
    eternalhist \add something      # Search for "add" (escaped to avoid add command)
    eternalhist \sync               # Search for "sync" (escaped to avoid sync command)

EXAMPLES:
    eternalhist git                 # Search for git commands
    eternalhist docker run          # Search for docker run commands
    eternalhist \add file           # Search for "add file" (not add command)
    eternalhist add "custom cmd"    # Add custom command to history
    eternalhist sync primary        # Sync with primary remote
    eternalhist remotes list        # List all remotes
EOF
            ;;
        *)
            # Default behavior: treat as search terms
            _eternalhist_search_local "$@"
            
            # Also search current session history like original ht function
            echo
            _eternalhist_colorize "blue" "=== Current Session History ==="
            local hist_cmd="history"
            for term in "$@"; do
                hist_cmd="$hist_cmd | grep -i '$term'"
            done
            eval "$hist_cmd"
            ;;
    esac
}

# Backward compatibility with existing ht function
ht() {
    eternalhist "$@"
}

# Auto-add commands to eternal history (optional)
if [[ "$ETERNALHIST_AUTO_ADD" == "true" ]]; then
    preexec() {
        _eternalhist_add_entry "$1" 0
    }
fi

# Auto-sync on shell exit (optional)
if [[ "$ETERNALHIST_SYNC_ON_EXIT" == "true" ]]; then
    zshexit() {
        eternalhist sync >/dev/null 2>&1 &
    }
fi

_eternalhist_log "info" "EternalHist plugin loaded"