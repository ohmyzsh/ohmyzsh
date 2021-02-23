# Autocompletion for deno.
# https://deno.land/
# Copy from plugins/helm/helm.plugin.zsh

if [ $commands[deno] ]; then
  source <(deno completion zsh)
fi
