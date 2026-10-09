function backup_zshrc() {
    # Function to back up ~/.zshrc locally and to a GitHub repository
    # Runs every time zsh is opened or source ~/.zshrc is run
    # Checks for git changes, will commit and push changes if detected
    #

    local current_dir=$(pwd)
    local backup_dir="$HOME/projects/backups"
    github_username=$(git config --global user.name | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
    local commit_message="Backup ~/.zshrc at $(date +'%Y_%m_%d-%H%M%S')"

    # Prompt for GitHub username if not set
    if [[ -z "$github_username" ]]; then
        read -p "Enter your GitHub username: " github_username
    fi

    # Create a backup directory if it doesn't exist
    mkdir -p "$backup_dir"

    cd "$backup_dir" || return

    # Backup ~/.zshrc with a timestamp
    local timestamp=$(date +'%Y_%m_%d-%H%M%S')
    local backup_file="$backup_dir/zshrc_backup_$timestamp"
    cp "$HOME/.zshrc" "$backup_dir/.zshrc"

    changes=$(git diff --quiet --exit-code -- "$backup_dir" || echo "yes")

    if [[ "$changes" == "yes" ]]; then
        echo "Changes detected in $backup_dir/.zshrc"
        cp "$HOME/.zshrc" "$backup_file"
        git add . > /dev/null 2>&1
        if git commit -m "$commit_message" > /dev/null 2>&1; then
            if git push > /dev/null 2>&1; then
                repo_url="https://github.com/$github_username/backups"
                echo "Backup successfully pushed to GitHub. View it at: $repo_url"
            else
                push_error=$(git push 2>&1)
                echo "Error: Failed to push backup to GitHub. Error details: $push_error"
            fi
        else
            commit_error=$(git commit -m "$commit_message" 2>&1)
            echo "Error: Failed to commit changes for backup. Error details: $commit_error"
        fi
    else
        echo "No changes detected in $backup_dir for .zshrc"
    fi

    cd "$backup_dir" || return
    git add . > /dev/null 2>&1
    cd "$current_dir" || return
}

backup_zshrc