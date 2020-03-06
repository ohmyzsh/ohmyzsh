# VScodium Zsh plugin
# Authors of VSCodium Zsh plugin:
#   https://github.com/msmafra
#
# VSCodium more information here:
#   https://github.com/VSCodium/vscodium
# Zsh information
#   https://www.zsh.org/
# Oh My Zsh!
#   https://ohmyz.sh/
#
# This plugin is based on VScode Zsh plugin.
# Original authors of VScode Zsh plugin:
#   https://github.com/MarsiBarsi (original author)
#   https://github.com/babakks
#
execName="codium"
codiumExists=$( \which "${execName:-NULL}" 2>&1 )

if [[ -f "${codiumExists}" ]];then
  : ${VSCODIUM:=codium}
else
  : ${VSCODIUM:-}
  printf "%s\n" "The executable 'codium' could not be found!"
fi

# Definining alias for all known options
if (( $+commands[codium] ));then
# Open current directory
alias vsc="${VSCODIUM} ."
# To read from stdin, append '-' (e.g. 'ps aux | grep code | codium -')
alias vsc-="${VSCODIUM} -"
# Options
alias vscd="${VSCODIUM} --diff"
alias vsca="${VSCODIUM} --add"
alias vscg="${VSCODIUM} --goto"
alias vscn="${VSCODIUM} --new-window"
alias vscr="${VSCODIUM} --reuse-window"
alias vscw="${VSCODIUM} --wait"
alias vscll="${VSCODIUM} --locale"
alias vscu="${VSCODIUM} --user-data-dir"
alias vscvv="${VSCODIUM} -v --version"
alias vsch="${VSCODIUM} -h --help"
alias vsct="${VSCODIUM} --telemetry"
alias vscdu="${VSCODIUM} --folder-uri"
alias vscfu="${VSCODIUM} --file-uri"
# Extensions Management
alias vsced="${VSCODIUM} --extensions-dir"
alias vscle="${VSCODIUM} --list-extensions"
alias vscsv="${VSCODIUM} --show-versions"
alias vscc="${VSCODIUM} --category"
alias vscie="${VSCODIUM} --install-extension"
alias vscue="${VSCODIUM} --uninstall-extension"
alias vscapi="${VSCODIUM} --enable-proposed-api"
# Troubleshooting
alias vscv="${VSCODIUM} --verbose"
alias vscl="${VSCODIUM} --log"
alias vscs="${VSCODIUM} --status"
alias vscps="${VSCODIUM} --prof-startup"
alias vscde="${VSCODIUM} --disable-extensions"
alias vscdei="${VSCODIUM} --disable-extension"
alias vsciei="${VSCODIUM} --inspect-extensions"
alias vscibe="${VSCODIUM} --inspect-brk-extensions"
alias vscdg="${VSCODIUM} --disable-gpu"
alias vscmm="${VSCODIUM} --max-memory"
fi
