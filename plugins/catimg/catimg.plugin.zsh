################################################################################
# catimg script by Eduardo San Martin Morote aka Posva                         #
# https://posva.net                                                            #
#                                                                              #
# Output the content of an image to the stdout using the 256 colors of the     #
# terminal.                                                                    #
# GitHub: https://github.com/posva/catimg                                      #
################################################################################


function catimg() {
  if (( $+commands[magick] )); then
    CONVERT_CMD="magick" zsh $ZSH/plugins/catimg/catimg.sh $@
  elif (( $+commands[convert] )); then
    CONVERT_CMD="convert" zsh $ZSH/plugins/catimg/catimg.sh $@
  else
    echo "catimg need magick/convert (ImageMagick) to work)"
  fi
}
