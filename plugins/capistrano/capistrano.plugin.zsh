# Added `capit` because `cap` is a reserved word. `cap` completion doesn't work.
# http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcap-Module

function capit() {
  if [ -f Gemfile ]
  then
    bundle exec cap $*
  else
    cap $*
  fi
}
