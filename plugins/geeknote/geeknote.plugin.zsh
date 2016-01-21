# ------------------------------------------------------------------------------
#          FILE:  geeknote.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Georg Ogris (georg.ogris@gmail.com)
#       VERSION:  0.0.1
# ------------------------------------------------------------------------------


# add to a new bookmark to Bookmarks
function gnb() {
	local link=$1
	shift 1

	geeknote create --title '"'"$link"'"' \
	       	--content '"'"$link"'"' \
		--notebook '"Bookmarks"' \
		--tags '"readings"'
		#--tags '"'"$@"'"'
}
