# ------------------------------------------------------------------------------
#          FILE:  zshmarks.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Jocelyn Mallon (jocelyn.e.mallon@gmail.com)
#       VERSION:  1.0
# ------------------------------------------------------------------------------

bookmarks_file="$HOME/.bookmarks"

# Create bookmarks_file it if it doesn't exist
if [[ ! -f $bookmarks_file ]]; then
	touch $bookmarks_file
fi

function bookmark() {
	bookmark_name=$1
	if [[ -z $bookmark_name ]]; then
		echo 'Invalid name, please provide a name for your bookmark. For example:'
		echo '  bookmark foo'
		return 1
	else
		bookmark="$(pwd)|$bookmark_name" # Store the bookmark as folder|name
		if [[ -z $(grep "$bookmark" $bookmarks_file) ]]; then
			echo $bookmark >> $bookmarks_file
			echo "Bookmark '$bookmark_name' saved"
		else
			echo "Bookmark already existed"
			return 1
		fi
	fi
}

function go() {
	bookmark_name=$1
	bookmark="$(grep "|$bookmark_name$" "$bookmarks_file")"
	if [[ -z $bookmark ]]; then
		echo "Invalid name, please provide a valid bookmark name. For example:"
		echo "  go foo"
		echo
		echo "To bookmark a folder, go to the folder then do this (naming the bookmark 'foo'):"
		echo "  bookmark foo"
		return 1
	else
		dir="${bookmark%%|*}"
		cd "${dir}"
		unset dir
	fi
}

# Show a list of the bookmarks
function showmarks() {
	cat ~/.bookmarks | awk '{ printf "%-40s%-40s%s\n",$1,$2,$3}' FS=\|
}