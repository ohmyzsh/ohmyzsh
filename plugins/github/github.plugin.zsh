# Setup hub function for git, if it is available; http://github.com/defunkt/hub
if [ "$commands[(I)hub]" ] && [ "$commands[(I)ruby]" ]; then
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
fi

# Functions #################################################################

# https://github.com/dbb 


# empty_gh [NAME_OF_REPO]
#
# Use this when creating a new repo from scratch.
empty_gh() { # [NAME_OF_REPO]
    repo = $1
    ghuser=$(  git config github.user )

    mkdir "$repo"
    cd "$repo"
    git init
    touch README
    git add README
    git commit -m 'Initial commit.'
    git remote add origin git@github.com:${ghuser}/${repo}.git
    git push -u origin master
}

# new_gh [DIRECTORY]
#
# Use this when you have a directory that is not yet set up for git.
# This function will add all non-hidden files to git.
new_gh() { # [DIRECTORY]
    cd "$1"
    ghuser=$( git config github.user )

    git init
    # add all non-dot files
    print '.*'"\n"'*~' >> .gitignore
    git add ^.*
    git commit -m 'Initial commit.'
    git remote add origin git@github.com:${ghuser}/${repo}.git
    git push -u origin master
}

# exist_gh [DIRECTORY]
#
# Use this when you have a git repo that's ready to go and you want to add it
# to your GitHub.
exist_gh() { # [DIRECTORY]
    cd "$1"
    name=$( git config user.name )
    ghuser=$( git config github.user )
    repo=$1

    git remote add origin git@github.com:${ghuser}/${repo}.git
    git push -u origin master
}

#
# Provides a review workflow for pull requests. Best used with `prmerge` when ready to merge.
#
# Example - checks out the Pull Request 1 and rebases branch against master:
#     `prfetch master 1`
#     ... Check it out, test, etc.
#     `prmerge master 1`
#     Merges the Pull request, creates a reference to it, then pushes to the remote.
#
# @link http://derickrethans.nl/managing-prs-for-php-mongo.html
#
function prfetch()
{
    git checkout $1
    git fetch origin pull/$2/head:pr/$2
    git checkout pr/$2
    git rebase $1
}

#
# Merge a Pull Request that has been reviewed using `prfetch` and push.
# Example - Merge PR #1 into master and reference the PR in the merge:
#     `prmerge master 1`
#
function prmerge()
{
    git checkout $1
    git merge --no-ff -m "Merged pull request #$2" pr/$2
    git branch -D pr/$2
    git push
}

# End Functions #############################################################

