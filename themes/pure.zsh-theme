print -P '%F{yellow}'Oh My Zsh pure theme:
cat <<-EOF

	  The pure theme has been renamed as 'refined' as per the original author's
	  request. Change your ZSH_THEME to 'refined' to avoid seeing this warning.

EOF
print -P '%f'

source ${0:h:A}/refined.zsh-theme
