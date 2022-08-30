#!/usr/bin/env zsh
# 
# Dream Theme for Z-shell
# @author Jakit Liang
# @date 2022-03-02

# VCS
DRM_VCS_PROMPT_BRAKET_1="%{$fg[yellow]%}|%{$reset_color%}"
DRM_VCS_PROMPT_BRAKET_2="%{$fg[yellow]%}|%{$reset_color%}"
DRM_VCS_PROMPT_SEPARATOR="%{$fg[yellow]%}:%{$reset_color%}"
DRM_VCS_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}"
DRM_VCS_PROMPT_CLEAN=""

function is_git {
	git rev-parse --is-inside-work-tree &> /dev/null
}

function vcs_git_is_clean {
	if [ -z "$(git status --porcelain)" ]; then
		return 0;
	fi

	return 1;
}

function vcs_git_diff_count {
	git status --porcelain | wc -l | tr -d ' '
}

function prompt_vcs_info {
	local vcs_type=''
	local vcs_branch='known'
	local vcs_change=''
	local vcs_diff_count=0

	if is_git; then
		vcs_type="%{$fg[blue]%}git"
		vcs_branch="${DRM_VCS_PROMPT_SEPARATOR}%{$fg[cyan]%}$(git_current_branch)"
		vcs_diff_count=$(vcs_git_diff_count)

		if [ $vcs_diff_count -gt 0 ]; then
			vcs_change="${DRM_VCS_PROMPT_SEPARATOR}%{$fg[red]%}${vcs_diff_count}"
		fi

	else
		return -1
	fi

	echo -n "${DRM_VCS_PROMPT_BRAKET_1}${vcs_type}${vcs_branch}${vcs_change}${DRM_VCS_PROMPT_BRAKET_2}"

	return $vcs_diff_count
}

function prompt_char {
	local p_char='→'
	local v_color="%{$fg_bold[cyan]%}"

	if [ $1 -eq 0 ]; then
		v_color="%{$fg_bold[green]%}"

	elif [ $1 -gt 0 ]; then
		v_color="%{$fg_bold[red]%}"
	fi

	echo -n "\n${v_color}${p_char}%{$reset_color%}"
}

function dream_prompt {
	prompt_vcs_info
	prompt_char $?
}

# Prompt format: \n # \# [DIRECTORY] |git:[BRANCH[:DIFF_NUM]| \n PROMPT_CHAR
PROMPT='\
%{$fg[yellow]%}# %{$reset_color%}\
%~ $(dream_prompt) \
%{$reset_color%}'

if [[ "$USER" == "root" ]]; then
PROMPT='\
%{$fg[yellow]%}# %{$reset_color%}\
%~ $(dream_prompt) \
%{$reset_color%}'
fi
