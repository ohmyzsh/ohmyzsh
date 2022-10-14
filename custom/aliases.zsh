
#API ALIASES
alias dapi='~/Projects/denim-api';
alias activate='source ~/Projects/denim-api/.denim-api/bin/activate';

#FRONT-END ALIASES
alias dfe='~/Projects/denim-app';
alias dcw='celery worker --config=app.data.celeryconfig';
alias dfw='flower --port=5555 --config=app.data.celeryconfig';
alias dar='python run.py';
alias dapidev='rabbitmq-server; dcw && dfw && dar';

#MAC ALIASES
alias virtualenv3='~/Library/Python/3.5/bin/virtualenv';

alias gffs='git flow feature start'
alias gfff='git flow feature finish `git branch | sed -En "s/\* feature\/(.*)/\1/p"`; ggp'
alias ggl="git for-each-ref --sort=-committerdate refs/heads/ --format='%1B[38;5;010m%(authorname)%1B[m: [%1B[0;31m%(refname:short)%1B[m] %1B[38;5;201m%(subject)%1B[m'"

alias ls='ls -G'
