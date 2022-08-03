# OLD SKOOL LS ALIASES
######################
# alias clf="ls -1rt | tail -1 | xargs bat" # view the last file
# alias l="ls -la "
# alias lf="ls -p | grep -v /" # list files only
# alias lgr='l | grep -i '     # ls grep
# alias lhx="ls ~"
# alias list-javas="l ~/.jenv/versions" # where the fuck is my javas?
# alias ll="ls -l "
# alias lla='ls -lat'
# alias llf="clf"
# alias lrt="ls -lrt "
# alias lsd="ls -d .*/ */"
# alias lsdl="ls -ld .*/ */"
# alias lsf="ls -p | grep -v /" # list files only
# alias lt="ls -1rt|head -1"    # list last file

# NEW SKOOL LS ALIASES
######################
# TODO alias lgr="exa $COMMON_EXA_PARAMS | grep -Ei 'Permissions Size|;'
COMMON_EXA_PARAMS=" --long --header --icons --git --all "
alias l="exa $COMMON_EXA_PARAMS --group --group-directories-first --time-style long-iso --git --git-ignore"
alias ls1="exa $COMMON_EXA_PARAMS --oneline  --group-directories-first"
alias ls-tree="exa $COMMON_EXA_PARAMS --tree"
alias lrt="exa $COMMON_EXA_PARAMS --sort newest"
alias lsd="exa $COMMON_EXA_PARAMS --only-dirs"

# PSK 07-09-2022 undoing exa as it's hanging for ages on attached volumes
alias exa-default="exa $COMMON_EXA_PARAMS"
alias l="exa-default "
alias lf="exa-default | grep -v /" # list files only
alias lgr='l | grep -i '     # ls grep
alias lhx="ls ~"
alias list-aliases=n-aliases                 # wot about my aliases?
alias list-functions=n-functions             # wot about my functions?
alias list-javas="l ~/.jenv/versions"        # where the fuck is my javas?
alias list-themes="cat ${HOME}/.zsh_favlist" # oh-my-zsh stuff
alias ll="exa-default -t modified | tail -1" # list last file
alias lla='ls -lat'
alias llf="clf"
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias lsf="ls -p | grep -v /" # list files only
alias lt="ll"                 # list last file
