#compdef react-native
#autoload

local -a _1st_arguments
_1st_arguments=(
    'init:<ProjectName> generates a new project and installs its dependencies'
    'android:creates an empty android project'
    'start:starts the webserver'
    'run-ios:builds your app and starts it on iOS simulator'
    'run-android:builds your app and starts it on a connected Android emulator or device'
    'new-library:generates a native library bridge'
    'bundle:builds the javascript bundle for offline use'
    'unbundle:builds javascript as "unbundle" for offline use'
    'link:[options] <packageName> links all native dependencies'
    'unlink:[options] <packageName> unlink native dependency'
    'install:[options] <packageName> install and link native dependencies'
    'uninstall:[options] <packageName> uninstall and unlink native dependencies'
    "upgrade:upgrade your app's template files to the latest version; run this after updating the react-native version in your package.json and running npm install"
    'log-android:starts adb logcat'
    'log-ios:starts iOS device syslog tail'
)


_arguments \
    '(--version)--version[show version]' \
    '(--help)--help[show help]' \
    '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "react-native subcommand" _1st_arguments
  return
fi
