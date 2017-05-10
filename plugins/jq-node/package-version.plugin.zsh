# package-version.plugin.zsh
# Shows the version of the package.json file in current directory
package_version() {
    if [[ -f ./package.json ]]
    then
        echo "v$(jq -r .version package.json)"
    else
        echo "no package.json file found"
    fi
}

# shorts
pv() {
    package_version
}