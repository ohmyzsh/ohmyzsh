# Evan Hahn's zsh theme
# evanhahn.com
# licensed under the Unlicense

if [ "$(whoami)" = "root" ]; then
	PROMPT='
%{$BG[161]%}%{$fg[white]%} %~ %E%{$reset_color%}
%{$FG[161]%}▶%{$reset_color%} '
else
	PROMPT='
%{$BG[233]%}%{$fg[red]%} %~ %E%{$reset_color%}
%{$FG[240]%}▶%{$reset_color%} '
fi

RPROMPT='%{$FG[240]%}%t%{$reset_color%}'