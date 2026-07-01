# Autocompletion for oc, the command line interface for OpenShift
#
# Author: https://github.com/kevinkirkup

if [ $commands[oc] ]; then
  source <(oc completion zsh)
  compdef _oc oc

  OC_PLUGIN_INITIALIZED=no

  function oc_prompt_info() {
    [ -n "$OPENSHIFT_NAMESPACE" ] && echo -ne "\n(openshift: $OPENSHIFT_NAMESPACE)\n\x00"
  }

  # TODO Completion
  function oc-namespace() {
    # TODO -h / --help
    # TODO "--clear" should unset variable
    # when nothing passed should show usage
    # TODO Rename this to "oc" and call binary oc with full path
    # so this can become a subcommand: "oc localenv namespace xyz"

    [ -n "$1" ] \
      && export OPENSHIFT_NAMESPACE="$1" \
      || unset OPENSHIFT_NAMESPACE

    [ "$OC_PLUGIN_INITIALIZED" = "no" ] && {
      export PROMPT='$(oc_prompt_info)'"$PROMPT"
      # TODO Check if text "oc_prompt_info" is in "$PROMPT"
      # instead set this variable
      export OC_PLUGIN_INITIALIZED=yes
    }
  }

  alias oc='oc ${OPENSHIFT_NAMESPACE:+"--namespace=$OPENSHIFT_NAMESPACE"}'
else
  echo "oc plugin error: oc command not found..."
fi
