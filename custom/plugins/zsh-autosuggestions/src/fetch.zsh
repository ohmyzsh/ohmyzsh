
#--------------------------------------------------------------------#
# Fetch Suggestion                                                   #
#--------------------------------------------------------------------#
# Loops through all specified strategies and returns a suggestion
# from the first strategy to provide one.
#

_zsh_autosuggest_fetch_suggestion() {
	typeset -g suggestion
	local -a strategies
	local strategy

	# Ensure we are working with an array
	strategies=(${=ZSH_AUTOSUGGEST_STRATEGY})

	for strategy in $strategies; do
		# Try to get a suggestion from this strategy
		_zsh_autosuggest_strategy_$strategy "$1"

		# Break once we've found a suggestion
		[[ -n "$suggestion" ]] && break
	done
}
