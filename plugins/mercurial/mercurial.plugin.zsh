hg_branch_name(){
	hg branch | awk '{ print $1 }' || return 
}
hg_prompt_info(){
	if [[ -d .hg ]]; then
		echo "$ZSH_THEME_HG_PROMPT_PREFIX$(hg_branch_name)$ZSH_THEME_HG_PROMPT_SUFFIX"	
	fi	
}


