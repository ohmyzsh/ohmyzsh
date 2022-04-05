<<<<<<< HEAD
# Setup hub function for git, if it is available; http://github.com/defunkt/hub
if [ "$commands[(I)hub]" ] && [ "$commands[(I)ruby]" ]; then
    # Autoload _git completion functions
    if declare -f _git > /dev/null; then
      _git
    fi
    
    if declare -f _git_commands > /dev/null; then
        _hub_commands=(
            'alias:show shell instructions for wrapping git'
            'pull-request:open a pull request on GitHub'
            'fork:fork origin repo on GitHub'
            'create:create new repo on GitHub for the current project'
            'browse:browse the project on GitHub'
            'compare:open GitHub compare view'
        )
        # Extend the '_git_commands' function with hub commands
        eval "$(declare -f _git_commands | sed -e 's/base_commands=(/base_commands=(${_hub_commands} /')"
    fi
    # eval `hub alias -s zsh`
    function git(){
        if ! (( $+_has_working_hub  )); then
            hub --version &> /dev/null
            _has_working_hub=$(($? == 0))
        fi
        if (( $_has_working_hub )) ; then
            hub "$@"
        else
            command git "$@"
        fi
    }
=======
# Set up hub wrapper for git, if it is available; https://github.com/github/hub
if (( $+commands[hub] )); then
  alias git=hub
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
fi

# Functions #################################################################

<<<<<<< HEAD
# https://github.com/dbb 


# empty_gh [NAME_OF_REPO]
#
# Use this when creating a new repo from scratch.
empty_gh() { # [NAME_OF_REPO]
    repo=$1
    ghuser=$(  git config github.user )

    mkdir "$repo"
    cd "$repo"
    git init
    touch README
    git add README
    git commit -m 'Initial commit.'
    git remote add origin git@github.com:${ghuser}/${repo}.git
    git push -u origin master
=======
# Based on https://github.com/dbb/githome/blob/master/.config/zsh/functions

# empty_gh <NAME_OF_REPO>
#
# Use this when creating a new repo from scratch.
# Creates a new repo with a blank README.md in it and pushes it up to GitHub.
empty_gh() { # [NAME_OF_REPO]
  emulate -L zsh
  local repo=$1

  mkdir "$repo"
  touch "$repo/README.md"
  new_gh "$repo"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

# new_gh [DIRECTORY]
#
# Use this when you have a directory that is not yet set up for git.
# This function will add all non-hidden files to git.
new_gh() { # [DIRECTORY]
<<<<<<< HEAD
    cd "$1"
    ghuser=$( git config github.user )

    git init
    # add all non-dot files
    print '.*'"\n"'*~' >> .gitignore
    git add ^.*
    git commit -m 'Initial commit.'
    git remote add origin git@github.com:${ghuser}/${repo}.git
    git push -u origin master
=======
  emulate -L zsh
  local repo="$1"
  cd "$repo" \
    || return

  git init \
    || return
  # add all non-dot files
  print '.*'"\n"'*~' >> .gitignore
  git add [^.]* \
    || return
  git add -f .gitignore \
    || return
  git commit -m 'Initial commit.' \
    || return
  hub create \
    || return
  git push -u origin master \
    || return
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

# exist_gh [DIRECTORY]
#
# Use this when you have a git repo that's ready to go and you want to add it
# to your GitHub.
exist_gh() { # [DIRECTORY]
<<<<<<< HEAD
    cd "$1"
    name=$( git config user.name )
    ghuser=$( git config github.user )
    repo=$1

    git remote add origin git@github.com:${ghuser}/${repo}.git
    git push -u origin master
=======
  emulate -L zsh
  local repo=$1
  cd "$repo"

  hub create \
    || return
  git push -u origin master
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

# git.io "GitHub URL"
#
# Shorten GitHub url, example:
<<<<<<< HEAD
#   https://github.com/nvogel/dotzsh    >   http://git.io/8nU25w  
# source: https://github.com/nvogel/dotzsh
# documentation: https://github.com/blog/985-git-io-github-url-shortener
#
git.io() {curl -i -s http://git.io -F "url=$1" | grep "Location" | cut -f 2 -d " "}
=======
#   https://github.com/nvogel/dotzsh    >   https://git.io/8nU25w
# source: https://github.com/nvogel/dotzsh
# documentation: https://github.com/blog/985-git-io-github-url-shortener
#
git.io() {
  emulate -L zsh
  curl -i -s https://git.io -F "url=$1" | grep "Location" | cut -f 2 -d " "
}
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

# End Functions #############################################################

