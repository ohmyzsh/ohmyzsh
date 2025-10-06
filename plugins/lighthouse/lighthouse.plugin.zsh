open_lighthouse_ticket () {
  if [ ! -f .lighthouse-url ]; then
    echo "There is no .lighthouse-url file in the current directory..."
    return 0
  fi

  lighthouse_url=$(cat .lighthouse-url)
  echo "Opening ticket #$1"
  open_command "$lighthouse_url/tickets/$1"
}

alias lho='open_lighthouse_ticket'
