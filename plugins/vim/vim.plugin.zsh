# Vim helper plugin.
# Colorize the source of a file and create a html file.
code2html() {
  vim $@ +'syn on' +'set background=dark' +'colorscheme pablo' +'TOhtml' +'w' +'qa' &>/dev/null
}
