# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# powerlevel9k Theme
# https://github.com/bhilburn/powerlevel9k
#
# This theme was inspired by agnoster's Theme:
# https://gist.github.com/3712874
#
# The `vcs_info` hooks in this file are from Tom Upton:
# https://github.com/tupton/dotfiles/blob/master/zsh/zshrc
################################################################

################################################################
# Please see the README file located in the source repository for full docs.
# What follows is a brief list of the settings variables used by this theme.
# You should define these variables in your `~/.zshrc`.
#
# Customize which segments appear in which prompts (below is also the default):
#   POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
#   POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status history time)
#
# Set your Amazon Web Services profile for the `aws` segment:
#   export AWS_DEFAULT_PROFILE=<profile_name>
#
# Set your username for the `context` segment:
#   export DEFAULT_USER=<your username>
#
# Customize the format of the time segment. Example of reverse format:
#   POWERLEVEL9K_TIME_FORMAT='%D{%S:%M:%H}'
#
# Show the hash/changeset string in the `vcs` segment:
#   POWERLEVEL9K_SHOW_CHANGESET=true
# Set the length of the hash/changeset if enabled in the `vcs` segment:
#   POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
#
# Make powerlevel9k a double-lined prompt:
#   POWERLEVEL9K_PROMPT_ON_NEWLINE=true
#
# Set the colorscheme:
#   POWERLEVEL9K_COLOR_SCHEME='light'
################################################################

## Debugging
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

# These characters require the Powerline fonts to work properly. If see boxes or
# bizarre characters below, your fonts are not correctly installed. If you
# do not want to install a special font, you can set `POWERLEVEL9K_MODE` to
# `compatible`. This shows all icons in regular symbols.
case $POWERLEVEL9K_MODE in
  'flat')
    # Awesome-Patched Font required!
    # See https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched
    LEFT_SEGMENT_SEPARATOR=''
    RIGHT_SEGMENT_SEPARATOR=''
    ROOT_ICON="\uE801" # 
    RUBY_ICON="\uE847" # 
    AWS_ICON="\uE895" # 
    BACKGROUND_JOBS_ICON="\uE82F " # 
    TEST_ICON="\uE891" # 
    OK_ICON="\u2713" # ✓
    FAIL_ICON="\u2718" # ✘
    SYMFONY_ICON="SF"
    VCS_UNTRACKED_ICON="\uE16C" # 
    VCS_UNSTAGED_ICON="\uE17C" # 
    VCS_STAGED_ICON="\uE168" # 
    VCS_STASH_ICON="\uE133 " # 
    #VCS_INCOMING_CHANGES="\uE1EB " # 
    #VCS_INCOMING_CHANGES="\uE80D " # 
    VCS_INCOMING_CHANGES="\uE131 " # 
    #VCS_OUTGOING_CHANGES="\uE1EC " # 
    #VCS_OUTGOING_CHANGES="\uE80E " # 
    VCS_OUTGOING_CHANGES="\uE132 " # 
    VCS_TAG_ICON="\uE817 " # 
    VCS_BOOKMARK_ICON="\uE87B" # 
    VCS_COMMIT_ICON="\uE821 " # 
    VCS_BRANCH_ICON="\uE220" # 
    VCS_REMOTE_BRANCH_ICON=" \uE804 " # 
    VCS_GIT_ICON="\uE20E  " # 
    VCS_HG_ICON="\uE1C3  " # 
  ;;
  'compatible')
    LEFT_SEGMENT_SEPARATOR="\u2B80" # ⮀
    RIGHT_SEGMENT_SEPARATOR="\u2B82" # ⮂
    ROOT_ICON="\u26A1" # ⚡
    RUBY_ICON=''
    AWS_ICON="AWS:"
    BACKGROUND_JOBS_ICON="\u2699" # ⚙
    TEST_ICON=''
    OK_ICON="\u2713" # ✓
    FAIL_ICON="\u2718" # ✘
    SYMFONY_ICON="SF"
    VCS_UNTRACKED_ICON='?'
    VCS_UNSTAGED_ICON="\u25CF" # ●
    VCS_STAGED_ICON="\u271A" # ✚
    VCS_STASH_ICON="\u235F" # ⍟
    VCS_INCOMING_CHANGES="\u2193" # ↓
    VCS_OUTGOING_CHANGES="\u2191" # ↑
    VCS_TAG_ICON=''
    VCS_BOOKMARK_ICON="\u263F" # ☿
    VCS_COMMIT_ICON=''
    VCS_BRANCH_ICON='@'
    VCS_REMOTE_BRANCH_ICON="\u2192" # →
    VCS_GIT_ICON='Git'
    VCS_HG_ICON='HG'
  ;;
  'awesome-patched')
    # Awesome-Patched Font required!
    # See https://github.com/gabrielelana/awesome-terminal-fonts/tree/patching-strategy/patched
    LEFT_SEGMENT_SEPARATOR="\uE0B0" # 
    RIGHT_SEGMENT_SEPARATOR="\uE0B2" # 
    ROOT_ICON="\u26A1" # ⚡
    RUBY_ICON="\uE847" # 
    AWS_ICON="\uE895" # 
    BACKGROUND_JOBS_ICON="\uE82F " # 
    TEST_ICON="\uE891" # 
    OK_ICON="\u2713" # ✓
    FAIL_ICON="\u2718" # ✘
    SYMFONY_ICON="SF"
    VCS_UNTRACKED_ICON="\uE16C" # 
    VCS_UNSTAGED_ICON="\uE17C" # 
    VCS_STAGED_ICON="\uE168" # 
    VCS_STASH_ICON="\uE133 " # 
    #VCS_INCOMING_CHANGES="\uE1EB " # 
    #VCS_INCOMING_CHANGES="\uE80D " # 
    VCS_INCOMING_CHANGES="\uE131 " # 
    #VCS_OUTGOING_CHANGES="\uE1EC " # 
    #VCS_OUTGOING_CHANGES="\uE80E " # 
    VCS_OUTGOING_CHANGES="\uE132 " # 
    VCS_TAG_ICON="\uE817 " # 
    VCS_BOOKMARK_ICON="\uE87B" # 
    VCS_COMMIT_ICON="\uE821 " # 
    VCS_BRANCH_ICON="\uE220" # 
    VCS_REMOTE_BRANCH_ICON=" \uE804 " # 
    VCS_GIT_ICON="\uE20E  " # 
    VCS_HG_ICON="\uE1C3  " # 
  ;;
  *)
    # Powerline-Patched Font required!
    # See https://github.com/Lokaltog/powerline-fonts
    LEFT_SEGMENT_SEPARATOR="\uE0B0" # 
    RIGHT_SEGMENT_SEPARATOR="\uE0B2" # 
    ROOT_ICON="\u26A1" # ⚡
    RUBY_ICON=''
    AWS_ICON="AWS:"
    BACKGROUND_JOBS_ICON="\u2699" # ⚙
    TEST_ICON=''
    OK_ICON="\u2713" # ✓
    FAIL_ICON="\u2718" # ✘
    SYMFONY_ICON="SF"
    VCS_UNTRACKED_ICON='?'
    VCS_UNSTAGED_ICON="\u25CF" # ●
    VCS_STAGED_ICON="\u271A" # ✚
    VCS_STASH_ICON="\u235F" # ⍟
    VCS_INCOMING_CHANGES="\u2193" # ↓
    VCS_OUTGOING_CHANGES="\u2191" # ↑
    VCS_TAG_ICON=''
    VCS_BOOKMARK_ICON="\u263F" # ☿
    VCS_COMMIT_ICON=''
    VCS_BRANCH_ICON="\uE0A0 " # 
    VCS_REMOTE_BRANCH_ICON="\u2192" # →
    VCS_GIT_ICON=""
    VCS_HG_ICON=""
  ;;
esac

if [[ "$POWERLEVEL9K_HIDE_BRANCH_ICON" == true ]]; then
    VCS_BRANCH_ICON=''
fi

################################################################
# color scheme
################################################################

if [[ "$POWERLEVEL9K_COLOR_SCHEME" == "light" ]]; then
  DEFAULT_COLOR=white
  DEFAULT_COLOR_INVERTED=black
  DEFAULT_COLOR_DARK="252"
else
  DEFAULT_COLOR=black
  DEFAULT_COLOR_INVERTED=white
  DEFAULT_COLOR_DARK="236"
fi

VCS_FOREGROUND_COLOR=$DEFAULT_COLOR
VCS_FOREGROUND_COLOR_DARK=$DEFAULT_COLOR_DARK

# If user has defined custom colors for the `vcs` segment, override the defaults
if [[ -n $POWERLEVEL9K_VCS_FOREGROUND ]]; then
  VCS_FOREGROUND_COLOR=$POWERLEVEL9K_VCS_FOREGROUND
fi
if [[ -n $POWERLEVEL9K_VCS_DARK_FOREGROUND ]]; then
  VCS_FOREGROUND_COLOR_DARK=$POWERLEVEL9K_VCS_DARK_FOREGROUND
fi

################################################################
# VCS Information Settings
################################################################

setopt prompt_subst
autoload -Uz vcs_info

VCS_WORKDIR_DIRTY=false
VCS_CHANGESET_PREFIX=''
if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
  # Default: Just display the first 12 characters of our changeset-ID.
  local VCS_CHANGESET_HASH_LENGTH=12
  if [[ -n "$POWERLEVEL9K_CHANGESET_HASH_LENGTH" ]]; then
    VCS_CHANGESET_HASH_LENGTH="$POWERLEVEL9K_CHANGESET_HASH_LENGTH"
  fi

  VCS_CHANGESET_PREFIX="%F{$VCS_FOREGROUND_COLOR_DARK}$VCS_COMMIT_ICON%0.$VCS_CHANGESET_HASH_LENGTH""i%f "
fi

zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' check-for-changes true

VCS_DEFAULT_FORMAT="$VCS_CHANGESET_PREFIX%F{$VCS_FOREGROUND_COLOR}%b%c%u%m%f"
zstyle ':vcs_info:git*:*' formats "%F{$VCS_FOREGROUND_COLOR}$VCS_GIT_ICON%f$VCS_DEFAULT_FORMAT"
zstyle ':vcs_info:hg*:*' formats "%F{$VCS_FOREGROUND_COLOR}$VCS_HG_ICON%f$VCS_DEFAULT_FORMAT"

zstyle ':vcs_info:*' actionformats "%b %F{red}| %a%f"

zstyle ':vcs_info:*' stagedstr " %F{$VCS_FOREGROUND_COLOR}$VCS_STAGED_ICON%f"
zstyle ':vcs_info:*' unstagedstr " %F{$VCS_FOREGROUND_COLOR}$VCS_UNSTAGED_ICON%f"

zstyle ':vcs_info:git*+set-message:*' hooks vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname
zstyle ':vcs_info:hg*+set-message:*' hooks vcs-detect-changes

# For Hg, only show the branch name
zstyle ':vcs_info:hg*:*' branchformat "$VCS_BRANCH_ICON%b"
# The `get-revision` function must be turned on for dirty-check to work for Hg
zstyle ':vcs_info:hg*:*' get-revision true
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks

if [[ "$POWERLEVEL9K_SHOW_CHANGESET" == true ]]; then
  zstyle ':vcs_info:*' get-revision true
fi

################################################################
# Prompt Segment Constructors
################################################################

# Begin a left prompt segment
# Takes four arguments:
#   * $1: Name of the function that was orginally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: Background color
#   * $3: Foreground color
#   * $4: The segment content
# The latter three can be omitted,
left_prompt_segment() {
  # Overwrite given background-color by user defined variable for this segment.
  # We get as first Parameter the function name, which called this function.
  # From the given function name, we strip the "prompt_"-prefix and uppercase it.
  # This is, prefixed with "POWERLEVEL9K_" and suffixed with either "_BACKGROUND"
  # of "_FOREGROUND", our variable name. So each new Segment should automatically
  # be overwritable by a variable following this naming convention.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 2=$BG_COLOR_MODIFIER

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 3=$FG_COLOR_MODIFIER

  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $2 != $CURRENT_BG ]]; then
    # Middle segment
    echo -n "%{$bg%F{$CURRENT_BG}%}$LEFT_SEGMENT_SEPARATOR%{$fg%} "
  else
    # First segment
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$2
  [[ -n $4 ]] && echo -n "$4 "
}

# End the left prompt, closing any open segments
left_prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$LEFT_SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%} "
  CURRENT_BG=''
}

# Begin a right prompt segment
# Takes four arguments:
#   * $1: Name of the function that was orginally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: Background color
#   * $3: Foreground color
#   * $4: The segment content
# No ending for the right prompt segment is needed (unlike the left prompt, above).
right_prompt_segment() {
  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 2=$BG_COLOR_MODIFIER

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 3=$FG_COLOR_MODIFIER

  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
  echo -n "%f%F{$2}$RIGHT_SEGMENT_SEPARATOR%f%{$bg%}%{$fg%} "
  [[ -n $4 ]] && echo -n "$4 "
}

################################################################
# The 'vcs' Segment and VCS_INFO hooks / helper functions
################################################################
prompt_vcs() {
  local vcs_prompt="${vcs_info_msg_0_}"

  if [[ -n "$vcs_prompt" ]]; then
    if [[ "$VCS_WORKDIR_DIRTY" == true ]]; then
      $1_prompt_segment "$0_MODIFIED" "yellow" "$DEFAULT_COLOR"
    else
      $1_prompt_segment "$0" "green" "$DEFAULT_COLOR"
    fi

    echo -n "$vcs_prompt "
  fi
}

function +vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' && \
            ${$(git ls-files --others --exclude-standard | sed q | wc -l)// /} != 0 ]]; then
        hook_com[unstaged]+=" %F{$VCS_FOREGROUND_COLOR}$VCS_UNTRACKED_ICON%f"
    fi
}

function +vi-git-aheadbehind() {
    local ahead behind branch_name
    local -a gitstatus

    branch_name=${$(git symbolic-ref --short HEAD 2>/dev/null)}

    # for git prior to 1.7
    # ahead=$(git rev-list origin/${branch_name}..HEAD | wc -l)
    ahead=$(git rev-list ${branch_name}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( " %F{$VCS_FOREGROUND_COLOR}$VCS_OUTGOING_CHANGES${ahead// /}%f" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${branch_name} | wc -l)
    behind=$(git rev-list HEAD..${branch_name}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( " %F{$VCS_FOREGROUND_COLOR}$VCS_INCOMING_CHANGES${behind// /}%f" )

    hook_com[misc]+=${(j::)gitstatus}
}

function +vi-git-remotebranch() {
    local remote branch_name

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify HEAD@{upstream} --symbolic-full-name 2>/dev/null)/refs\/(remotes|heads)\/}
    branch_name=${$(git symbolic-ref --short HEAD 2>/dev/null)}

    hook_com[branch]="%F{$VCS_FOREGROUND_COLOR}$VCS_BRANCH_ICON${hook_com[branch]}%f"
    # Always show the remote
    #if [[ -n ${remote} ]] ; then
    # Only show the remote if it differs from the local
    if [[ -n ${remote} && ${remote#*/} != ${branch_name} ]] ; then
        hook_com[branch]+="%F{$VCS_FOREGROUND_COLOR}$VCS_REMOTE_BRANCH_ICON%f%F{$VCS_FOREGROUND_COLOR}${remote// /}%f"
    fi
}

function +vi-git-tagname() {
    local tag

    tag=$(git describe --tags --exact-match HEAD 2>/dev/null)
    [[ -n "${tag}" ]] && hook_com[branch]=" %F{$VCS_FOREGROUND_COLOR}$VCS_TAG_ICON${tag}%f"
}

# Show count of stashed changes
# Port from https://github.com/whiteinge/dotfiles/blob/5dfd08d30f7f2749cfc60bc55564c6ea239624d9/.zsh_shouse_prompt#L268
function +vi-git-stash() {
  local -a stashes

  if [[ -s $(git rev-parse --git-dir)/refs/stash ]] ; then
    stashes=$(git stash list 2>/dev/null | wc -l)
    hook_com[misc]+=" %F{$VCS_FOREGROUND_COLOR}$VCS_STASH_ICON${stashes// /}%f"
  fi
}

function +vi-hg-bookmarks() {
  if [[ -n "${hgbmarks[@]}" ]]; then
    hook_com[hg-bookmark-string]=" %F{$VCS_FOREGROUND_COLOR}$VCS_BOOKMARK_ICON${hgbmarks[@]}%f"

    # And to signal, that we want to use the sting we just generated,
    # set the special variable `ret' to something other than the default
    # zero:
    ret=1
    return 0
  fi
}

function +vi-vcs-detect-changes() {
  if [[ -n "${hook_com[staged]}" ]] || [[ -n "${hook_com[unstaged]}" ]]; then
    VCS_WORKDIR_DIRTY=true
  else
    VCS_WORKDIR_DIRTY=false
  fi
}

################################################################
# Prompt Segments
################################################################

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

# AWS Profile
prompt_aws() {
  local aws_profile="$AWS_DEFAULT_PROFILE"
  if [[ -n "$aws_profile" ]];
  then
    $1_prompt_segment "$0" red white "$AWS_ICON $aws_profile"
  fi
}

# Context: user@hostname (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    if [[ $(print -P "%#") == '#' ]]; then
      # Shell runs as root
      $1_prompt_segment "$0_ROOT" "$DEFAULT_COLOR" "yellow" "$USER@%m"
    else
      $1_prompt_segment "$0_DEFAULT" "$DEFAULT_COLOR" "011" "$USER@%m"
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  local current_path='%~'
  if [[ -n "$POWERLEVEL9K_SHORTEN_DIR_LENGTH" ]]; then
    # shorten path to $POWERLEVEL9K_SHORTEN_DIR_LENGTH
    current_path="%$((POWERLEVEL9K_SHORTEN_DIR_LENGTH+1))(c:.../:)%${POWERLEVEL9K_SHORTEN_DIR_LENGTH}c"
  fi

  $1_prompt_segment "$0" "blue" "$DEFAULT_COLOR" "$current_path"
}

# Command number (in local history)
prompt_history() {
  $1_prompt_segment "$0" "244" "$DEFAULT_COLOR" '%h'
}

# Right Status: (return code, root status, background jobs)
# This creates a status segment for the *right* prompt. Exact same thing as
# above - just other side.
prompt_longstatus() {
  local symbols bg
  symbols=()

  if [[ "$RETVAL" -ne 0 ]]; then
    symbols+="%F{226}%? ↵"
    bg="009"
  else
    symbols+="%{%F{"046"}%}$OK_ICON"
    bg="008"
  fi

  [[ "$UID" -eq 0 ]] && symbols+="%{%F{yellow}%} $ROOT_ICON"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$BACKGROUND_JOBS_ICON"

  [[ -n "$symbols" ]] && $1_prompt_segment "$0" "$bg" "$DEFAULT_COLOR" "$symbols"
}

# Node version
prompt_node_version() {
  local nvm_prompt=$(node -v 2>/dev/null)
  [[ -z "${nvm_prompt}" ]] && return
  NODE_ICON=$'\u2B22' # ⬢

  $1_prompt_segment "$0" "green" "white" "${nvm_prompt:1} $NODE_ICON"
}

# rbenv information
prompt_rbenv() {
  if [[ -n "$RBENV_VERSION" ]]; then
    $1_prompt_segment "$0" "red" "$DEFAULT_COLOR" "$RBENV_VERSION"
  fi
}

# RSpec test ratio
prompt_rspec_stats() {
  if [[ (-d app && -d spec) ]]; then
    local code_amount=$(ls -1 app/**/*.rb | wc -l)
    local tests_amount=$(ls -1 spec/**/*.rb | wc -l)

    build_test_stats "$1" $0 "$code_amount" $tests_amount "RSpec $TEST_ICON"
  fi
}

# Ruby Version Manager information
prompt_rvm() {
  local rvm_prompt
  rvm_prompt=`rvm-prompt`
  if [ "$rvm_prompt" != "" ]; then
    $1_prompt_segment "$0" "240" "$DEFAULT_COLOR" "$rvm_prompt $RUBY_ICON "
  fi
}

# Left Status: (return code, root status, background jobs)
# This creates a status segment for the *left* prompt
prompt_status() {
  local symbols
  symbols=()
  [[ "$RETVAL" -ne 0 ]] && symbols+="%{%F{red}%}$FAIL_ICON"
  [[ "$UID" -eq 0 ]] && symbols+="%{%F{yellow}%} $ROOT_ICON"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$BACKGROUND_JOBS_ICON"

  [[ -n "$symbols" ]] && $1_prompt_segment "$0" "$DEFAULT_COLOR" "default" "$symbols"
}

# Symfony2-PHPUnit test ratio
prompt_symfony2_tests() {
  if [[ (-d src && -d app && -f app/AppKernel.php) ]]; then
    local code_amount=$(ls -1 src/**/*.php | grep -v Tests | wc -l)
    local tests_amount=$(ls -1 src/**/*.php | grep Tests | wc -l)

    build_test_stats "$1" "$0" "$code_amount" "$tests_amount" "SF2 $TEST_ICON"
  fi
}

# Symfony2-Version
prompt_symfony2_version() {
  if [[ -f app/bootstrap.php.cache ]]; then
    local symfony2_version=$(grep " VERSION " app/bootstrap.php.cache | sed -e 's/[^.0-9]*//g')
    $1_prompt_segment "$0" "240" "$DEFAULT_COLOR" "$SYMFONY_ICON $symfony2_version"
  fi
}

# Show a ratio of tests vs code
build_test_stats() {
  local code_amount="$3"
  local tests_amount="$4"+0.00001
  local headline="$5"

  # Set float precision to 2 digits:
  typeset -F 2 ratio
  local ratio=$(( (tests_amount/code_amount) * 100 ))

  [[ ratio -ge 0.75 ]] && $1_prompt_segment "${2}_GOOD" "cyan" "$DEFAULT_COLOR" "$headline: $ratio%%"
  [[ ratio -ge 0.5 && ratio -lt 0.75 ]] && $1_prompt_segment "$2_AVG" "yellow" "$DEFAULT_COLOR" "$headline: $ratio%%"
  [[ ratio -lt 0.5 ]] && $1_prompt_segment "$2_BAD" "red" "$DEFAULT_COLOR" "$headline: $ratio%%"
}

# System time
prompt_time() {
  local time_format="%D{%H:%M:%S}"
  if [[ -n "$POWERLEVEL9K_TIME_FORMAT" ]]; then
    time_format="$POWERLEVEL9K_TIME_FORMAT"
  fi

  $1_prompt_segment "$0" "$DEFAULT_COLOR_INVERTED" "$DEFAULT_COLOR" "$time_format"
}

# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n "$virtualenv_path" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    $1_prompt_segment "$0" "blue" "$DEFAULT_COLOR" "(`basename $virtualenv_path`)"
  fi
}

################################################################
# Prompt processing and drawing
################################################################

# Main prompt
build_left_prompt() {
  RETVAL=$?

  if [[ "${#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS}" == 0 ]]; then
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
  fi

  for element in $POWERLEVEL9K_LEFT_PROMPT_ELEMENTS; do
    prompt_$element "left"
  done

  left_prompt_end
}

# Right prompt
build_right_prompt() {
  RETVAL=$?

  if [[ "${#POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS}" == 0 ]]; then
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(longstatus history time)
  fi

  for element in $POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS; do
    prompt_$element "right"
  done
}

powerlevel9k_init() {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # initialize colors
  autoload -U colors && colors

  # initialize VCS
  autoload -Uz add-zsh-hook

  add-zsh-hook precmd vcs_info

  if [[ "$POWERLEVEL9K_PROMPT_ON_NEWLINE" == true ]]; then
    [[ -n $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX ]] || POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭─"
    [[ -n $POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX ]] || POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="╰─ "

    PROMPT="$POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX%{%f%b%k%}"'$(build_left_prompt)'"
$POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX"
    # The right prompt should be on the same line as the first line of the left
    # prompt.  To do so, there is just a quite ugly workaround: Before zsh draws
    # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
    # advise it to go one line down. See:
    # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
    RPROMPT_PREFIX='%{'$'\e[1A''%}' # one line up
    RPROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
  else
    PROMPT="%{%f%b%k%}"'$(build_left_prompt)'
    RPROMPT_PREFIX=''
    RPROMPT_SUFFIX=''
  fi

  if [[ "$POWERLEVEL9K_DISABLE_RPROMPT" != true ]]; then
    RPROMPT=$RPROMPT_PREFIX"%{%f%b%k%}"'$(build_right_prompt)'"%{$reset_color%}"$RPROMPT_SUFFIX
  fi
}

powerlevel9k_init "$@"
