
# Displays the current USD value of crypto coins from the api.coinmarketcap.com
#
# See README.md for details

coinmarketcap() {
  curl -s https://api.coinmarketcap.com/v1/ticker/ > $HOME/.coinmarketcap.json || exit 1
  curl -s https://api.coinmarketcap.com/v1/ticker/bitcoin-gold/ > $HOME/.coinmarketcap-btg.json || exit 1
  if [[ -n "$1" ]]; then
    readonly COIN=$1
    readonly SYMBOLS=(`cat $HOME/.coinmarketcap.json | grep -Po '(?<="symbol": ")[^"]*' | awk -F "\n" '{print $1}' || exit 1`)
    readonly PRICE=(`cat $HOME/.coinmarketcap.json | grep -Po '(?<="price_usd": ")[^"]*' | awk -F "\n" '{print $1}' || exit 1`)
    if [[ "${COIN}" == "ALL" ]]; then
      for ((i=0; i<${#SYMBOLS[*]}; i++)); do
        echo -e ${SYMBOLS[i]}"\t : \t"${PRICE[i]}
      done
    elif [[ "${COIN}" == "BTG" ]]; then
      readonly BTG_PRICE=(`cat $HOME/.coinmarketcap-btg.json | grep -Po '(?<="price_usd": ")[^"]*'`)
      echo -e ${BTG_PRICE}
    else
      for ((i=0; i<${#SYMBOLS[*]}; i++)); do
          if [[ "${SYMBOLS[i]}" == "${COIN}" ]]; then
            echo -e ${PRICE[i]}
          fi
      done
    fi
  else
    echo "Usage example for Bitcoin Gold: \"coin BTG\""
    echo "Usage example all crypto currencies: \"coin ALL\""
  fi
  return 1
}

alias coin=coinmarketcap
