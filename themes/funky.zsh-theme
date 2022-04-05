# Taken from Tassilo's Blog
<<<<<<< HEAD
# http://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/
=======
# https://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

local blue_op="%{$fg[blue]%}[%{$reset_color%}"
local blue_cp="%{$fg[blue]%}]%{$reset_color%}"
local path_p="${blue_op}%~${blue_cp}"
local user_host="${blue_op}%n@%m${blue_cp}"
local ret_status="${blue_op}%?${blue_cp}"
local hist_no="${blue_op}%h${blue_cp}"
local smiley="%(?,%{$fg[green]%}:%)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%})"
PROMPT="╭─${path_p}─${user_host}─${ret_status}─${hist_no}
╰─${blue_op}${smiley}${blue_cp} %# "
local cur_cmd="${blue_op}%_${blue_cp}"
<<<<<<< HEAD
PROMPT2="${cur_cmd}> "
=======
PROMPT2="${cur_cmd}> "
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
