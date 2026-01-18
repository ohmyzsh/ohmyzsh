# hcloud plugin for oh-my-zsh
# Hetzner Cloud CLI: https://github.com/hetznercloud/cli

if (( ! $+commands[hcloud] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `hcloud`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_hcloud" ]]; then
  typeset -g -A _comps
  autoload -Uz _hcloud
  _comps[hcloud]=_hcloud
fi

hcloud completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_hcloud" &|

# Main alias
alias hc='hcloud'

# Context management
alias hcctx='hcloud context'
alias hcctxls='hcloud context list'
alias hcctxu='hcloud context use'
alias hcctxc='hcloud context create'
alias hcctxd='hcloud context delete'
alias hcctxa='hcloud context active'

# Server management
alias hcs='hcloud server'
alias hcsl='hcloud server list'
alias hcsc='hcloud server create'
alias hcsd='hcloud server delete'
alias hcsdesc='hcloud server describe'
alias hcspoff='hcloud server poweroff'
alias hcspon='hcloud server poweron'
alias hcsr='hcloud server reboot'
alias hcsreset='hcloud server reset'
alias hcssh='hcloud server ssh'
alias hcse='hcloud server enable-rescue'
alias hcsdr='hcloud server disable-rescue'
alias hcsip='hcloud server ip'

# Server actions
alias hcsa='hcloud server attach-iso'
alias hcsda='hcloud server detach-iso'
alias hcscip='hcloud server change-type'

# Volume management
alias hcv='hcloud volume'
alias hcvl='hcloud volume list'
alias hcvc='hcloud volume create'
alias hcvd='hcloud volume delete'
alias hcvdesc='hcloud volume describe'
alias hcva='hcloud volume attach'
alias hcvda='hcloud volume detach'
alias hcvr='hcloud volume resize'

# Network management
alias hcn='hcloud network'
alias hcnl='hcloud network list'
alias hcnc='hcloud network create'
alias hcnd='hcloud network delete'
alias hcndesc='hcloud network describe'
alias hcnas='hcloud network add-subnet'
alias hcnds='hcloud network delete-subnet'
alias hcnar='hcloud network add-route'
alias hcndr='hcloud network delete-route'

# Floating IP management
alias hcfip='hcloud floating-ip'
alias hcfipl='hcloud floating-ip list'
alias hcfipc='hcloud floating-ip create'
alias hcfipd='hcloud floating-ip delete'
alias hcfipdesc='hcloud floating-ip describe'
alias hcfipa='hcloud floating-ip assign'
alias hcfipua='hcloud floating-ip unassign'

# SSH key management
alias hcsk='hcloud ssh-key'
alias hcskl='hcloud ssh-key list'
alias hcskc='hcloud ssh-key create'
alias hcskd='hcloud ssh-key delete'
alias hcskdesc='hcloud ssh-key describe'
alias hcsku='hcloud ssh-key update'

# Image management
alias hci='hcloud image'
alias hcil='hcloud image list'
alias hcid='hcloud image delete'
alias hcidesc='hcloud image describe'
alias hciu='hcloud image update'

# Firewall management
alias hcfw='hcloud firewall'
alias hcfwl='hcloud firewall list'
alias hcfwc='hcloud firewall create'
alias hcfwd='hcloud firewall delete'
alias hcfwdesc='hcloud firewall describe'
alias hcfwar='hcloud firewall add-rule'
alias hcfwdr='hcloud firewall delete-rule'
alias hcfwas='hcloud firewall apply-to-resource'
alias hcfwrs='hcloud firewall remove-from-resource'

# Load balancer management
alias hclb='hcloud load-balancer'
alias hclbl='hcloud load-balancer list'
alias hclbc='hcloud load-balancer create'
alias hclbd='hcloud load-balancer delete'
alias hclbdesc='hcloud load-balancer describe'
alias hclbu='hcloud load-balancer update'
alias hclbas='hcloud load-balancer add-service'
alias hclbds='hcloud load-balancer delete-service'
alias hclbat='hcloud load-balancer add-target'
alias hclbdt='hcloud load-balancer delete-target'

# Certificate management
alias hccert='hcloud certificate'
alias hccertl='hcloud certificate list'
alias hccertc='hcloud certificate create'
alias hccertd='hcloud certificate delete'
alias hccertdesc='hcloud certificate describe'
alias hccertu='hcloud certificate update'

# Datacenter and location info
alias hcdc='hcloud datacenter list'
alias hcloc='hcloud location list'
alias hcst='hcloud server-type list'
alias hcit='hcloud image list --type system'
