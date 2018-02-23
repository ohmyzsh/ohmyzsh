# Autocompletion for kubectl, the command line interface for Kubernetes
#
# Author: https://github.com/pstadler

if [ $commands[kubectl] ]; then

  # Let kubectl load up the autocompletions
  source <(kubectl completion zsh)

  # This command is used ALOT both below and in daily life
  alias k=kubectl

  # Drop into an interactive terminal on a container
  alias keti='k exec -ti'

  # Manage configuration quickly to switch contexts between local, dev ad staging.
  alias kcgc='k config get-contexts'
  alias kcuc='k config use-context'
  alias kcsc='k config set-context'
  alias kcdc='k config delete-context'
  alias kccc='k config current-context'

  # Pod management.
  alias kgp='k get pods -owide'
  alias kgpa='k get pods -owide --all-namespaces'
  alias klp='k logs pods'
  alias kep='k edit pods'
  alias kdp='k describe pods'
  alias kdelp='k delete pods'
  alias ktp='k top pods'
  
  # Horizontal Pod Autoscaler Management
  alias kdhpa='k describe hpa'
  alias kehpa='k edit hpa'
  alias kdelhpa='k delete hpa'

  # Service management.
  alias kgs='k get svc'
  alias kgsa='k get svc --all-namespaces'
  alias kes='k edit svc'
  alias kds='k describe svc'
  alias kdels='k delete svc'

  # Secret management
  alias kgsec='k get secret'
  alias kdsec='k describe secret'
  alias kdelsec='k delete secret'

  # Deployment management.
  alias kgd='k get deployment'
  alias ked='k edit deployment'
  alias kdd='k describe deployment'
  alias kdeld='k delete deployment'
  alias ksd='k scale deployment'
  alias krsd='k rollout status deployment'

  # Rollout management.
  alias kgrs='k get rs'
  alias krh='k rollout history'
  alias kru='k rollout undo'

  # Node management
  alias kgn='k get nodes'
  alias kdn='k describe nodes'
  alias ktn='k top nodes'

  # Port Forwarding
  alias kpf='k port-forward'

else
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  printf "${RED}kubectl plugin loaded in .oh-my-zsh but cannot find kubectl binary in current PATH:\n $PATH${NC}" 1>&2
fi

