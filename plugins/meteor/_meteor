#compdef meteor
#autoload

# Meteor Autocomplete plugin for Oh-My-Zsh, based on homebrew completion
# Original author: Dimitri JORGE (https://github.com/jorge-d)

_meteor_all_packages() {
  packages=(`meteor list | cut -d" " -f1`)
}
_meteor_installed_packages() {
  installed_packages=(`meteor list --using`)
}

local -a _1st_arguments
_1st_arguments=(
  "add-platform:Add a platform to this project."
  "add:Add a package to this project."
  "admin:Administrative commands."
  "authorized:View or change authorized users and organizations for a site."
  "build:Build this project for all platforms."
  "claim:Claim a site deployed with an old Meteor version."
  "configure-android:Run the Android configuration tool from Meteor's ADK environment."
  "create:Create a new project."
  "debug:Run the project, but suspend the server process for debugging."
  "deploy:Deploy this project to Meteor."
  "install-sdk:Installs SDKs for a platform."
  "lint:Build this project and run the linters printing all errors and warnings."
  "list-platforms:List the platforms added to your project."
  "list-sites:List sites for which you are authorized."
  "list:List the packages explicitly used by your project."
  "login:Log in to your Meteor developer account."
  "logout:Log out of your Meteor developer account."
  "logs:Show logs for specified site."
  "mongo:Connect to the Mongo database for the specified site."
  "publish-for-arch:Builds an already-published package for a new platform."
  "publish-release:Publish a new meteor release to the package server."
  "publish:Publish a new version of a package to the package server."
  "remove-platform:Remove a platform from this project."
  "remove:Remove a package from this project."
  "reset:Reset the project state. Erases the local database."
  "run:[default] Run this project in local development mode."
  "search:Search through the package server database."
  "shell:Launch a Node REPL for interactively evaluating server-side code."
  "show:Show detailed information about a release or package."
  "test-packages:Test one or more packages."
  "update:Upgrade this project's dependencies to their latest versions."
  "whoami:Prints the username of your Meteor developer account."
)

local expl
local -a packages installed_packages

if (( CURRENT == 2 )); then
  _describe -t commands "meteor subcommand" _1st_arguments
  return
fi

case "$words[2]" in
    help)
      _describe -t commands "meteor subcommand" _1st_arguments ;;
    remove)
      _meteor_installed_packages
      _wanted installed_packages expl 'installed packages' compadd -a installed_packages ;;
    add)
      _meteor_all_packages
      _wanted packages expl 'all packages' compadd -a packages ;;
esac
