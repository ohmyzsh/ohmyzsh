#!/bin/zsh

# Proxmox VE Oh My Zsh Plugin
# Description: Convenient functions for managing Proxmox VE via API

# Configuration variables (set these in your .zshrc)
# export PROXMOX_HOST="your-proxmox-server.com"
# export PROXMOX_USER="root@pam"  # or user@realm
# export PROXMOX_PASSWORD="your-password"
# export PROXMOX_NODE="your-node-name"  # optional, defaults to first available node

# Colors for output
PVE_GREEN='\033[0;32m'
PVE_RED='\033[0;31m'
PVE_YELLOW='\033[1;33m'
PVE_BLUE='\033[0;34m'
PVE_NC='\033[0m' # No Color

# Check if required variables are set
_pve_check_config() {
    if [[ -z "$PROXMOX_HOST" || -z "$PROXMOX_USER" || -z "$PROXMOX_PASSWORD" ]]; then
        echo "${PVE_RED}Error: Please set PROXMOX_HOST, PROXMOX_USER, and PROXMOX_PASSWORD environment variables${PVE_NC}"
        echo "Example:"
        echo "export PROXMOX_HOST=\"proxmox.example.com\""
        echo "export PROXMOX_USER=\"root@pam\""
        echo "export PROXMOX_PASSWORD=\"your-password\""
        return 1
    fi
    return 0
}

# Get authentication ticket
_pve_get_ticket() {
    if ! _pve_check_config; then
        return 1
    fi
    
    local response=$(curl -s -k -d "username=$PROXMOX_USER&password=$PROXMOX_PASSWORD" \
        "https://$PROXMOX_HOST:8006/api2/json/access/ticket" 2>/dev/null)
    
    if [[ $? -ne 0 ]] || [[ -z "$response" ]]; then
        echo "${PVE_RED}Error: Failed to connect to Proxmox server${PVE_NC}" >&2
        return 1
    fi
    
    echo "$response" | grep -o '"ticket":"[^"]*"' | cut -d'"' -f4
}

# Get CSRF token
_pve_get_csrf() {
    if ! _pve_check_config; then
        return 1
    fi
    
    local response=$(curl -s -k -d "username=$PROXMOX_USER&password=$PROXMOX_PASSWORD" \
        "https://$PROXMOX_HOST:8006/api2/json/access/ticket" 2>/dev/null)
    
    echo "$response" | grep -o '"CSRFPreventionToken":"[^"]*"' | cut -d'"' -f4
}

# Get default node if not set
_pve_get_node() {
    if [[ -n "$PROXMOX_NODE" ]]; then
        echo "$PROXMOX_NODE"
        return
    fi
    
    local ticket=$(_pve_get_ticket)
    if [[ -z "$ticket" ]]; then
        return 1
    fi
    
    local nodes=$(curl -s -k -H "Authorization: PVEAuthCookie=$ticket" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes" 2>/dev/null)
    
    echo "$nodes" | grep -o '"node":"[^"]*"' | head -1 | cut -d'"' -f4
}

# List all VMs
pve-list() {
    echo "${PVE_BLUE}Fetching VM list...${PVE_NC}"
    
    local ticket=$(_pve_get_ticket)
    if [[ -z "$ticket" ]]; then
        return 1
    fi
    
    local node=$(_pve_get_node)
    if [[ -z "$node" ]]; then
        echo "${PVE_RED}Error: Could not determine node${PVE_NC}"
        return 1
    fi
    
    local vms=$(curl -s -k -H "Authorization: PVEAuthCookie=$ticket" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes/$node/qemu" 2>/dev/null)
    
    if [[ -z "$vms" ]]; then
        echo "${PVE_RED}Error: Failed to fetch VM list${PVE_NC}"
        return 1
    fi
    
    echo "${PVE_GREEN}VMs on node $node:${PVE_NC}"
    echo "ID\tName\t\tStatus\t\tMemory\tCPUs"
    echo "──────────────────────────────────────────────"
    
    echo "$vms" | grep -E '"(vmid|name|status|mem|cpus)"' | \
    awk -F'"' '
    /vmid/ { id = $4 }
    /name/ { name = $4 }
    /status/ { status = $4 }
    /mem/ { mem = $4 }
    /cpus/ { cpus = $4; printf "%s\t%-12s\t%s\t\t%sMB\t%s\n", id, name, status, mem, cpus }
    '
}

# Start a VM
pve-start() {
    if [[ -z "$1" ]]; then
        echo "${PVE_RED}Usage: pve-start <vmid>${PVE_NC}"
        return 1
    fi
    
    echo "${PVE_BLUE}Starting VM $1...${PVE_NC}"
    
    local ticket=$(_pve_get_ticket)
    local csrf=$(_pve_get_csrf)
    local node=$(_pve_get_node)
    
    if [[ -z "$ticket" || -z "$csrf" || -z "$node" ]]; then
        return 1
    fi
    
    local result=$(curl -s -k -X POST \
        -H "Authorization: PVEAuthCookie=$ticket" \
        -H "CSRFPreventionToken: $csrf" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes/$node/qemu/$1/status/start" 2>/dev/null)
    
    if echo "$result" | grep -q '"success":1'; then
        echo "${PVE_GREEN}VM $1 start command sent successfully${PVE_NC}"
    else
        echo "${PVE_RED}Failed to start VM $1${PVE_NC}"
        return 1
    fi
}

# Stop a VM
pve-stop() {
    if [[ -z "$1" ]]; then
        echo "${PVE_RED}Usage: pve-stop <vmid>${PVE_NC}"
        return 1
    fi
    
    echo "${PVE_BLUE}Stopping VM $1...${PVE_NC}"
    
    local ticket=$(_pve_get_ticket)
    local csrf=$(_pve_get_csrf)
    local node=$(_pve_get_node)
    
    if [[ -z "$ticket" || -z "$csrf" || -z "$node" ]]; then
        return 1
    fi
    
    local result=$(curl -s -k -X POST \
        -H "Authorization: PVEAuthCookie=$ticket" \
        -H "CSRFPreventionToken: $csrf" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes/$node/qemu/$1/status/stop" 2>/dev/null)
    
    if echo "$result" | grep -q '"success":1'; then
        echo "${PVE_GREEN}VM $1 stop command sent successfully${PVE_NC}"
    else
        echo "${PVE_RED}Failed to stop VM $1${PVE_NC}"
        return 1
    fi
}

# Shutdown a VM gracefully
pve-shutdown() {
    if [[ -z "$1" ]]; then
        echo "${PVE_RED}Usage: pve-shutdown <vmid>${PVE_NC}"
        return 1
    fi
    
    echo "${PVE_BLUE}Shutting down VM $1...${PVE_NC}"
    
    local ticket=$(_pve_get_ticket)
    local csrf=$(_pve_get_csrf)
    local node=$(_pve_get_node)
    
    if [[ -z "$ticket" || -z "$csrf" || -z "$node" ]]; then
        return 1
    fi
    
    local result=$(curl -s -k -X POST \
        -H "Authorization: PVEAuthCookie=$ticket" \
        -H "CSRFPreventionToken: $csrf" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes/$node/qemu/$1/status/shutdown" 2>/dev/null)
    
    if echo "$result" | grep -q '"success":1'; then
        echo "${PVE_GREEN}VM $1 shutdown command sent successfully${PVE_NC}"
    else
        echo "${PVE_RED}Failed to shutdown VM $1${PVE_NC}"
        return 1
    fi
}

# Get VM status
pve-status() {
    if [[ -z "$1" ]]; then
        echo "${PVE_RED}Usage: pve-status <vmid>${PVE_NC}"
        return 1
    fi
    
    local ticket=$(_pve_get_ticket)
    local node=$(_pve_get_node)
    
    if [[ -z "$ticket" || -z "$node" ]]; then
        return 1
    fi
    
    local status=$(curl -s -k -H "Authorization: PVEAuthCookie=$ticket" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes/$node/qemu/$1/status/current" 2>/dev/null)
    
    if [[ -z "$status" ]]; then
        echo "${PVE_RED}Failed to get status for VM $1${PVE_NC}"
        return 1
    fi
    
    echo "${PVE_GREEN}Status for VM $1:${PVE_NC}"
    echo "$status" | grep -E '"(status|name|cpus|mem|uptime)"' | \
    awk -F'"' '
    /status/ && !/qmpstatus/ { printf "Status: %s\n", $4 }
    /name/ { printf "Name: %s\n", $4 }
    /cpus/ { printf "CPUs: %s\n", $4 }
    /mem/ { printf "Memory: %sMB\n", $4 }
    /uptime/ { printf "Uptime: %s seconds\n", $4 }
    '
}

# Show cluster status
pve-cluster() {
    echo "${PVE_BLUE}Fetching cluster status...${PVE_NC}"
    
    local ticket=$(_pve_get_ticket)
    if [[ -z "$ticket" ]]; then
        return 1
    fi
    
    local nodes=$(curl -s -k -H "Authorization: PVEAuthCookie=$ticket" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes" 2>/dev/null)
    
    if [[ -z "$nodes" ]]; then
        echo "${PVE_RED}Failed to fetch cluster status${PVE_NC}"
        return 1
    fi
    
    echo "${PVE_GREEN}Cluster Nodes:${PVE_NC}"
    echo "Node\t\tStatus\tCPU%\tMemory%\tUptime"
    echo "──────────────────────────────────────────────"
    
    echo "$nodes" | grep -E '"(node|status|cpu|mem|uptime)"' | \
    awk -F'"' '
    /node/ { node = $4 }
    /status/ { status = $4 }
    /cpu/ { cpu = sprintf("%.1f", $4*100) }
    /mem/ { mem = $4 }
    /uptime/ { uptime = $4; printf "%-12s\t%s\t%s%%\t%.1f%%\t%s\n", node, status, cpu, mem*100, uptime }
    '
}

# Show help
pve-help() {
    echo "${PVE_GREEN}Proxmox VE Oh My Zsh Plugin Commands:${PVE_NC}"
    echo ""
    echo "${PVE_BLUE}Configuration:${PVE_NC}"
    echo "  Set these environment variables in your .zshrc:"
    echo "  export PROXMOX_HOST=\"proxmox.example.com\""
    echo "  export PROXMOX_USER=\"root@pam\""
    echo "  export PROXMOX_PASSWORD=\"your-password\""
    echo "  export PROXMOX_NODE=\"node-name\"  # optional"
    echo ""
    echo "${PVE_BLUE}Commands:${PVE_NC}"
    echo "  pve-list           List all VMs"
    echo "  pve-start <vmid>   Start a VM"
    echo "  pve-stop <vmid>    Force stop a VM"
    echo "  pve-shutdown <vmid> Gracefully shutdown a VM"
    echo "  pve-status <vmid>  Get VM status"
    echo "  pve-cluster       Show cluster status"
    echo "  pve-help          Show this help"
}

# Aliases for convenience
alias pvels='pve-list'
alias pvestart='pve-start'
alias pvestop='pve-stop'
alias pvestatus='pve-status'
alias pvecluster='pve-cluster'

# Tab completion for VM IDs
_pve_vm_completion() {
    if ! _pve_check_config >/dev/null 2>&1; then
        return
    fi
    
    local ticket=$(_pve_get_ticket 2>/dev/null)
    if [[ -z "$ticket" ]]; then
        return
    fi
    
    local node=$(_pve_get_node 2>/dev/null)
    if [[ -z "$node" ]]; then
        return
    fi
    
    local vms=$(curl -s -k -H "Authorization: PVEAuthCookie=$ticket" \
        "https://$PROXMOX_HOST:8006/api2/json/nodes/$node/qemu" 2>/dev/null)
    
    if [[ -n "$vms" ]]; then
        local vmids=($(echo "$vms" | grep -o '"vmid":[0-9]*' | cut -d':' -f2))
        compadd $vmids
    fi
}

# Register completions
compdef _pve_vm_completion pve-start pve-stop pve-shutdown pve-status

echo "${PVE_GREEN}Proxmox VE plugin loaded! Type 'pve-help' for usage information.${PVE_NC}"
