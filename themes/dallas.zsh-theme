# Personalized!
# [red][normal][purple][yellow][normal]
# dallas@lappy ~/Sites %
# PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
# PROMPT="{white}\{{yellow}{time}{white}\}{green}{host}{white}:{cyan}{pwd} {red,bold}{user}{white}%{normal} "

DALLAS_CURRENT_TIME_="%{$fg[white]%}{%{$fg[yellow]%}%T%{$fg[white]%}}%{$reset_color%}"
DALLAS_CURRENT_RUBY_="%{$fg[white]%}[%{$fg[magenta]%}\$(~/.rvm/bin/rvm-prompt i v)%{$fg[white]%}]%{$reset_color%}"
DALLAS_CURRENT_MACH_="%{$fg[green]%}%m%{$fg[white]%}:%{$reset_color%}"
DALLAS_CURRENT_LOCA_="%{$fg[cyan]%}%~%{$reset_color%}"
DALLAS_CURRENT_USER_="%{$fg[red]%}%n%{$reset_color%}"
DALLAS_PROMPT_CHAR_="%{$fg[white]%}%%%{$reset_color%}"

PROMPT="$DALLAS_CURRENT_TIME_$DALLAS_CURRENT_RUBY_$DALLAS_CURRENT_MACH_$DALLAS_CURRENT_LOCA_ $DALLAS_CURRENT_USER_$DALLAS_PROMPT_CHAR_ "
