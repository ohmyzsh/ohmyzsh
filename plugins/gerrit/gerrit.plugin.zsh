#! /bin/bash

# Need to export url for your gerrit, example
# export GERRIT_URL=https://review.openstack.org
#
# Your git config will also need to contain you gerrit username, you can set it with
# git config --global gitreview.username
# or
# export GERRIT_USERNAME=yourusername
#
# To use any of the more advanced commands you will need to have you ssh key
# added to gerrit as this plugin uses gerrits ssh API
#
# Example usage:
#
# Fetch patch and apply it to the repo in directory tripleo-heat-templates
# $ gerrit-patch 38409 tripleo-heat-templates
# Fetch patch 38676 and apply it to the current directory/repo
# $ gerrit-patch 38676
#
# $ gerrit-get-latest-patch


# Download latest patchset from change number given. This will not apply the patch, it will however
# be stored in FETCH_HEAD to be applied.
#
# $1 change number
# $2 dir name (optional, will use current dir if not provided)
function gerrit-fetch-patch()
{
    if [[ -z "${GERRIT_URL}" ]]; then echo "GERRIT_URL must be set"; return 1; fi
    local git_dir repo_url repo_tmp ref
    git_dir="${2:-$(pwd)}"
    repo=$(repo-name "${git_dir}")
    ref=$(git ls-remote ${GERRIT_URL}/${repo} | cut -f2 | grep ${1} | sort -rnt '/' -k 5 | head -n1)
    if [[ -z "${ref}" ]]; then echo "No reference to patch ${1} found on ${GERRIT_URL}"; return 1; fi
    echo "Change ${1} in ${repo} has lastest ref: ${ref}"
    git -C "${git_dir}" fetch ${GERRIT_URL}/${repo} ${ref}
}

# Echo change id of HEAD
#
# $1 git reference
# $2 dir name
function gerrit-change-id()
{
    local git_dir="${2:-$(pwd)}"
    git -C "${git_dir}" --no-pager log -1 --format="%b" "${1}" | awk '/[cC]hange-[iI]d:/{print $2}'
}

# Echo repo name, only will work with repo names with two fields i.e. openstack/nova
#
# $1 dir name
function repo-name()
{
    local git_dir repo_url repo_tmp
    git_dir="${1:-$(pwd)}"
    repo_url="$(git -C "${git_dir}" remote -v | head -n1 | cut -f2 | cut -d' ' -f1)"
    repo_tmp="${repo_url%/*}"
    echo "${repo_tmp##*/}/${repo_url##*/}"
}

# Fetch the latest patchset for the change number given and apply it to the repo
#
# $1 change number
# $2 dir name (optional, will use current dir if not provided)
function gerrit-patch()
{
    local git_dir="${2:-$(pwd)}"
    gerrit-fetch-patch "${1}" "${git_dir}"
    git -C "${git_dir}" cherry-pick FETCH_HEAD
}

# List open patches in the gerrit system
# Print output in JSON
function gerrit-list-open-patches()
{
    if [[ -z "${GERRIT_URL}" ]]; then echo "GERRIT_URL must be set"; return 1; fi
    local json gerrit_user
    gerrit_user=$(gerrit-username)
    if [[ -z "${gerrit_user}" ]]; then return 1; fi
    json=$(gerrit-ssh-query "--current-patch-set status:open owner:${gerrit_user}")
    jq -s '.[]|select(.subject)|{subject, project, number, id, "url":"'${GERRIT_URL}'/#/c/\(.number)", reviews:[.currentPatchSet.approvals[]|{by: .by.username, value}]}' <<< $json
}


# Used to acommplish more complex gerrit queries. Requires ssh key to be added to gerrit.
# Ouput is in JSON format.
# See https://review.openstack.org/Documentation/cmd-index.html for more detail.
#
# $1 gerrit query string
function gerrit-ssh-query()
{
    if [[ -z "${GERRIT_URL}" ]]; then echo "GERRIT_URL must be set"; return 1; fi
    local gerrit_user=$(gerrit-username)
    if [[ -z "${gerrit_user}" ]]; then return 1; fi
    ssh -p 29418 ${gerrit_user}@${GERRIT_URL##*//} "gerrit query --format=JSON ${1}" | tee /tmp/gerritquery.json
}

function gerrit-username()
{
    local gerrit_user=${GERRIT_USERNAME:-"$(git config gitreview.username)"}
    if [[ -z "${gerrit_user}" ]]; then
        echo "Gerrit username not found" 1>&2
        echo "Please export GERRIT_USERNAME" 1>&2
        echo "Or set 'git config --global gitreview.username'" 1>&2
        return 1
    else
        echo "${gerrit_user}"
    fi
}
# Lookup what patchset a change id belongs to.
# Prints JSON
#
# $1 git dir (optional)
# $2 optional ref, defaults to HEAD.
function gerrit-patch-from-ref
{
    local git_dir ref cid
    git_dir="${1:-$(pwd)}"
    ref=${2:-HEAD}
    cid=$(gerrit-change-id ${ref} "${git_dir}")
    gerrit-ssh-query "${cid}" | jq -s '.[0]|select(.subject)|{subject, project, number, id, "url":"'${GERRIT_URL}'/#/c/\(.number)"}'

}

# Using HEAD get the changeid and find the latest patchset of this change and apply it
#
# $1 optional git dir
function gerrit-get-latest-patchset()
{
    local change_number git_dir
    git_dir="${1:-$(pwd)}"
    change_number=$(gerrit-patch-from-ref "${git_dir}" | jq -r .number)
    gerrit-fetch-patch "${change_number}" "${git_dir}"
    git -C "${git_dir}" reset --hard HEAD~1
    git -C "${git_dir}" cherry-pick FETCH_HEAD
}

# Will reset the current branch to HEAD~1 if change id of HEAD matches
# that of FETCH_HEAD
#
# $1 change id
# $2 optional dir name
function gerrit-reset-and-patch()
{
    local git_dir="${2:-$(pwd)}"
    gerrit-fetch-patch "${1}" "${git_dir}"

    local cid=$(change-id "HEAD" "${git_dir}")
    local rcid=$(change-id "FETCH_HEAD" "${git_dir}")
    if [[ "${cid}" == "${rcid}" ]]; then
        git -C "${git_dir}" reset --hard HEAD~1
    fi
    git -C "${git_dir}" cherry-pick FETCH_HEAD
}

function gerrit-show-patch()
{
    if [[ -z "${GERRIT_URL}" ]]; then echo "GERRIT_URL must be set"; return 1; fi
    gerrit-ssh-query "${1}" | jq -s '.[0]|select(.subject)|{subject, project, number, id, "url":"'${GERRIT_URL}'/#/c/\(.number)"}'
}

function gerrit-open-patch()
{
    if [[ -z "${GERRIT_URL}" ]]; then echo "GERRIT_URL must be set"; return 1; fi
    local git_dir ref cid url
    cid=${1:-$(gerrit-change-id HEAD)}
    url="$(gerrit-ssh-query "${cid}" | jq -s '.[0]|select(.subject)|"'${GERRIT_URL}'/#/c/\(.number)"')"
    # :Q will remove wrapping quotes
    _gerrit-browser-open ${url:Q}
}

function _gerrit-browser-open()
{
    local error_file=$(mktemp -t"gerrit.zsh.errorXXXX")
    if [[ "$(uname -s)" == 'Darwin' ]]; then
      open ${1} 2> $error_file
    else
      xdg-open ${1} 2> $error_file
    fi
    if [[ $? != 0 ]]; then
      cat $error_file 2>&1
    fi

}
