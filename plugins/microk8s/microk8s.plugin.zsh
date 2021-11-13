# ---------------------------------------------------------- #
# Aliases and Completions for MicroK8s (https://microk8s.io) #
# Author: Shaun Tabone (https://github.com/xontab)           #
# ---------------------------------------------------------- #

# Helper function to cache and load completions
_microk8s_cache_completion() {
  local cache="${ZSH_CACHE_DIR}/microk8s_$(echo $1)_completion"
  if [[ ! -f $cache ]]; then
    $2 $cache
  fi

  [[ -f $cache ]] && source $cache
}

# ---------------------------------------------------------- #
# microk8s.enable                                            #
# ALIAS: me                                                  #
# ---------------------------------------------------------- #
_microk8s_enable_get_command_list() {
  microk8s.enable --help | tail -n +7 | awk '{$1=$1;print}'
}

_microk8s_enable() {
   compadd -X "MicroK8s Addons" $(_microk8s_enable_get_command_list)
}

compdef _microk8s_enable microk8s.enable
alias me='microk8s.enable'

# ---------------------------------------------------------- #
# microk8s.disable                                           #
# ALIAS: mdi                                                 #
# ---------------------------------------------------------- #
_microk8s_disable_get_command_list() {
  microk8s.disable --help | tail -n +7 | awk '{$1=$1;print}'
}

_microk8s_disable() {
  compadd -X "MicroK8s Addons" $(_microk8s_disable_get_command_list)
}

compdef _microk8s_disable microk8s.disable
alias mdi='microk8s.disable'

# ---------------------------------------------------------- #
# microk8s.kubectl                                           #
# ALIAS: mk                                                  #
# ---------------------------------------------------------- #
_microk8s_kubectl_completion() {
  if [ $commands[microk8s.kubectl] ]; then
    microk8s.kubectl 2>/dev/null >/dev/null && microk8s.kubectl completion zsh | sed 's/__start_kubectl kubectl/__start_kubectl microk8s.kubectl/g' >$1
  fi
}

_microk8s_cache_completion 'kubectl' _microk8s_kubectl_completion

alias mk='microk8s.kubectl'

# ---------------------------------------------------------- #
# microk8s.helm                                              #
# ALIAS: mh                                                  #
# ---------------------------------------------------------- #
_microk8s_helm_completion() {
  if [ $commands[microk8s.helm] ]; then
    microk8s.helm completion zsh | sed 's/__start_helm helm/__start_helm microk8s.helm/g' >$1
  fi
}

_microk8s_cache_completion 'helm' _microk8s_helm_completion

alias mh='microk8s.helm'

# ---------------------------------------------------------- #
# Other Aliases                                              #
# ---------------------------------------------------------- #
alias mco='microk8s.config'
alias mct='microk8s.ctr'
alias mis='microk8s.istio'
alias mst='microk8s.start'
alias msts='microk8s.status'
alias msp='microk8s.stop'
