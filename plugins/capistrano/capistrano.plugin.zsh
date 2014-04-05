# Added `shipit` because `cap` is a reserved word. `cap` completion doesn't work.
# http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fcap-Module

func shipit() {
  if [ -f Gemfile ]
  then
    bundle exec cap $*
  else
    cap $*
  fi
}
