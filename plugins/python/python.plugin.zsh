alias spip='sudo pip'

# Find python file
alias pyfind='find . -name *.py | xargs grep -n'

# Remove python compiled byte-code (By diofeher)
alias pycrm='rm `find . | grep -E "*.(pyc|pyo)$"`'
