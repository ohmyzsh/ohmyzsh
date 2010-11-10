# To use: add a .zendesk file into your directory with the URL to the
# individual project. For example:
# https://help.trabian.com/tickets/8994
open_zendesk_ticket () {
  if [ ! -f ~/.zendesk-url ]; then
    echo "There is no .zendesk file in the home directory..."
    return 0;
  else
    zendesk_url=$(cat ~/.zendesk-url);
    echo "Opening ticket #$1";
    `open $zendesk_url/tickets/$1`;
  fi
}

alias zo='open_zendesk_ticket'
alias ticket='open_zendesk_ticket'
