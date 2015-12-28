# Aliases
alias pkgls="pkgin ls"            # show installed packages
alias pkgav="pkgin av"            # show available packages
alias pkgse="pkgin se $1"         # search packages
alias pkgins="sudo pkgin in $1"   # install package
alias pkgrm="sudo pkgin rm  $1"   # remove packages and depending packages
alias pkgup="sudo pkgin -y up"    # create and populate the initial database
alias pkgug="sudo pkgin -y ug"    # upgrade main packages
alias pkgfug="sudo pkgin -y fug"  # upgrade all packages
alias pkgar="sudo pkgin -y ar"    # autoremove orphan dependencies
alias pkgcl="sudo pkgin cl"       # clean packages cache
