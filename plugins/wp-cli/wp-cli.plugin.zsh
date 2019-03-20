# WP-CLI
# A command line interface for WordPress
# https://wp-cli.org/

# Cache

# Cap

# CLI

# Comment

# Core
alias wpcc='wp core config'
alias wpcd='wp core download'
alias wpci='wp core install'
alias wpcii='wp core is-installed'
alias wpcmc='wp core multisite-convert'
alias wpcmi='wp core multisite-install'
alias wpcu='wp core update'
alias wpcudb='wp core update-db'
alias wpcvc='wp core verify-checksums'

# Cron
alias wpcre='wp cron event'
alias wpcrs='wp cron schedule'
alias wpcrt='wp cron test'

# Db

# Eval

# Eval-File

# Export

# Help

# Import

# Media

# Menu
alias wpmc='wp menu create'
alias wpmd='wp menu delete'
alias wpmi='wp menu item'
alias wpml='wp menu list'
alias wpmlo='wp menu location'

# Network

# Option

# Plugin
alias wppa='wp plugin activate'
alias wppda='wp plugin deactivate'
alias wppd='wp plugin delete'
alias wppg='wp plugin get'
alias wppi='wp plugin install'
alias wppis='wp plugin is-installed'
alias wppl='wp plugin list'
alias wppp='wp plugin path'
alias wpps='wp plugin search'
alias wppst='wp plugin status'
alias wppt='wp plugin toggle'
alias wppun='wp plugin uninstall'
alias wppu='wp plugin update'

# Post
alias wppoc='wp post create'
alias wppod='wp post delete'
alias wppoe='wp post edit'
alias wppogen='wp post generate'
alias wppog='wp post get'
alias wppol='wp post list'
alias wppom='wp post meta'
alias wppou='wp post update'
alias wppourl='wp post url'

# Rewrite

# Role

# Scaffold

# Search-Replace

# Shell

# Sidebar
alias wpsbl='wp sidebar list'

# Site

# Super-Admin

# Term

# Theme
alias wpta='wp theme activate'
alias wptd='wp theme delete'
alias wptdis='wp theme disable'
alias wpte='wp theme enable'
alias wptg='wp theme get'
alias wpti='wp theme install'
alias wptis='wp theme is-installed'
alias wptl='wp theme list'
alias wptm='wp theme mod'
alias wptp='wp theme path'
alias wpts='wp theme search'
alias wptst='wp theme status'
alias wptu='wp theme updatet'

# Transient

# User
alias wpuac='wp user add-cap'
alias wpuar='wp user add-role'
alias wpuc='wp user create'
alias wpud='wp user delete'
alias wpugen='wp user generate'
alias wpug='wp user get'
alias wpui='wp user import-csv'
alias wpul='wp user list'
alias wpulc='wp user list-caps'
alias wpum='wp user meta'
alias wpurc='wp user remove-cap'
alias wpurr='wp user remove-role'
alias wpusr='wp user set-role'
alias wpuu='wp user update'

# Widget
alias wpwa='wp widget add'
alias wpwda='wp widget deactivate'
alias wpwd='wp widget delete'
alias wpwl='wp widget list'
alias wpwm='wp widget move'
alias wpwu='wp widget update'


autoload -U +X bashcompinit && bashcompinit
# bash completion for the `wp` command

_wp_complete() {
	local cur=${COMP_WORDS[COMP_CWORD]}

	IFS=$'\n';  # want to preserve spaces at the end
	local opts="$(wp cli completions --line="$COMP_LINE" --point="$COMP_POINT")"

	if [[ "$opts" =~ \<file\>\s* ]]
	then
		COMPREPLY=( $(compgen -f -- $cur) )
	elif [[ $opts = "" ]]
	then
		COMPREPLY=( $(compgen -f -- $cur) )
	else
		COMPREPLY=( ${opts[*]} )
	fi
}
complete -o nospace -F _wp_complete wp
