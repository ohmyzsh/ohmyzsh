###############################################################################
# PSK's aliases. All of 'em. Well, nearly all.
###############################################################################

source $HOME/.oh-my-zsh/alias-ls.sh
# source $HOME/.oh-my-zsh/alias-sonos.sh

alias activate-venv=". ./venv/bin/activate"
alias ag="anyguard" # command that shows a light whilst command is running then green/red
alias aliases-n=n-aliases
alias aliases=n-aliases
alias all-aliases=n-aliases
alias any="anyguard" # command that shows a light whilst command is running then green/red
alias battery-info="pmset -g batt"
alias bmake="today-time && make "
alias brew-x86="/usr/local/homebrew/bin/brew"
alias cerebro="/usr/local/cerebro-0.9.4/bin/cerebro"
alias cf="copyfile"
alias clf="eza-default -t modified | tail -1 | xargs less" # cat the last file
alias cpwd="copypath"
alias crontab="EDITOR=vi \crontab" # This is because code editing crontab doesn't work
alias denv="ddp"
alias dock-toggle="osascript -e 'tell application \"System Events\" to set autohide of dock preferences to not (autohide of dock preferences)'"
alias egr='env | sort | grep -i '
alias errorsx="^FATA|^ERR|^WAR|^FAIL"
alias errx="^FATA|^ERR|^WAR|^FAIL"
alias es="env|sort | bat"
alias fdd-exact='\fd --type d --exclude "__pycache__" --glob --max-depth 7'                         # don't use regex as is the default
alias fdd='\fd --type d --ignore-case --exclude "__pycache__" --max-depth 7'                        # find directories
alias fdda-exact='\fd --type d -H -uu --exclude "__pycache__" --no-ignore-vcs --glob --max-depth 7' # don't use regex as is the default
alias fdda="fd --type d -H -uu --ignore-case --no-ignore-vcs -I -L --max-depth 7"                   # find directories in horrible places
alias fdir='\fd --type d -uu --ignore-case --exclude "__pycache__" --max-depth 7'                   # find directories
alias ff-exact='\fd --type f --exclude "__pycache__" --glob --max-depth 7'                          # don't use regex as is the default
alias ff='\fd --type f --ignore-case --exclude "__pycache__" --max-depth 7'                         # find files
alias ffa-exact='\fd --type f -H -uu --exclude "__pycache__" --no-ignore-vcs --glob --max-depth 7'  # don't use regex as is the default
alias ffa="\fd --type f -H -uu --ignore-case --no-ignore-vcs -I --max-depth 7"                      # find files in horrible places
alias fin="echo -n "blue" | nc -4u -w0 localhost 1738"
alias flush-dns="flush"
alias flush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias ftp-DS="sftp -P 699 pskadmin@ds718-psk.synology.me"
alias functions-n=n-functions
alias fzf="\fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias g="google-search"
alias yt="youtube-search"
alias az="amazon-search"
alias gfind-filename=gfindf
alias gfind-matches-only="gfind-only-matching-files"
alias gfinda-matches-only="gfind-all-only-matching-files"
alias gfinda="gfind-all"
alias ghub-code='ghub browse -- tree/main'
alias ghub-pr='ghub browse -- pulls'
alias ghub='\hub '
alias gi="git-info"
alias git-info='echo "BRANCH ———————" && git branch -vv && echo "\nREMOTE———————" && git remote -vv'
alias git-reset='git checkout HEAD -- '
alias go-omz="cd ~\/.oh-my-zsh"
alias gomz="cd ~\/.oh-my-zsh"
alias goomz="cd ~\/.oh-my-zsh"
alias grep-nf="grep --color=always --ignore-case --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}"
alias help="tldr"
alias hgr="history -500 | grep -i "
alias hub-code='hub browse -- tree/main'
alias hub-pr='hub browse -- pulls'
alias info-battery="battery-info"
alias ip-address="what-is-my-ip"
alias ip="what-is-my-ip"
alias list-aliases=n-aliases # wot about my aliases?
alias list-all-widgets="zle -al"
alias list-functions=n-functions # wot about my functions?
alias list-shell-widgets="list-all-widgets"
alias list-themes="cat ${HOME}/.zsh_favlist" # oh-my-zsh stuff
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -susp  end"
alias lz='lazygit'
alias maketi="today-time&&  make test-integration 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias maketil="make-big-break&&  make test-integration-local 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias mdf=mdfind-current-dir
alias mdfh=mdfind-home-dir
alias mdfgh=mdfind-grep-home-dir # mdfind grep starting in $HOME
alias mdfhg=mdfgh
alias mdfg=mdfind-grep-current-dir # mdfind grep starting in .
alias mmake="today-time && make "
alias mount-DS718="nohup /Users/peter/bin/mount-DS718.sh 2>/dev/null &"
alias mti="today-time&&  make test-integration 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias mtil="make-big-break&&  make test-integration-local 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias my-ip="what-is-my-ip"
alias o="open ."
alias ohmyzsh="vscode ~/.oh-my-zsh"
alias old-brew="/usr/local/homebrew/bin/brew"
alias q='echo you are not in pdb, ya twit' # This is cos I keep on hitting q to exit pdb when I've already exited and just want to repeat the container run
alias s="/Users/peter/.Sidekick/s-macos"   # Sidekick is a ChatGPT ... clone? It sits in VS Code usually
alias set-timer="termdown"
alias sftp-DS="sftp -P 699 pskadmin@ds718-psk.synology.me"
alias slate="code ~/.slate.js"
alias so="how2"
alias start-stopwatch="termdown"
alias start-timer="termdown"
alias stopwatch="termdown"
alias sudo="nocorrect sudo"
alias t="tmux"
alias timer="termdown"
alias tldr-cool="cht.sh"
alias vscode="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias wtf="tldr"
alias wts="tldr"
alias yoink="open -a Yoink"
alias z="vscode ~/.zshrc"
# alias ls="eza --header  --git -1 --long"
# WARNING: these might balls things up
# alias cat="bat"
# alias man="batman"
# alias less="bat"

# GIT ################################################################
# My git faves have been moved to ~/.gitconfig
