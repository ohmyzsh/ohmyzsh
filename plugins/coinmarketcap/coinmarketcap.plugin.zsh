
# Displays the current USD value of crypto coins from the api.coinmarketcap.com
#
# See README.md for details

function coinmarketcap() {
  curl -s https://api.coinmarketcap.com/v1/ticker/ > $HOME/.coinmarketcap.json
  curl -s https://api.coinmarketcap.com/v1/ticker/bitcoin-gold/ > $HOME/.coinmarketcap-btg.json
  if [[ -n "$1" ]]; then
    coin=$1
    symbols=(`cat $HOME/.coinmarketcap.json | grep -Po '(?<="symbol": ")[^"]*' | awk -F "\n" '{print $1}'`)
    price=(`cat $HOME/.coinmarketcap.json | grep -Po '(?<="price_usd": ")[^"]*' | awk -F "\n" '{print $1}'`)
    if [[ "${coin}" == "ALL" ]]; then
      for ((i=0; i<${#symbols[*]}; i++));
      do
        echo -e ${symbols[i]}"\t : \t"${price[i]}
      done
    elif [[ "${coin}" == "BTG" ]]; then
      btg_symbols=(`cat $HOME/.coinmarketcap-btg.json | grep -Po '(?<="symbol": ")[^"]*'`)
      btg_price=(`cat $HOME/.coinmarketcap-btg.json | grep -Po '(?<="price_usd": ")[^"]*'`)
      echo -e ${btg_price}
    else
      for ((i=0; i<${#symbols[*]}; i++));
      do
          if [[ "${symbols[i]}" == "${coin}" ]]; then
            echo -e ${price[i]}
          fi
      done
    fi
  else
    echo "Usage example for Bitcoin Gold: \"coin BTG\""
    echo "Usage example all crypto currencies: \"coin ALL\""
  fi
}

alias coin=coinmarketcap
