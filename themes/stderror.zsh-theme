# stderror.net Prompt
# 
# mailto daniel(at)stderror.net

precmd () # dirty stuff for a clean prompt
{
	local -A color
	local run 
	local fill
	run=0
	local host=`hostname`
	len=`echo "+--<:)>--{$USER@$host}--[20:15]" | wc -c`
	color['time']=${1:-'white'}
  	color['pwd']=${2:-'blue'}
  	color['com']=${3:-'black'}
	smile='`if [ ${?} = 0 ]; then echo -ne "%F{green}:)%F{blue}"; else echo -ne "%F{red} :(%F{blue}"; fi;`'
	(( sub = ${COLUMNS} - ${len} ))
	while [ ${run} -lt ${sub} ]; do fill="${fill}-"; run=$((${run} + 1)); done;
	if [ "$USER" = "root" ]; then
		color['user']=${4:-'red'}
	else
		color['user']=${4:-'green'}
	fi
	PROMPT="
%F{blue}+--<$smile>--{%F{$color['user']}%n%F{cyan}@%F{red}${host}%F{blue}}-$fill-[%F{yellow}%T%F{blue}]
+{%f%d%F{cyan}>>%f" 
	ps2="» "
	PS3="${PS2}"
	PS4="${PS2}"
	export PROMPT PS2 PS3 PS4
}
