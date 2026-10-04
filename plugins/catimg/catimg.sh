################################################################################
# catimg script by Eduardo San Martin Morote aka Posva                         #
# https://posva.net                                                            #
#                                                                              #
# Output the content of an image to the stdout using the 256 colors of the     #
# terminal.                                                                    #
# GitHub: https://github.com/posva/catimg                                      #
################################################################################

# this should come from outside, either `magick` or `convert`
# from imagemagick v7 and ahead `convert` is deprecated
: ${CONVERT_CMD:=convert}

function help() {
  echo "Usage catimg [-h] [-w width] [-c char] img"
  echo "By default char is \"  \" and w is the terminal width"
}

# VARIABLES
COLOR_FILE=$(dirname $0)/colors.png
CHAR="  "

WIDTH=""
IMG=""

while getopts qw:c:h opt; do
  case "$opt" in
    w) WIDTH="$OPTARG" ;;
    c) CHAR="$OPTARG" ;;
    h) help; exit ;;
    *) help ; exit 1;;
    esac
  done

while [ "$1" ]; do
  IMG="$1"
  shift
done

if [ "$IMG" = "" -o ! -f "$IMG" ]; then
  help
  exit 1
fi

if [ ! "$WIDTH" ]; then
  COLS=$(expr $(tput cols) "/" $(echo -n "$CHAR" | wc -c))
else
  COLS=$(expr $WIDTH "/" $(echo -n "$CHAR" | wc -c))
fi
WIDTH=$($CONVERT_CMD "$IMG" -print "%w\n" /dev/null)
if [ "$WIDTH" -gt "$COLS" ]; then
  WIDTH=$COLS
fi

REMAP=""
if $CONVERT_CMD "$IMG" -resize $COLS\> +dither -remap $COLOR_FILE /dev/null ; then
  REMAP="-remap $COLOR_FILE"
else
  echo "The version of convert is too old, don't expect good results :(" >&2
  # $CONVERT_CMD "$IMG" -colors 256 PNG8:tmp.png
  # IMG="tmp.png"
fi

# Display the image
I=0
$CONVERT_CMD "$IMG" -resize $COLS\> +dither `echo $REMAP` txt:- 2>/dev/null |
sed -e 's/.*none.*/NO NO NO/g' -e '1d;s/^.*(\(.*\)[,)].*$/\1/g;y/,/ /' |
while read R G B f; do
  if [ ! "$R" = "NO" ]; then
    if [ "$R" -eq "$G" -a "$G" -eq "$B" ]; then
      ((
      I++,
      IDX = 232 + R * 23 / 255
      ))
    else
      ((
      I++,
      IDX = 16
      + R * 5 / 255 * 36
      + G * 5 / 255 * 6
      + B * 5 / 255
      ))
    fi
    #echo "$R,$G,$B: $IDX"
    echo -ne "\e[48;5;${IDX}m${CHAR}"
  else
    (( I++ ))
    echo -ne "\e[0m${CHAR}"
  fi
  # New lines
  (( $I % $WIDTH )) || echo -e "\e[0m"
done
