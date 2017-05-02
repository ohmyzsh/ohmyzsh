white_b="%{$bg[white]%}"
blue_f="%{$fg_bold[blue]%}"
cyan_f="%{$fg_bold[cyan]%}"
black_f="%{$fg_bold[black]%}"
red_f="%{$fg_bold[red]%}"
reset="%{$reset_color%}"
number="%!"

PROMPT="
${white_b}%(?.${blue_f}.${red_f})[%* %n@%m] %c%E${reset}
${cyan_f}%#${reset} "
RPROMPT="< ${cyan_f}${number}${reset} >"