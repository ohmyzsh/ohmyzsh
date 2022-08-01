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
COMMON_EXA_PARAMS=" --long --all --header --icons "
alias l="exa $COMMON_EXA_PARAMS --group --group-directories-first --time-style long-iso --git --git-ignore"
alias ls1="exa --oneline  $COMMON_EXA_PARAMS  --group-directories-first"
alias ls-tree="exa  $COMMON_EXA_PARAMS --tree"
alias lrt="exa $COMMON_EXA_PARAMS --sort newest"
alias lsd="exa $COMMON_EXA_PARAMS --only-dirs"
# TODO alias lgr="exa $COMMON_EXA_PARAMS | grep -Ei 'Permissions Size|;'
