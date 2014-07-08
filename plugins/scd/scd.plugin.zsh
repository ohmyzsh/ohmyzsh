## The scd script should autoload as a shell function.
autoload scd


## If the scd function exists, define a change-directory-hook function
## to record visited directories in the scd index.
if [[ ${+functions[scd]} == 1 ]]; then
    scd_chpwd_hook() { scd --add $PWD }
    autoload add-zsh-hook
    add-zsh-hook chpwd scd_chpwd_hook
fi


## Allow scd usage with unquoted wildcard characters such as "*" or "?".
alias scd='noglob scd'


## Load the directory aliases created by scd if any.
if [[ -s ~/.scdalias.zsh ]]; then source ~/.scdalias.zsh; fi
