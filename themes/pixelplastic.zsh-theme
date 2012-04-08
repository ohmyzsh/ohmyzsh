# see http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html for color codes
PROMPT_PREFIX="$(xterm_color 243 '%n')$(xterm_color 240 '@')$(xterm_color 238 '%m')"

PROMPT='$PROMPT_PREFIX $(xterm_color 76 "${PWD/#$HOME/~}") $SCM_PROMPT_INFO 
$(xterm_color 33 $(scm_prompt_char))> '

RPROMPT='$RPROMPT_SUFFIX'

ZSH_THEME_GIT_PROMPT_PREFIX="on $(xterm_color_open 220)"
ZSH_THEME_GIT_PROMPT_SUFFIX="$(xterm_color_reset)"
ZSH_THEME_GIT_PROMPT_DIRTY=" $(xterm_color 196 '(!)')"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" $(xterm_color 33 '(+)')"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Map the default colors to more pasteleqsue colors
# see https://code.google.com/p/mintty/wiki/Tips#Changing_colours
# see http://stackoverflow.com/questions/1057564/pretty-git-branch-graphs#comment12477465_9074343
echo -ne '\e]4;0;#202020\a'   # black
echo -ne '\e]4;1;#5d1a14\a'   # red
echo -ne '\e]4;2;#424e24\a'   # green
echo -ne '\e]4;3;#6f5028\a'   # yellow
echo -ne '\e]4;4;#263e4e\a'   # blue
echo -ne '\e]4;5;#3e1f50\a'   # magenta
echo -ne '\e]4;6;#234e3f\a'   # cyan
echo -ne '\e]4;7;#979797\a'   # white (light grey really)
echo -ne '\e]4;8;#555555\a'   # bold black (i.e. dark grey)
echo -ne '\e]4;9;#e32424\a'   # bold red
echo -ne '\e]4;10;#65c734\a'  # bold green
echo -ne '\e]4;11;#dae83a\a'  # bold yellow
echo -ne '\e]4;12;#4790c4\a'  # bold blue
echo -ne '\e]4;13;#a256c7\a'  # bold magenta
echo -ne '\e]4;14;#40c7b0\a'  # bold cyan
echo -ne '\e]4;15;#fefefe\a'  # bold white

