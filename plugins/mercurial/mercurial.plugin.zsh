##	Gets branch name 
hg_branch_name(){
	hg branch 2> /dev/null | awk '{ print $1 }' || return 
}
parse_hg_dirty() {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$ZSH_THEME_HG_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_HG_PROMPT_CLEAN"
  fi
}

hg_prompt_info(){
	if [[ -d .hg ]]; then
		echo "$ZSH_THEME_HG_PROMPT_PREFIX$(hg_branch_name)$(parse_hg_dirty )$ZSH_THEME_HG_PROMPT_SUFFIX"	
	fi	
}

##	Gets bookmark name
hg_bookmark_name(){
	hg bookmarks 2> /dev/null | awk '{ print $2 }' || return 
}
hg_prompt_bookmarks(){
	if [[ -d .hg ]]; then
		echo "$ZSH_THEME_HG_PROMPT_BOOKMARK_PREFIX$(hg_bookmark_name)$ZSH_THEME_HG_BOOKMARK_PROMPT_SUFFIX"	
	fi	
}

