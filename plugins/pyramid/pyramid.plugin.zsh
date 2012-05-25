alias pdr="pserve development.ini --reload""
alias ppr="pserve production.ini --reload""

# Scaffolding Aliases
#Available scaffolds:
# alchemy:          Pyramid SQLAlchemy project using url dispatch
alias pca="pcreate -s alchemy $*"
# pyramid_mongodb:  pyramid MongoDB project
alias pcm="pcreate -s pyramid_mongodb $*"
# starter:          Pyramid starter project
alias pcs="pcreate -s starter $*"
# zodb:             Pyramid ZODB project using traversal
alias pcz="pcreate -s zodb $*"
