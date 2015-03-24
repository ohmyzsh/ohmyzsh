launchctl_commands=(
  bootstrap unbootsrap enable disable uncache kickstart
  attach kill blame print print-cache print-disabled plist
  procinfo hostinfo resolveport limit runstats examine
  dumpstate load unload remove list start stop setenv
  unsetenv getenv bsexec asuser submit managerpid
  manageruid managername error variant version help)

for c in $launchctl_commands; do; alias lc-$c="launchctl $c"; done
