#compdef fab

_fab_list() {
    reply=(`fab --shortlist`)
}
compctl -K _fab_list fab

# DECLARION: This plugin was created by kennethreitz. What I did is just making a portal from https://github.com/kennethreitz-archive/fabric-zsh-completion.
