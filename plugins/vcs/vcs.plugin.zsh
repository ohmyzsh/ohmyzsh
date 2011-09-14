# =====[ NAME ]=================================================================
#
# VCS Plugin

# =====[ DESCRIPTION ]==========================================================
#
# Uniform prompt status for work trees originating from multiple vcs systems.
#
# =====[ FUNCTIONS ]============================================================
#
# DISPLAY
# $(vcs_status_prompt) : top-level status indicator
#
# $(vcs_dirt_status)   : indicator of and count for each type of dirty file
#                      : simple form can indicate just clean or dirty
# $(vcs_dirt_age)      : time since last significant action on the work tree
#                      : helpful for determining staleness of a tree
# $(vcs_rev_short)     : abbreviated form of current revision
# $(vcs_rev_long)      : more verbose current revision information
#
# ------------------------------------------
# FEATURE SUPPORT BY VCS
# ------------------------------------------
#
# feature               | git | hg | svn | bzr |
# ----------------------------------------------
# vcs_status_prompt     | O   | O  | O   | X   |
# vcs_dirt_status       | O   | O  | O   | X   |
# vcs_dirt_age          | O   | O  | O   | X   |
# vcs_rev_short         | O   | O  | O   | X   |
# vcs_rev_long          | O   | O  | O   | X   |
#
# O = implemented
# X = unimplemented

# DETECTION
# $(vcs_is_git)        : true if cwd is in a git work tree
#                      : (but returns false if in an ignored subdirectory)
# $(vcs_is_hg)         : true if cwd is in a mercurial work tree
# $(vcs_is_svn)        : true if cwd is in a subversion work tree
#
# CUSTOMIZATION
# see default implementations below for examples
# implement your own function with these names to override default behavior
#
# _vcs_prompt_git
# _vcs_prompt_hg
# _vcs_prompt_svn
#
# _vcs_rev_short_git
# _vcs_rev_short_hg
# _vcs_rev_short_svn
#
# _vcs_rev_long_git
# _vcs_rev_long_hg
# _vcs_rev_long_svn

# =====[ CONFIGURABLE SETTINGS (and default values) ]===========================
# Associative array for plugin settings
typeset -gA VCS_PLUGIN

# $VCS_PLUGIN[separator]                               : [string] separates elements in the vcs prompt
VCS_PLUGIN[separator]=" | "

# $VCS_PLUGIN[prompt_prefix]                           : [string] precedes contents of the vcs prompt
VCS_PLUGIN[prompt_prefix]="("
# $$VCS_PLUGIN[prompt_suffix]                          : [string] proceeds contents of the vcs prompt
VCS_PLUGIN[prompt_suffix]=")"

# $VCS_PLUGIN[dirt_status_verbosity]                   : [string] show symbols each type of dirty file
#                                                      : or a single dirty or clean symbol
VCS_PLUGIN[dirt_status_verbosity]="full"
#VCS_PLUGIN[dirt_status_verbosity]="simple"

# $VCS_PLUGIN[is_clean_symbol]                         : [string] show when the work tree has no dirty files
VCS_PLUGIN[is_clean_symbol]="%{$fg[green]%}"
VCS_PLUGIN[is_clean_symbol]+="✔"
VCS_PLUGIN[is_clean_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[is_dirty_symbol]                         : [string] show when the work tree has dirty files
VCS_PLUGIN[is_dirty_symbol]="%{$fg[red]%}"
VCS_PLUGIN[is_dirty_symbol]+="✖"
VCS_PLUGIN[is_dirty_symbol]+="%{$reset_color%}"

#VCS_PLUGIN[untracked_is_dirty]                        : [flag] "true" to consider untracked files as dirty
VCS_PLUGIN[untracked_is_dirty]=
#VCS_PLUGIN[untracked_is_dirty]=true

# $VCS_PLUGIN[untracked_symbol]                        : [string] show when there is at least one untracked file
VCS_PLUGIN[untracked_symbol]="%{$fg_bold[white]%}"
VCS_PLUGIN[untracked_symbol]+="✭"
VCS_PLUGIN[untracked_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[added_symbol]                            : [string] show when there is at least one added file
VCS_PLUGIN[added_symbol]="%{$fg[green]%}"
VCS_PLUGIN[added_symbol]+="✚"
VCS_PLUGIN[added_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[modified_symbol]                         : [string] show when there is at least one modified file
VCS_PLUGIN[modified_symbol]="%{$fg_bold[green]%}"
VCS_PLUGIN[modified_symbol]+="✹"
VCS_PLUGIN[modified_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[renamed_symbol]                          : [string] show when there is at least one renamed file
VCS_PLUGIN[renamed_symbol]="%{$fg[yellow]%}"
VCS_PLUGIN[renamed_symbol]+="➜"
VCS_PLUGIN[renamed_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[deleted_symbol]                          : [string] show when there is at least one deleted file
VCS_PLUGIN[deleted_symbol]="%{$fg[red]%}"
VCS_PLUGIN[deleted_symbol]+="✖"
VCS_PLUGIN[deleted_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[unmerged_symbol]                         : [string] show when there is at least one unmerged or conflicted file
VCS_PLUGIN[unmerged_symbol]="%{$fg[blue]%}"
VCS_PLUGIN[unmerged_symbol]+="═"
VCS_PLUGIN[unmerged_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[copied_symbol]                           : [string] show when there is at least one copied file
VCS_PLUGIN[copied_symbol]="%{fg_bold[blue]%}"
VCS_PLUGIN[copied_symbol]+="ⓒ"
VCS_PLUGIN[copied_symbol]+="%{$reset_color%}"

# $VCS_PLUGIN[include_dirty_counts]                    : [flag] "true" to include counts preceding status symbols
VCS_PLUGIN[include_dirty_counts]=true
#VCS_PLUGIN[include_dirty_counts]=

# $VCS_PLUGIN[git_vcs_symbol]                          : [string] show when the cwd is in a git work tree
VCS_PLUGIN[git_vcs_symbol]="%F{154}"
VCS_PLUGIN[git_vcs_symbol]+="±"
VCS_PLUGIN[git_vcs_symbol]+="%f"

# $VCS_PLUGIN[hg_vcs_symbol]                           : [string] show when the cwd is in an hg work tree
VCS_PLUGIN[hg_vcs_symbol]="%{$fg_bold[red]%}"
VCS_PLUGIN[hg_vcs_symbol]+="☿"
VCS_PLUGIN[hg_vcs_symbol]+="%{$reset_color%} "
#
# $VCS_PLUGIN[svn_vcs_symbol]                          : [string] show when the cwd is in an svn work tree 
VCS_PLUGIN[svn_vcs_symbol]="Ⓢ "
#VCS_PLUGIN[svn_vcs_symbol]="⚡ "

# $VCS_PLUGIN[no_vcs_symbol]                           : [string] show when cwd is not associated with a vcs
VCS_PLUGIN[no_vcs_symbol]="◯ "

# $VCS_PLUGIN[branch_prefix]
VCS_PLUGIN[branch_prefix]="%{$fg[white]%}"
# $VCS_PLUGIN[branch_suffix]
VCS_PLUGIN[branch_suffix]="%{$reset_color%}"

# $VCS_PLUGIN[rev_prefix]
VCS_PLUGIN[rev_prefix]=
# $VCS_PLUGIN[rev_suffix]
VCS_PLUGIN[rev_suffix]=

# $VCS_PLUGIN[ahead_by_prefix]
VCS_PLUGIN[ahead_by_prefix]=
# $VCS_PLUGIN[ahead_by_symbol]                         : [string] shown when there are local commits not yet pushed upstream
VCS_PLUGIN[ahead_by_symbol]="%{$fg_bold[blue]%}"
VCS_PLUGIN[ahead_by_symbol]+="⬆"
VCS_PLUGIN[ahead_by_symbol]+="%{$reset_color%}"
# $VCS_PLUGIN[ahead_by_suffix]
VCS_PLUGIN[ahead_by_suffix]=

# $VCS_PLUGIN[behind_by_prefix]
VCS_PLUGIN[behind_by_prefix]=
# $VCS_PLUGIN[behind_by_symbol]                        : [string] shown when there are commits not yet merged in from upstream
VCS_PLUGIN[behind_by_symbol]="%{$fg_bold[red]%}"
VCS_PLUGIN[behind_by_symbol]+="⬇"
VCS_PLUGIN[behind_by_symbol]+="%{$reset_color%}"
#VCS_PLUGIN[behind_by_suffix
VCS_PLUGIN[behind_by_suffix]=

# $VCS_PLUGIN[ahead_behind_prefix]                     : for combined ahead and behind indicators
VCS_PLUGIN[ahead_behind_prefix]=
# $VCS_PLUGIN[ahead_behind_separator]                  : [string] appears between ahead and behind status indicators if both are present
VCS_PLUGIN[ahead_behind_separator]=" "
# $VCS_PLUGIN[ahead_behind_suffix]
VCS_PLUGIN[ahead_behind_suffix]=$VCS_PLUGIN[separator]

# $VCS_PLUGIN[long_age_threshold]                      : [number] time in minutes a work tree can be stale before its age is considered long
VCS_PLUGIN[long_age_threshold]="360"
# $VCS_PLUGIN[medium_age_threshold]                    : [number] time in minutes a work tree can be stale before its age is considered medium
#                                                      : anything less stale will be considered short
#                                                      : a directory is not considered stale (is neutral) if it is not dirty
VCS_PLUGIN[medium_age_threshold]="120"
# $VCS_PLUGIN[time_since_commit_neutral]               : [color] used for neutral indicator
VCS_PLUGIN[time_since_commit_neutral]="%{$fg[white]%}"
# $VCS_PLUGIN[time_since_commit_short]                 : [color] used for short age
VCS_PLUGIN[time_since_commit_short]="%{$fg[green]%}"
# $VCS_PLUGIN[time_short_commit_medium]                : [color] used for medium age
VCS_PLUGIN[time_short_commit_medium]="%{$fg[yellow]%}"
# $VCS_PLUGIN[time_since_commit_long]                  : [color] used for long age
VCS_PLUGIN[time_since_commit_long]="%{$fg[red]%}"
# $VCS_PLUGIN[time_verbose]                            : [flag] "true" to see a more verbose age indicator
VCS_PLUGIN[time_verbose]=
#VCS_PLUGIN[time_verbose]=true

# VCS_DETECTION_ORDER                                  : [hash] order in which cwd will be inspected for vcs type
VCS_DETECTION_ORDER=(svn git hg)

# =====[ IMPLEMENTATION ]=======================================================

# =====[ detection ]============================================================
function vcs_is_git() {
  # this invocation handles ignored subdirectories of git work trees
  [[ -n $(git ls-files --exclude-standard 2> /dev/null) ]]
}

function vcs_is_hg() {
  hg root >/dev/null 2>/dev/null && true
}

function vcs_is_svn() {
  [[ -d .svn ]] && true
}

# =====[ display ]==============================================================

function vcs_status_prompt() {
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && _vcs_prompt ${vcs} && return
  done
  echo "$VCS_PLUGIN[no_vcs_symbol]"
}

function _vcs_prompt() {
    local vcs=$1
    local result=''
    result+="$VCS_PLUGIN[prompt_prefix]"
    result+=$(_vcs_prompt_${vcs})
    result+="$VCS_PLUGIN[prompt_suffix]"
    echo $result
}

# Default status prompts; override by defining your own functions of the same
# name in your theme but still use $(vcs_status_prompt) in your PROMPT.

function _vcs_prompt_git() {
    local result=''
    result+="$(vcs_dirt_age)"
    result+="$VCS_PLUGIN[separator]"
    result+="$(vcs_ahead_behind)"
    result+="$(vcs_dirt_status) "
    result+="$VCS_PLUGIN[git_vcs_symbol]"
    result+="$(vcs_branch)"
    echo $result
}

function _vcs_prompt_svn() {
    local result=''
    result+="$(vcs_dirt_age)"
    result+="$VCS_PLUGIN[separator]"
    result+="$(vcs_dirt_status) "
    result+="$VCS_PLUGIN[svn_vcs_symbol]"
    result+="${$(vcs_branch)#trunk}" # show nothing if "trunk"
    result+="$(vcs_rev_long)"
    echo $result
}

function _vcs_prompt_hg() {
    local result=''
    result+="$(vcs_dirt_age)"
    result+="$VCS_PLUGIN[separator]"
    result+="$(vcs_dirt_status) "
    result+="$VCS_PLUGIN[hg_vcs_symbol]"
    result+="$(vcs_branch)"
    result+="$(vcs_rev_long)"
    echo $result
}

# =====[ branch information ]===================================================

function vcs_branch() {
  local length=$1
  local value=''
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && value+=$(_vcs_branch_${vcs}) && break
  done
  [[ -z $value ]] && return
  local result=''
  result+="$VCS_PLUGIN[branch_prefix]"
  result+=$value
  result+="$VCS_PLUGIN[branch_suffix]"
  echo $result
}

function _vcs_branch_git() {
  echo ${$(git symbolic-ref HEAD 2> /dev/null)#refs/heads/} || return
}

function _vcs_branch_hg() {
  echo $(hg branch) || return
}

function _vcs_branch_svn() {
  # Strip out '/trunk/'
  echo $(svn info | awk '/Root/{root=$3 "\/(trunk/)?"};/URL/{url=$2};END{gsub(root,"",url);print url}')
}

# =====[ current revision ]=====================================================

function vcs_rev_short() { _vcs_rev "short"; }

function vcs_rev_long() { _vcs_rev "long"; }

function _vcs_rev() {
  local length=$1
  local value=''
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && value+=$(_vcs_rev_${length}_${vcs}) && break
  done
  [[ -z $value ]] && return
  local result=''
  result+="$VCS_PLUGIN[rev_prefix]"
  result+=$value
  result+="$VCS_PLUGIN[rev_suffix]"
  echo $result
}

function _vcs_rev_short_git() { echo $(git rev-parse --short HEAD 2> /dev/null); }

function _vcs_rev_short_hg() { echo $(hg log -l 1 | awk '/changeset/{split($2,revs,":")};END{print revs[1]}'); }

function _vcs_rev_short_svn() { echo $(svn info | awk '/Revision/{print $2}'); }

function _vcs_rev_long_git() { echo $(git rev-parse HEAD 2> /dev/null); }

function _vcs_rev_long_hg() { echo $(hg log -l 1 | awk '/changeset/{print $2}'); }

function _vcs_rev_long_svn() { echo "r"$(_vcs_rev_short_svn); }

function vcs_ahead_behind() {
  local ahead_by="$(vcs_ahead_by)"
  local behind_by="$(vcs_behind_by)"
  [[ -z "${ahead_by}${behind_by}" ]] && return
  local result=''
  result+="$VCS_PLUGIN[ahead_behind_prefix]"
  result+=$ahead_by
  [[ -n $ahead_by && -n $behind_by ]] && result+="$VCS_PLUGIN[ahead_behind_separator]"
  result+=$behind_by
  result+="$VCS_PLUGIN[ahead_behind_suffix]"
  echo $result
}

function vcs_ahead_by() {
  local value=''
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && value+="$(_vcs_ahead_by_${vcs})" && break
  done
  [[ -z $value ]] && return
  local result=''
  result+="$VCS_PLUGIN[ahead_by_prefix]"
  result+=$value
  result+="$VCS_PLUGIN[ahead_by_symbol]"
  result+="$VCS_PLUGIN[ahead_by_suffix]"
  echo $result
}

function _vcs_ahead_by_git() { git status --porcelain --branch --short | awk -F'[' '/ahead/{sub(/ahead /,"",$2);sub(/[],].*/,"",$2); print $2}'; }

function _vcs_ahead_by_svn() { return } # FIXME: unimplemented

function _vcs_ahead_by_hg() { return }  # FIXME: unimplemented

function vcs_behind_by() {
  local value=''
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && value+="$(_vcs_behind_by_${vcs})" && break
  done
  [[ -z $value ]] && return
  local result=''
  result+="$VCS_PLUGIN[behind_by_prefix]"
  result+=$value
  result+="$VCS_PLUGIN[behind_by_symbol]"
  result+="$VCS_PLUGIN[behind_by_suffix]"
  echo $result
}

function _vcs_behind_by_git() { git status --porcelain --branch --short | awk -F'[' '/behind/{sub(/.*behind /,"",$2);sub(/]/,"",$2)};END{print $2}'; }

function _vcs_behind_by_svn() { return } # FIXME: unimplemented

function _vcs_behind_by_hg() { return }  # FIXME: unimplemented

# =====[ dirt status ]==========================================================
# "simple": Show a clean or dirty status indicator.
# "full": Show the count of files for each type of non-clean status type next to an
# indicator of that type. e.g `6✭ 1✚ 4✹` for 6 untracked, 1 new, and 4 modified
# files.

function vcs_dirt_status() {
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && _vcs_dirt_status_${VCS_PLUGIN[dirt_status_verbosity]} ${vcs} && return
  done
}

function _vcs_dirt_status_simple() {
    local vcs=$1
    if _vcs_is_clean_${vcs}; then
      echo "$VCS_PLUGIN[is_clean_symbol]"
    else
      echo "$VCS_PLUGIN[is_dirty_symbol]"
    fi
}

function _vcs_is_clean_git() {
  local untracked=''
  [[ -z $VCS_PLUGIN[untracked_is_dirty] ]] && untracked+="--untracked=no"
  [[ -z $(git status --short --porcelain $untracked 2> /dev/null) ]] && true
}

function _vcs_is_clean_svn() {
  local untracked=''
  [[ -z $VCS_PLUGIN[untracked_is_dirty] ]] && untracked+="-q"
  [[ -z $(svn status $untracked 2> /dev/null) ]] && true
}


function _vcs_is_clean_hg() {
  local untracked=''
  [[ -z $VCS_PLUGIN[untracked_is_dirty] ]] && untracked+="-q"
  [[ -z $(hg status $untracked 2> /dev/null) ]] && true
}

function _vcs_dirt_status_full() {
    local vcs=$1
    echo $(_vcs_dirt_status_${vcs})
}

function _vcs_dirt_status_git() {
    git status --porcelain 2> /dev/null | awk "

    /^\?\? /     { untracked++ ; total++ };
    /^[AM]  /    { added++     ; total++ };
    /^[A ][MT] / { modified++  ; total++ };
    /^R  /       { renamed++   ; total++ };
    /^[A ]D /    { deleted++   ; total++ };
    /^UU /       { unmerged++  ; total++ };
    /^C  /       { copied++    ; total++ };

    END {
        if (total+0 == 0) { printf(\"%s\", \"$VCS_PLUGIN[is_clean_symbol]\"); exit; }

        count[\"untracked\"] = untracked+0 ; symbol[\"untracked\"] = \"$VCS_PLUGIN[untracked_symbol]\";
        count[\"added\"]     = added+0     ; symbol[\"added\"]     = \"$VCS_PLUGIN[added_symbol]\"    ;
        count[\"modified\"]  = modified+0  ; symbol[\"modified\"]  = \"$VCS_PLUGIN[modified_symbol]\" ;
        count[\"renamed\"]   = renamed+0   ; symbol[\"renamed\"]   = \"$VCS_PLUGIN[renamed_symbol]\"  ;
        count[\"deleted\"]   = deleted+0   ; symbol[\"deleted\"]   = \"$VCS_PLUGIN[deleted_symbol]\"  ;
        count[\"unmerged\"]  = unmerged+0  ; symbol[\"unmerged\"]  = \"$VCS_PLUGIN[unmerged_symbol]\" ;
        count[\"copied\"]    = copied+0    ; symbol[\"copied\"]    = \"$VCS_PLUGIN[copied_symbol]\"   ;

        for (i in count) {
            if (count[i]+0 != 0) {
                if (\"${VCS_PLUGIN[include_dirty_counts]}\" == \"\") {
                    printf(\"%s\", symbol[i]);
                } else {
                    printf(\"%s%s \", count[i], symbol[i]);
                }
            }
        }
    }
    " | sed -e 's/ $//' &
}

function _vcs_dirt_status_hg() {
    hg status 2> /dev/null | awk "

    /^\? /       { untracked++ ; total++ };
    /^A /        { added++     ; total++ };
    /^M /        { modified++  ; total++ };
    /^! /        { renamed++   ; total++ };
    /^R /        { deleted++   ; total++ };
    /^_ /        { unmerged++  ; total++ };
    /^_ /        { copied++    ; total++ };

    END {
        if (total+0 == 0) { printf(\"%s\", \"$VCS_PLUGIN[is_clean_symbol]\"); exit; }

        count[\"untracked\"] = untracked+0 ; symbol[\"untracked\"] = \"$VCS_PLUGIN[untracked_symbol]\";
        count[\"added\"]     = added+0     ; symbol[\"added\"]     = \"$VCS_PLUGIN[added_symbol]\"    ;
        count[\"modified\"]  = modified+0  ; symbol[\"modified\"]  = \"$VCS_PLUGIN[modified_symbol]\" ;
        count[\"renamed\"]   = renamed+0   ; symbol[\"renamed\"]   = \"$VCS_PLUGIN[renamed_symbol]\"  ;
        count[\"deleted\"]   = deleted+0   ; symbol[\"deleted\"]   = \"$VCS_PLUGIN[deleted_symbol]\"  ;
        count[\"unmerged\"]  = unmerged+0  ; symbol[\"unmerged\"]  = \"$VCS_PLUGIN[unmerged_symbol]\" ;
        count[\"copied\"]    = copied+0    ; symbol[\"copied\"]    = \"$VCS_PLUGIN[copied_symbol]\"   ;

        for (i in count) {
            if (count[i]+0 != 0) {
                if (\"$VCS_PLUGIN[include_dirty_counts]\" == \"\") {
                    printf(\"%s\", symbol[i]);
                } else {
                    printf(\"%s%s \", count[i], symbol[i]);
                }
            }
        }
    }
    " | sed -e 's/ $//' &
}

function _vcs_dirt_status_svn() {
    svn status 2> /dev/null | awk "

    /^\? /       { untracked++ ; total++ };
    /^A /        { added++     ; total++ };
    /^M /        { modified++  ; total++ };
    /^! /        { renamed++   ; total++ };
    /^D /        { deleted++   ; total++ };
    /^C /        { unmerged++  ; total++ };
    /^R /        { copied++    ; total++ };

    END {
        if (total+0 == 0) { printf(\"%s\", \"$VCS_PLUGIN[is_clean_symbol]\"); exit; }

        count[\"untracked\"] = untracked+0 ; symbol[\"untracked\"] = \"$VCS_PLUGIN[untracked_symbol]\";
        count[\"added\"]     = added+0     ; symbol[\"added\"]     = \"$VCS_PLUGIN[added_symbol]\"    ;
        count[\"modified\"]  = modified+0  ; symbol[\"modified\"]  = \"$VCS_PLUGIN[modified_symbol]\" ;
        count[\"renamed\"]   = renamed+0   ; symbol[\"renamed\"]   = \"$VCS_PLUGIN[renamed_symbol]\"  ;
        count[\"deleted\"]   = deleted+0   ; symbol[\"deleted\"]   = \"$VCS_PLUGIN[deleted_symbol]\"  ;
        count[\"unmerged\"]  = unmerged+0  ; symbol[\"unmerged\"]  = \"$VCS_PLUGIN[unmerged_symbol]\" ;
        count[\"copied\"]    = copied+0    ; symbol[\"copied\"]    = \"$VCS_PLUGIN[copied_symbol]\"   ;

        for (i in count) {
            if (count[i]+0 != 0) {
                if (\"${VCS_PLUGIN[include_dirty_counts]}\" == \"\") {
                    printf(\"%s\", symbol[i]);
                } else {
                    printf(\"%s%s \", count[i], symbol[i]);
                }
            }
        }
    }
    " | sed -e 's/ $//' &
}

# =====[ dirt age ]=============================================================
# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.

function vcs_dirt_age() {
  for vcs in $VCS_DETECTION_ORDER; do
    vcs_is_${vcs} && _vcs_dirt_age ${vcs} && return
  done
}

function _vcs_dirt_age() {
    local vcs=$1
    echo $(_vcs_dirt_age_${vcs})
}

function _vcs_dirt_age_hg() {
  local changed_date="$(hg log -l 1 --template '{date|hgdate}' | awk '{print $1 + $2}')"
  _vcs_is_clean_hg && local is_dirty=false
  echo $(_vcs_dirt_age_calculate ${changed_date} ${is_dirty:-true})
}

function _vcs_dirt_age_svn() {
  local changed_date="$(svn info | awk -F'e: ' '/Changed Date:/{gsub(" \\(.*", "", $2); print $2}')"
  _vcs_is_clean_svn && local is_dirty=false
  echo $(_vcs_dirt_age_calculate $(date -j -f "%Y-%m-%d %T %z" "${changed_date}" "+%s") ${is_dirty:-true})
}

function _vcs_dirt_age_git() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      local last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null)
      _vcs_is_clean_git && local is_dirty=false
      echo $(_vcs_dirt_age_calculate $last_commit ${is_dirty:-true})
    fi
  fi
}

function _vcs_dirt_age_calculate() {
    local last_commit=$1
    local is_dirty=$2
    local result=''
    local now=$(date +%s)
    local seconds_since_last_commit=$((now-last_commit))

    # totals
    local minutes=$((seconds_since_last_commit / 60))
    local hours=$((seconds_since_last_commit/3600))
    local years=$((seconds_since_last_commit / (86400 * 365) ))

    # sub-hours and sub-minutes
    local days=$((seconds_since_last_commit / 86400))
    local sub_hours=$((hours % 24))
    local sub_minutes=$((minutes % 60))

    if $is_dirty; then
      if [ "$minutes" -gt "$VCS_PLUGIN[long_age_threshold]" ]; then
        color="$VCS_PLUGIN[time_since_commit_long]"
      elif [ "$minutes" -gt "$VCS_PLUGIN[long_age_threshold]" ]; then
        color="$VCS_PLUGIN[time_short_commit_medium]"
      else
        color="$VCS_PLUGIN[time_since_commit_short]"
      fi
    else
      color="$VCS_PLUGIN[time_since_commit_neutral]"
    fi

    if [ "$days" -gt 365 ]; then
      result=${years}y
    else
      if [ "$hours" -gt 24 ]; then
        if [[ -n $VCS_PLUGIN[time_verbose] ]]; then
          result="${days}d${sub_hours}h${sub_minutes}m"
        else
          result="${days}d"
        fi
      elif [ "$minutes" -gt 60 ]; then
        if [[ -n $VCS_PLUGIN[time_verbose] ]]; then
          result="${hours}h${sub_minutes}m"
        else
          result="${hours}h"
        fi
      else
        result="${minutes}m"
      fi
    fi
    echo "${color}${result}%{$reset_color%}"
  }
