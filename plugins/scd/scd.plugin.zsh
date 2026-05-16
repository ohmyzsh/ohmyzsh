## The scd script should autoload as a shell function.
autoload -Uz scd


## If the scd function exists, define a change-directory-hook function
## to record visited directories in the scd index.
if [[ ${+functions[scd]} == 1 ]]; then
    chpwd_scd() { scd --add $PWD }
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd chpwd_scd
fi


## Load the directory aliases created by scd if any.
if [[ -s ~/.scdalias.zsh ]]; then
    source ~/.scdalias.zsh
fi
