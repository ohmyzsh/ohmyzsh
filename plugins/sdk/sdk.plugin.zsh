### SDKMAN Autocomplete for Oh My Zsh

# This is the output from sdkman. All the these options are supported at the
# moment.

# Usage: sdk <command> [candidate] [version]
#        sdk offline <enable|disable>
#
#    commands:
#        install   or i    <candidate> [version]
#        uninstall or rm   <candidate> <version>
#        list      or ls   [candidate]
#        use       or u    <candidate> [version]
#        default   or d    <candidate> [version]
#        current   or c    [candidate]
#        upgrade   or ug   [candidate]
#        version   or v
#        broadcast or b
#        help      or h
#        offline           [enable|disable]
#        selfupdate        [force]
#        update
#        flush             <candidates|broadcast|archives|temp>
#
#    candidate  :  the SDK to install: groovy, scala, grails, gradle, kotlin, etc.
#                  use list command for comprehensive list of candidates
#                  eg: $ sdk list
#
#    version    :  where optional, defaults to latest stable if not provided
#                  eg: $ sdk install groovy

local _sdk_commands=(
    install     i
    uninstall   rm
    list        ls
    use         u
    default     d
    current     c
    upgrade     ug
    version     v
    broadcast   b
    help        h
    offline
    selfupdate
    update
    flush
)

_listInstalledVersions() {
  __sdkman_build_version_csv $1 | sed -e "s/,/ /g"
}

_listInstallableVersions() {
  __sdkman_list_versions $1 | grep "^ " | sed -e "s/\* /*/g" | \
      sed -e "s/>//g" | xargs -n 1 echo | grep -v "^*"
}

_listAllVersion() {
  __sdkman_list_versions $1 | grep "^ " | sed -e "s/\*/ /g" | sed -e "s/>//g"
}

_sdk () {
  case $CURRENT in
    2)  compadd -- $_sdk_commands ;;
    3)  case "$words[2]" in
          i|install|rm|uninstall|ls|list|u|use|d|default|c|current|ug|upgrade)
                      compadd -- $SDKMAN_CANDIDATES ;;
          offline)    compadd -- enable disable ;;
          selfupdate) compadd -- force ;;
          flush)      compadd -- candidates broadcast archives temp ;;
        esac
        ;;
    4)  case "$words[2]" in
          rm|uninstall|d|default) compadd -- $(_listInstalledVersions $words[3]) ;;
          i|install)              compadd -- $(_listInstallableVersions $words[3]) ;;
          u|use)                  compadd -- $(_listAllVersion $words[3]) ;;
        esac
        ;;
  esac
}

compdef _sdk sdk
