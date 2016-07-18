# user colors                         
if [ $UID -eq 0 ]; then USERCOLOR="red"; else USERCOLOR="green"; fi

# box name
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# workdir
local current_dir='${PWD/#$HOME/~}'

# return status
local ret_status="%(?:%{$fg_bold[255]%}➤ :%{$fg_bold[red]%}➤ %s)"

# prompt format: \n USER MACHINE DIRECTORY \n STATUS
PROMPT="%{$fg[$USERCOLOR]%}%n\
%{$reset_color%}\
%{$fg[255]%} \
$(box_name)\
%{$reset_color%} \
%{$reset_color%}\
${current_dir}\
%{$reset_color%}
${ret_status}\
%{$reset_color%}"
