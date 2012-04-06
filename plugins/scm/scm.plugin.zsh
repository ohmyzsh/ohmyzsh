declare -a chpwd_functions
declare -a precmd_functions
chpwd_functions+='scm_detect_root'
precmd_functions+='scm_build_prompt_info'
 
