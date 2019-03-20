# ZSH THEME Preview: https://skitch.com/huyy/rk979/humza.zshtheme

let TotalBytes=0
for Bytes in $(ls -l | grep "^-" | awk '{ print $5 }')
do
   let TotalBytes=$TotalBytes+$Bytes
done
		# should it say b, kb, Mb, or Gb
if [ $TotalBytes -lt 1024 ]; then
   TotalSize=$(echo -e "scale=3 \n$TotalBytes \nquit" | bc)
   suffix="b"
elif [ $TotalBytes -lt 1048576 ]; then
   TotalSize=$(echo -e "scale=3 \n$TotalBytes/1024 \nquit" | bc)
   suffix="kb"
elif [ $TotalBytes -lt 1073741824 ]; then
   TotalSize=$(echo -e "scale=3 \n$TotalBytes/1048576 \nquit" | bc)
   suffix="Mb"
else
   TotalSize=$(echo -e "scale=3 \n$TotalBytes/1073741824 \nquit" | bc)
   suffix="Gb"
fi

PROMPT='%{$reset_color%}%n %{$fg[green]%}{%{$reset_color%}%~%{$fg[green]%}}%{$reset_color%}$(git_prompt_info) greetings, earthling %{$fg[green]%}[%{$reset_color%}%{$TotalSize%}%{$suffix%}%{$fg[green]%}]%{$fg[red]%}$%{$reset_color%} ☞ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}±("
ZSH_THEME_GIT_PROMPT_SUFFIX=");%{$reset_color%}"
