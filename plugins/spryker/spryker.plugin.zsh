# Spryker SDK command completion

_spryker() {
  echo "$(find . -maxdepth 2 -mindepth 1 -name 'sdk' -type f 2>/dev/null | head -n 1)"
}

_spryker_sdk () {
  echo "$(_spryker)"
}

_spryker_sdk_boot () {
  echo "$(_spryker) boot"
}

_spryker_sdk_console () {
  echo "$(_spryker) console"
}

_spk_console () {
  compadd $(`_spryker_sdk_console` --no-ansi 2>/dev/null | sed "1,/Available commands/d" | awk '/^  ?[^ ]+ / { print $1 }')
}

_spk_boot () {
  compadd ls deploy.*.yml
}

_spk () {
   compadd $(`_spryker_sdk` 2>/dev/null | sed "1,/Commands:/d" | awk '/^  ?[^ ]+ / { print $1 }')
}

compdef _spk_console '`_spryker_sdk_console`'
compdef _spk_console spkc
compdef _spk_boot '`_spryker_sdk_boot`'
compdef _spk_boot spkb
compdef _spk '`_spryker_sdk`'
compdef _spk spk

#Alias
alias spk='`_spryker_sdk`'
alias spkc='`_spryker_sdk_console`'
alias spkb='`_spryker_sdk_boot`'
alias spkt='spk testing'
alias spku='spk up'
alias spkup='spk up --build --assets --data'
alias spkcli='spk cli'
alias spkcc='spk clean && spk clean-data'
alias spkl='spk logs'
alias spkp='spk prune'
