function arc_prompt_info() {
    arcStatus=$(arc status 2>/dev/null)
    arcBranch=$(echo $arcStatus | sed -n 's/^On branch \(.*\)$/\1/p')
    arcStatus=$([ -z "$(arc status --short 2>/dev/null)" ] && echo "true" || echo "false")
    arcBranchPrefix="${ARC_BRANCH_PREFIX:-}"
    arcBranchSuffix="${ARC_BRANCH_SUFFIX:-}"
    arcBranchOutput=""
    if [[ -n "$arcBranch" ]]; then
        arcBranchOutput=" $arcBranchPrefix$arcBranch"
        if [[ "$arcStatus" == "true" ]]; then
            arcBranchOutput+="${ARC_PROMPT_CLEAN:-}"
        else
            arcBranchOutput+="${ARC_PROMPT_DIRTY:-}"
        fi
        arcBranchOutput+="$arcBranchSuffix"
    fi

    echo $arcBranchOutput
}