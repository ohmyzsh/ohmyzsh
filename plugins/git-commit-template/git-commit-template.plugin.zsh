# Color formatting
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[1;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

git_commit_template() {

    # Check the current folder is a git repository
    $(git -C $PWD rev-parse)
    if [[ $? != 0 ]]; then
        exit 1
    fi

    # Valid types
    TYPES=("feat" "fix" "docs" "style" "refactor"
        "perf" "test" "build" "ci" "chore" "revert")

    NUMBERS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11")

    # Type section
    printf "${BLUE}>>> Type of change (name or number)?${RESET}\n\n"

    printf "${CYAN}1.  feat${RESET} - A new feature.\n"
    printf "${CYAN}2.  fix${RESET} - A bug fix.\n"
    printf "${CYAN}3.  docs${RESET} - Documentation only changes.\n"
    printf "${CYAN}4.  style${RESET} - Changes that do notaffect the meaning of \
the code (white-space, formatting, missing semi-colons, etc).\n"
    printf "${CYAN}5.  refactor${RESET} - A Code change that neither fixes a bug \
nor adds a feature.\n"
    printf "${CYAN}6.  perf${RESET} - A code change that improves performance.\n"
    printf "${CYAN}7.  test${RESET} - Adding missing tests or correcting existing \
tests.\n"
    printf "${CYAN}8.  build${RESET} - Changes that effect the build system or \
external dependencies (example scopes: glup, broccoli, npm).\n"
    printf "${CYAN}9.  ci${RESET} - Changes to our CI configuration files and \
scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs).\n"
    printf "${CYAN}10. chore${RESET} - Other changes that don't modify src or test \
files.\n"
    printf "${CYAN}11. revert${RESET} - Reverts a previous commit.\n\n"

    while :; do
        read -e type_var
        # To lower case
        type_var=${type_var,,}
        # When input type is valid loop break
        if [[ " ${NUMBERS[*]} " =~ " ${type_var} " ]]; then
            type_var="${TYPES[type_var - 1]}"
            break
        elif [[ " ${TYPES[*]} " =~ " ${type_var} " ]]; then
            break
        else
            printf "${RED}❌ Please select a valid type.${RESET}\n"
        fi
    done

    # Scppe section
    printf "\n${BLUE}>>> Scope of this change (optional)?${RESET}\n"
    printf "The scope could be anything specifying place of the commit change e.g \
a file name, function name, class name, component name etc.\n\n"
    read -e scope

    # Subject section
    printf "\n${BLUE}>>> Short description?${RESET}\n"
    printf "The short description contains succinct description of the change:\n"
    printf "  • use the imperative, present tense: 'change' not 'changed' nor \
'changes'\n"
    printf "  • don't capitalize first letter\n"
    printf "  • no dot (.) at the end\n\n"

    while :; do
        read -e short_desc
        if [ -z "$short_desc" ]; then
            printf "${RED}❌ Short description can not be empty.${RESET}\n"
        elif [[ ${#limit_counter} -gt 50 ]]; then
            printf "${RED}❌ The maximum character for header is 50, Please\
 provide details in long descriptions.${RESET}\n"
        else
            break
        fi
    done

    # Description section
    printf "\n${BLUE}>>> Long description (optional)?${RESET}\n"
    printf "The body should include the motivation for the change and contrast \
this with previous behavior.\n\n"
    read -e long_desc

    # Breaking changes section
    printf "\n${BLUE}>>> Breaking changes (optional)?${RESET}\n"
    printf "note the reason for a breaking change within the commit.\n\n"
    read -e breaking_changes

    # Closed issues section
    printf "\n${BLUE}>>> Closed issues (optional)?${RESET}\n"
    printf "The syntax for closing keywords depends on whether the issue is in \
the same repository as the pull request.\n"
    printf "  • Issue in the same repository -> Closes #10\n"
    printf "  • Issue in a different repository -> Fixes octo-org/octo-repo#100\n"
    printf "  • Multiple issues -> Resolves #10, resolves #123, resolves \
octo-org/octo-repo#100\n\n"
    read -e closed_issues

    # Result section
    if [ ! -z "$scope" ]; then
        scope="(${scope})"
    fi

    massage="\n    ${GREEN}${type_var}${scope}: ${short_desc}\n"

    if [ ! -z "$long_desc" ] || [ ! -z "$breaking_changes" ] || [ ! -z "$closed_issues" ]; then
        massage="${massage}\n"
    fi

    if [ ! -z "$long_desc" ]; then
        massage="${massage}    ${long_desc}\n"
    fi

    if [ ! -z "$breaking_changes" ]; then
        massage="${massage}\n    BREAKING CHANGE: ${breaking_changes}\n"
    fi

    if [ ! -z "$closed_issues" ]; then
        massage="${massage}\n    ${closed_issues}\n"
    fi

    printf "${massage}\n${RESET}"

    # Git commit
    if [ $? == 0 ]; then
        if [[ $1 == "-s" ]] || [[ $1 == "sign" ]]; then
            git commit -S -m "${type_var}${scope}: ${short_desc}

${long_desc}

${breaking_changes}

${closed_issues}"
        else
            git commit -m "${type_var}${scope}: ${short_desc}

${long_desc}

${breaking_changes}

${closed_issues}"
        fi
    else
        printf "\n${RED}❌ An error occurred. Please try again.${RESET}\n"
        exit 1
    fi
}

alias gct='git_commit_template'
