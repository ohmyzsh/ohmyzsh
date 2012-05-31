export VIRTUAL_ENV_DISABLE_PROMPT=1

source virtualenvwrapper.sh

export RPROMPT="%{$fg_bold[white]%}(venv:\${VIRTUAL_ENV:t})%{$reset_color%}"