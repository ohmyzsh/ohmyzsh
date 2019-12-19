# Personalized!

# Grab the current date (%D) and time (%T) wrapped in {}: {%D %T}
DALLAS_CURRENT_TIME_="%F{white}{%F{yellow}%D %T%F{white}}%f"
# Grab the current machine name: muscato
DALLAS_CURRENT_MACH_="%F{green}%m%F{white}:%f"
# Grab the current filepath, use shortcuts: ~/Desktop
# Append the current git branch, if in a git repository: ~aw@master
DALLAS_CURRENT_LOCA_="%F{cyan}%~\$(git_prompt_info)%f\$(parse_git_dirty)"
# Grab the current username: dallas
DALLAS_CURRENT_USER_="%F{red}%n%f"
# Use a % for normal users and a # for privelaged (root) users.
DALLAS_PROMPT_CHAR_="%F{white}%(!.#.%%)%f"
# For the git prompt, use a white @ and blue text for the branch name
ZSH_THEME_GIT_PROMPT_PREFIX="%F{white}@%F{blue}"
# Close it all off by resetting the color and styles.
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
# Do nothing if the branch is clean (no changes).
ZSH_THEME_GIT_PROMPT_CLEAN=""
# Add 3 cyan ✗s if this branch is diiirrrty! Dirty branch!
ZSH_THEME_GIT_PROMPT_DIRTY="%F{cyan}✗✗✗"

ZSH_THEME_RUBY_PROMPT_PREFIX="%F{white}[%F{magenta}"
ZSH_THEME_RUBY_PROMPT_SUFFIX="%F{white}]%f"

# Put it all together!
PROMPT="$DALLAS_CURRENT_TIME_\$(ruby_prompt_info)$DALLAS_CURRENT_MACH_$DALLAS_CURRENT_LOCA_ $DALLAS_CURRENT_USER_$DALLAS_PROMPT_CHAR_ "
