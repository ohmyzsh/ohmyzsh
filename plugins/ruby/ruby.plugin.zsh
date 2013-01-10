# TODO: Make this compatible with rvm.
#       Run sudo gem on the system ruby, not the active ruby.
alias sgem='sudo gem'

# Find ruby file
alias rfind='find . -name "*.rb" | xargs grep -n'

# Add first line "#encoding: UTF-8" into a file (for Ruby 1.9)
encoding_file = function() {
	sed '1i#encoding: UTF-8' $1 > /tmp/new_file.tmp
	mv /tmp/new_file.tmp $1
}
