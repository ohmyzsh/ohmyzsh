# set user installation paths
if (-d ~/.autojump/bin) then
    set path = (~/.autojump/bin path)
endif

# prepend autojump to cwdcmd (run after every change of working directory)
if (`alias cwdcmd` !~ *autojump*) then
    alias cwdcmd 'autojump --add $cwd >/dev/null;' `alias cwdcmd`
endif

#default autojump command
alias j 'cd `autojump -- \!:1`'
