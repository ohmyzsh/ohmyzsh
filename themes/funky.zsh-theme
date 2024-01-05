# Taken from Tassilo's Blog
# https://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/

local blue_op="%F{blue}[%f"
local blue_cp="%F{blue}]%f"
local path_p="${blue_op}%~${blue_cp}"
local user_host="${blue_op}%n@%m${blue_cp}"
local ret_status="${blue_op}%?${blue_cp}"
local hist_no="${blue_op}%h${blue_cp}"
local smiley="%(?,%F{green}:%)%f,%F{red}:(%f)"
PROMPT="╭─${path_p}─${user_host}─${ret_status}─${hist_no}
╰─${blue_op}${smiley}${blue_cp} %# "
local cur_cmd="${blue_op}%_${blue_cp}"
PROMPT2="${cur_cmd}> "
