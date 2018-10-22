function _iterm2_touch_bar_status(){
	if [ -z $ITERM2_TOUCH_BAR_STATUS ];
	then
		ITERM2_TOUCH_BAR_STATUS='"$(pwd)"';
	fi

	if [ -z $ITERM2_DIR ];
	then
		ITERM2_DIR="$HOME/.iterm2"
	fi	
		
	$ITERM2_DIR/it2setkeylabel set status "$(eval echo $ITERM2_TOUCH_BAR_STATUS)"
}

autoload -U add-zsh-hook
add-zsh-hook precmd _iterm2_touch_bar_status
