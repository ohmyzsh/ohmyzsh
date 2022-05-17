# Autocompletion for oc, the command line interface for OpenShift
#
# Author: https://github.com/kevinkirkup
# Added correction to bug https://bugzilla.redhat.com/show_bug.cgi?id=2024427 for oc clients 4.9 and 4.10

if [ $commands[oc] ]; then
  source <(oc completion zsh | sed -e 's/kubectl/oc/g')
fi
