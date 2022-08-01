alias activate-venv=". ./venv/bin/activate"
alias aliases-n=n-aliases
alias aliases=n-aliases
alias all-aliases=n-aliases
alias bmake="today-time && make "
alias brew-x86="/usr/local/homebrew/bin/brew"
alias cerebro="/usr/local/cerebro-0.9.4/bin/cerebro"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias crontab="EDITOR=vi \crontab" # This is because code editing crontab doesn't work
alias egr='env | sort | grep -i '
alias envgr='env | sort | grep -i '
alias errorsx="^FATA|^ERR|^WAR|^FAIL"
alias errx="^FATA|^ERR|^WAR|^FAIL"
# PSK 07-09-2022 undoing exa as it's hanging for ages on attached volumes
alias fdd='\fd -t d -uu -i -L '                      # find directories
alias fda="fd -t d -H -uu -i --no-ignore-vcs -I -L " # find directories in horrible places
alias fdir='\fd -t d -uu -i -L '                     # find directories
alias ff='fd -t f -uu -i -L '                        # find files
alias ffa="fd -t f -H -uu -i --no-ignore-vcs -I -L " # find files in horrible places
alias ftp-DS="sftp -P 699 pskadmin@ds718-psk.synology.me"
alias functions-n=n-functions
alias g="google"
alias gfind-filename=gfindf
alias gfinda="gfind-all"
alias ggm="cd ~\/src\/rune\/go-mono"
alias ghub-code='ghub browse -- tree/main'
alias ghub-pr='ghub browse -- pulls'
alias ghub='\hub '
alias gi="git-info"
alias git-info='echo "BRANCH ———————" && git branch -vv && echo "\nREMOTE———————" && git remote -vv'
alias go-go-mono="cd ~\/src\/rune\/go-mono"
alias go-omz="cd ~\/.oh-my-zsh"
alias go-tortilla="cd ~\/src\/rune\/go-mono\/tortilla"
alias gomz="cd ~\/.oh-my-zsh"
alias goomz="cd ~\/.oh-my-zsh"
alias gpm="cd ~\/src\/rune\/python-mono"
alias grad="cd ~\/src\/rune\/python-mono\/radish"
alias gtor="cd ~\/src\/rune\/go-mono\/tortilla"
alias gtx="cd ~\/src\/rune\/go-mono\/tortilla"
alias hgr="history -500 | grep -i "
alias hub-code='hub browse -- tree/main'
alias hub-pr='hub browse -- pulls'
alias list-aliases=n-aliases                 # wot about my aliases?
alias list-functions=n-functions             # wot about my functions?
alias list-themes="cat ${HOME}/.zsh_favlist" # oh-my-zsh stuff
alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
source ./alias-ls.sh
alias lz='lazygit'
alias maketi="today-time&&  make test-integration 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias maketil="make-big-break&&  make test-integration-local 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias mmake="today-time && make "
alias mti="today-time&&  make test-integration 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias mtil="make-big-break&&  make test-integration-local 2>&1 | tee .\/make-local.log ; docker-stop-all-containers >\/dev\/null &"
alias o="open ."
alias ohmyzsh="vscode ~/.oh-my-zsh"
alias old-brew="/usr/local/homebrew/bin/brew"
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
alias vscode="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias yoink="open -a Yoink"
alias z="vscode ~/.zshrc"
# WARNING: these might balls things up
# alias cat="bat"
# alias man="batman"
# alias less="bat"

# GIT ################################################################
# My git faves have been moved to ~/.gitconfig
