# Based on evan's prompt
# Shows the exit status of the last command if non-zero
# Uses "#" instead of "»" when running with elevated privileges
PROMPT="%m %{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . ${fg[red]}%? )%{${fg[blue]}%}»%{${reset_color}%} "
