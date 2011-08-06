# hub alias from defunkt
# https://github.com/defunkt/hub
if [ "$commands[(I)hub]" ]; then
    # eval `hub alias -s zsh`
    function git(){hub "$@"}
fi

# Functions #################################################################

# https://github.com/dbb 

# These are taken directly from the instructions you see after you create a new
# repo. As the names imply, new_gh() assumes you're starting from scratch in a
# directory named after the repo (this name is the only argument it takes), and
# exist_gh() assumes that you've already initialized git in the given directory
# (again, the only argument).
# set up a new repo

new_gh() { # [NAME_OF_REPO]
    repo = $1

    name=$(  igit config user.name )
    email=$( git config user.email )
    user=$(  git config github.user )

    mkdir "$repo"
    cd "$repo"
    git init
    touch README
    git add README
    git commit -m 'Initial commit.'
    git remote add origin git@github.com:${user}/${name}.git
    git push -u origin master
}

exist_gh() { # [DIRECTORY]
    cd "$1"
    name=$( git config user.name )
    email=$( git config user.email )
    user=$( git config github.user )

    git remote add origin git@github.com:${user}/${name}.git
    git push -u origin master
}

# End Functions #############################################################

