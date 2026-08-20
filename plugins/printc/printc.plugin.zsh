# load included completion function into existing
# ~/.zcompdump-${SHORT_HOST}-${ZSH_VERSION} file
autoload -Uz _printc && compinit -d $ZSH_COMPDUMP

# Wrapper function to call included printc script
function printc() {
  zsh $ZSH/plugins/printc/printc_scpt $@
}


