################################################################################
# catimg script by Eduardo San Martin Morote aka Posva                         #
# http://posva.net                                                             #
#                                                                              #
# Ouput the content of an image to the stdout using the 256 colors of the      #
# terminal.                                                                    #
# Github: https://github.com/posva/catimg                                      #
################################################################################

if [[ -x  `which convert` ]]; then
  function catimg() {
    zsh $ZSH/plugins/catimg/catimg.sh $@
  }
else
  echo "catimg need convert (ImageMagick) to work)"
fi
