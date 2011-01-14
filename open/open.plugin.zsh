# Universal file opener

case "$OSTYPE" in
   cygwin)
      opener="cygstart"
      ;;
   linux*)
      opener="xdg-open"
      ;;
   darwin*)
      opener="open"
      ;;
  *)
      opener=""
      ;;
esac

function o {
    for i in $*; do
        if [ "$opener" != "" ]; then
            $opener "$i"
        fi
    done
}
