#!/bin/zsh

source_env() {
  if [[ -f .env ]]; then
	if errs=$(bash -n .env 2>&1); 
		then source .env; 
	else 
		printf '%s\n' "Found some errors while parsing your .env file: " "$errs"; 
	fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env
