
#--------------------------------------------------------------------#
# Setup                                                              #
#--------------------------------------------------------------------#

# Precmd hooks for initializing the library and starting pty's
autoload -Uz add-zsh-hook

# Asynchronous suggestions are generated in a pty
zmodload zsh/zpty
