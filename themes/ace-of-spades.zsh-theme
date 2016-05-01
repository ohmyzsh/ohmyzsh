#
#   The Ace of Spades
#
#     ♤  ♠︎  ♤  ♠︎
#

function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

function ace_prompt () {
	# colors
	local red="\033[0;31m";
  local blue="\033[0;34m";
	local stop="\033[0m";

  local spade="♤ ";
  local fill_spade="♠︎ ";

  ref=$(git symbolic-ref HEAD 2> /dev/null);
  branch=${ref#refs/heads/};

  if [[ ! -z $branch ]]; then
    if [[ $branch == "master" ]]; then
      if [[ ! -z "$(git status --porcelain)" ]]; then
        local prompt="${red}$fill_spade${stop}";
      else
        local prompt="${red}$spade${stop}";
      fi
    else
      if [[ ! -z "$(git status --porcelain)" ]]; then
        local prompt="${blue}$fill_spade${stop}";
      else
        local prompt="${blue}$spade${stop}";
      fi
    fi
  else
    local prompt="$spade";
  fi

  echo "$prompt";

  unset spade;
	unset prompt;
	unset red;
	unset blue;
	unset stop;
}

function directory () {
  echo $(basename `pwd`);
}

PROMPT=' $(ace_prompt) $(collapse_pwd)
  > '

