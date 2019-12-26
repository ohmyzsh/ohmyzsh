# Commands for MicroK8s

# ------------------------------------------------------------------------------
# microk8s.enable
# ALIAS: me
# ------------------------------------------------------------------------------
_microk8s_enable_get_command_list() {
  microk8s.enable --help | tail -n +7 | awk '{$1=$1;print}'
}

_microk8s_enable() {
  compadd `_microk8s_enable_get_command_list`
}

compdef _microk8s_enable microk8s.enable
alias me='microk8s.enable'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# microk8s.disable
# ALIAS: mdi
# ------------------------------------------------------------------------------
_microk8s_disable_get_command_list() {
  microk8s.disable --help | tail -n +7 | awk '{$1=$1;print}'
}

_microk8s_disable() {
  compadd `_microk8s_disable_get_command_list`
}

compdef _microk8s_disable microk8s.disable
alias mdi='microk8s.disable'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# microk8s.kubectl
# ALIAS: mk
# ------------------------------------------------------------------------------
if [ $commands[microk8s.kubectl] ]; then
    source <(microk8s.kubectl completion zsh | sed 's/__start_kubectl kubectl/__start_kubectl microk8s.kubectl/g')
fi

alias mk='microk8s.kubectl'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# microk8s.helm
# ALIAS: mh
# ------------------------------------------------------------------------------
if [ $commands[microk8s.helm] ]; then
    source <(microk8s.helm completion zsh | sed 's/__start_helm helm/__start_helm microk8s.helm/g')
fi

alias mh='microk8s.helm'
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Other Aliases
# ------------------------------------------------------------------------------
alias mco='microk8s.config'
alias mct='microk8s.ctr'
alias mis='microk8s.istio'
alias mst='microk8s.start'
alias msts='microk8s.status'
alias msp='microk8s.stop'
# ------------------------------------------------------------------------------