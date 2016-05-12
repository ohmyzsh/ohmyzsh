### Get the external ip of your network
alias external_ip='curl ipecho.net/plain; echo'

### Ruby Stuff
alias rake="noglob rake" # necessary to make rake work inside of zsh

### ls stuff
alias ls='ls -G'
alias ll='ls -lah'
alias ltr='ll -ltr'

### MAC only
alias ql='qlmanage -p 2>/dev/null' # OS X Quick Look
alias oo='open .' # open current directory in OS X Finder
alias 'today=calendar -A 0 -f /usr/share/calendar/calendar.mark | sort'
alias 'mailsize=du -hs ~/Library/mail' # Size of mail app
alias 'smart=diskutil info disk0 | grep SMART' # display SMART status of hard drive
alias apps='mdfind "kMDItemAppStoreHasReceipt=1"' # alias to show all Mac App store apps
alias refreshbrew='brew outdated | while read cask; do brew upgrade $cask; done' # refresh brew by upgrading all outdated casks
alias rebuildopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.fram ework/Support/lsregister -kill -r -domain local -domain system -domain user' # rebuild Launch Services to remove duplicate entries on Open With menu

### Other stuff
alias sz='source ~/.zshrc'
alias grep='grep --color=auto' ### Colorize grep output
alias d_size="find . -type d -d 1 -print0 | xargs -0 du -sm | sort -nr" ### Get size of directories inside current dir
alias 'fcount=find . -type f | wc -l' # number of files
alias speedtest='wget -O /dev/null https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb'

###GIT aliases
alias st='git st'
alias lg='git lg'
alias pop='git pop'
alias gcm='git ci -m'
alias gdiff='git diff'
alias gap='git add -p'
alias gpull='git pull'
alias gpush='git push'
alias stash='git stash'
alias gfetch='git fetch'
alias pull='git pull --rebase'
alias ghard='git reset --hard'
alias gsoft='git reset --soft'
alias gcount="git shortlog | grep -E '^[ ]+\w+' | wc -l" # shows the number of commits for the current repos for all developers
alias stpull='git stash && git pull --rebase && git stash pop'
alias gsync='git fetch upstream; git checkout master; echo "+++++ Merging +++++"; git merge upstream/master'

### Personal
alias work='cd ~/Documents/work/'
alias down='cd ~/Downloads'
alias audio-dl='youtube-dl -x --audio-format best'


### iPhone simulator
alias iphone="open /Applications/Xcode.app/Contents/Applications/iOS\ Simulator.app"

source /etc/profile.d/rvm.sh
