# c
# Navigate through your files in the current prompt.

function c() {
    cd "$1"
    if [[ $? -eq 0 ]]; then
        echo -e "\033[3A"
    fi
}
