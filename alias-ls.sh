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
# TODO alias lgr="eza $COMMON_EZA_PARAMS | grep -Ei 'Permissions Size|;'
COMMON_EZA_PARAMS=" --long --header --icons --git --all --time-style long-iso --no-quotes"
alias l="eza $COMMON_EZA_PARAMS --group --group-directories-first --time-style long-iso --git "
alias ls1="eza $COMMON_EZA_PARAMS --oneline  --group-directories-first"
alias ls-tree="eza $COMMON_EZA_PARAMS --tree"
alias tree-ls="eza $COMMON_EZA_PARAMS --tree"
alias lrt="eza $COMMON_EZA_PARAMS --sort newest"
alias lsd="eza $COMMON_EZA_PARAMS --only-dirs"

# PSK 07-09-2022 undoing eza as it's hanging for ages on attached volumes
alias eza-default="eza $COMMON_EZA_PARAMS"
# alias l="eza-default "
alias ls="eza"
alias lf="eza-default | grep -v /" # list files only
alias lgr='l | grep -i '           # ls grep
alias lhx="ls ~"
alias list-aliases=n-aliases                 # wot about my aliases?
alias list-functions=n-functions             # wot about my functions?
alias list-javas="l ~/.jenv/versions"        # where the fuck is my javas?
alias list-themes="cat ${HOME}/.zsh_favlist" # oh-my-zsh stuff
alias ll="eza-default -t modified | tail -1" # list last file
alias lla='ls -lat'
alias llf="clf"
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
alias lsf="ls -p | grep -v /" # list files only
alias lt="ll"                 # list last file
