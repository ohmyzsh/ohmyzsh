GIT_PROMPT_BRANCH_STYLE=""
GIT_PROMPT_STASH_STATE="y"
GIT_PROMPT_SHA="short"

function __git_ps1() {
	local current_dir_status current_repo_status current_branch
	local current_index_state current_upstream_status
	local r b w i s u c p f
	
	current_dir_status="$(_git_current_dir_status)"
	
	if [ "$current_dir_status" = 'not-git' ]; then
		return
	fi

	current_repo_status="$(_git_current_repo_status)"
	current_branch="$(_git_current_branch "$current_repo_status")"
	
	r="$(case "${current_repo_status}" in
			('rebase-interactive')
				echo '|REBASE-i' ;;
			('rebase-merge')
				echo '|REBASE-m' ;;
			('rebase')
				echo '|REBASE' ;;
			('am')
				echo '|AM' ;;
			('am-rebase')
				echo '|AM/REBASE' ;;
			('merge')
				echo '|MERGING' ;;
			('cherry-pick')
				echo '|CHERRY-PICKING' ;;
			('bisect')
				echo '|BISECTING' ;;
		esac)"
	b="$current_branch"
	
	if [ "$current_dir_status" = 'bare' ]; then
		c="BARE:"
	elif [ "$current_dir_status" = 'git-dir' ]; then
		b="GIT_DIR!"
	elif [ "$current_dir_status" = 'work-tree' ]; then
		current_index_state="$(_git_current_index_state)"

		if [[ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]]; then
			w="$(case "${current_index_state}" in
					(*'wtmodified'* | *'wtdeleted'*)
						echo '*' ;;
				esac)"
			i="$(case "${current_index_state}" in
					(*'imodified'* | *'iadded'* | *'ideleted'* | *'irenamed'* | *'icopied'*)
						echo '+' ;;
				esac)"
		fi

		if [[ -n "${GIT_PS1_SHOWSTASHSTATE-}" && "$current_index_state" == *'stashed'* ]]; then
			s='$'
		fi

		if [[ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" && "$current_index_state" == *'untracked'* ]]; then
      		u='%%'
   		fi

		if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
			current_upstream_status="$(_git_current_upstream_status)"
			p="$(case "$current_upstream_status" in
					('equal-upstream')
						echo '=' ;;
					('ahead-upstream')
						echo '>' ;;
					('behind-upstream')
						echo '<' ;;
					('diverged-from-upstream')
						echo '<>' ;;
				esac)"
		fi	
	fi

	f="$w$i$s$u"
	printf "${1:- (%s)}" "$c${b##refs/heads/}${f:+ $f}$r$p"
}

function git_prompt_info() {
	#Todo rewrite git_prompt_info
}

function _git_current_git_dir() {
	echo "$(__git_safe rev-parse --git-dir)"
}

function _git_current_dir_status() {
	local dir_status
	if [ -z "$(__git_safe rev-parse --git-dir)" ]; then
		dir_status='not-git'
	elif [ "$(__git_safe rev-parse --is-bare-repository)" = 'true' ]; then
		dir_status='bare'
	elif [ "$(__git_safe rev-parse --is-inside-git-dir)" = 'true' ]; then
		dir_status='git-dir'
	elif [ "$(__git_safe rev-parse --is-inside-work-tree)" = 'true' ]; then
		dir_status='work-tree'
	else
		dir_status='unkown'
	fi
	
	echo $dir_status
}

function _git_current_repo_status() {
	local gitRepository=$(_git_current_git_dir)
	local repo_status
	
	if [ -f "$gitRepository/rebase-merge/interactive" ]; then
		repo_status='rebase-interactive'
	elif [ -d "$gitRepository/rebase-merge" ]; then
		repo_status='rebase-merge'
	elif [ -d "$gitRepository/rebase-apply" ]; then
		if [ -f "$gitRepository/rebase-apply/rebasing" ]; then
			repo_status='rebase'
		elif [ -f "$gitRepository/rebase-apply/applying" ]; then
			repo_status='am'
		else
			repo_status='am-rebase'
		fi
	elif [ -f "$gitRepository/MERGE_HEAD" ]; then
		repo_status='merge'
	elif [ -f "$gitRepository/CHERRY_PICK_HEAD" ]; then
		repo_status='cherry-pick'
	elif [ -f "$gitRepository/BISECT_LOG" ]; then
		repo_status='bisect'
	else
		repo_status='normal'
	fi
	
	echo $repo_status
}

function _git_current_branch() {
	local branch
	local repo_status
	
	if [ -n "$1" ]; then
		repo_status="$1"
	else
		repo_status="$(_git_current_repo_status)"
	fi		
		
    if [[ "$repo_status" = 'rebase-interactive' ||  "$repo_status" = 'rebase-merge' ]]; then
		branch="$(cat "$(_git_current_git_dir)/rebase-merge/head-name")"
	else
		branch="$(__git_safe symbolic-ref HEAD)"
		if [ -z $branch ]; then
			if [ "$GIT_PROMPT_BRANCH_STYLE" = 'contains' ]; then
				branch="$(__git_safe describe --contains HEAD)"
			elif [ "$GIT_PROMPT_BRANCH_STYLE" = 'branch' ]; then
				branch="$(__git_safe describe --contains --all HEAD)"
			elif [ "$GIT_PROMPT_BRANCH_STYLE" = 'describe' ]; then
				branch="$(__git_safe describe HEAD)"
			else
				branch="$(__git_safe describe --tags --exact-match HEAD)"
			fi
		fi
		if [ -z $branch ]; then
			if [ "$GIT_PROMPT_SHA" = 'long' ]; then
				branch="$(__git_safe rev-parse HEAD)"
			else
				branch="$(__git_safe rev-parse --short HEAD)..."
			fi
		fi
		if [[ -z $branch || $branch = '...' ]]; then
			branch='unknow'
		fi
	fi

    echo $branch
}

function _git_current_index_state(){
	local index_state=''
	local index_status="$(__git_safe status --porcelain)"
	
	#based on git-status 'Short Format' man page
	if [ -n "$(__git_grep_status "$index_status" 'M.')" ]; then
		index_state="imodified ${index_state}"
	fi
	if [ -n "$(__git_grep_status "$index_status" 'A[ MD]')" ]; then
		index_state="iadded ${index_state}"
	fi
	if [ -n "$(__git_grep_status "$index_status" 'D[ M]')" ]; then
		index_state="ideleted ${index_state}"
	fi
	if [ -n "$(__git_grep_status "$index_status" 'R.')" ]; then
		index_state="irenamed ${index_state}"
	fi
	if [ -n "$(__git_grep_status "$index_status" 'C.')" ]; then
		index_state="icopied ${index_state}"
	fi

	if [ -n "$(__git_grep_status "$index_status" '.M')" ]; then
		index_state="wtmodified ${index_state}"
	fi
	if [ -n "$(__git_grep_status "$index_status" '[ MARC]D')" ]; then
		index_state="wtdeleted ${index_state}"
	fi

	if [ -n "$(__git_grep_status "$index_status" '??')" ]; then
		index_state="untracked ${index_state}"
	fi

	if [[ -n "${GIT_PROMPT_STASH_STATE-}" && -n "$(__git_safe stash list)" ]]; then
		index_state="stashed ${index_state}"
	fi
	
	echo $index_state
}

function _git_current_upstream_status() {
	#Todo handle svn remotes
	local upstream_status
	local upstream='@{upstream}'
	local differences_count="$(__git_safe rev-list --count --left-right "$upstream"...HEAD)"
	
	case "$differences_count" in
		'')		# no upstream
			upstream_status='no-upstream' ;;
		'0	0') # equal to upstream
			upstream_status='equal-upstream' ;;
		'0	'*) # ahead of upstream
			upstream_status='ahead-upstream' ;;
		*'	0') # behind upstream
			upstream_status='behind-upstream' ;;
		*)	    # diverged from upstream
			upstream_status='diverged-from-upstream' ;;
		esac
	
		echo $upstream_status
}

function __git_safe(){
	echo "$(git $* 2>/dev/null)"
}

function __git_grep_status(){
	echo "$(echo "$1" | grep "^$2 ")"
}





# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}
