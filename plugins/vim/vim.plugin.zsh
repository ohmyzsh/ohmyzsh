# Vim helper plugin.
# Aliases
alias svim='sudo vim'

# Colorize the source of a file and create a html file.
code2html() {
  vim $@ +'syn on' +'set background=dark' +'colorscheme pablo' +'TOhtml' +'w' +'qa' &>/dev/null
}
