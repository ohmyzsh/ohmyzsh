#!/usr/bin/env zsh

### SDKMAN Autocomplete for Oh My Zsh

_sdk() {
	case "${CURRENT}" in
	2)
		compadd -X $'Commands:\n' -- "${${(Mk)functions[@]:#__sdk_*}[@]#__sdk_}"
		compadd -n rm
		;;
	3)
		case "${words[2]}" in
		l|ls|list|i|install)
			compadd -X $'Candidates:\n' -- "${SDKMAN_CANDIDATES[@]}"
			;;
		ug|upgrade|h|home|c|current|u|use|d|default|rm|uninstall)
			compadd -X $'Installed Candidates:\n' -- "${${(u)${(f)$(find -L -- "${SDKMAN_CANDIDATES_DIR}" -mindepth 2 -maxdepth 2 -type d)}[@]:h}[@]:t}"
			;;
		e|env)
			compadd init
			;;
		offline)
			compadd enable disable
			;;
		selfupdate)
			compadd force
			;;
		flush)
			compadd archives broadcast temp version
			;;
		esac
		;;
	4)
		case "${words[2]}" in
		i|install)
			setopt localoptions kshglob
			if [[ "${words[3]}" == 'java' ]]; then
				compadd -X $'Installable Versions of java:\n' -- "${${${${${(f)$(__sdkman_list_versions "${words[3]}")}[@]:5:-4}[@]:#* | (local only|installed ) | *}[@]##* |            | }[@]%%+( )}"
			else
				compadd -X "Installable Versions of ${words[3]}:"$'\n' -- "${${(z)${(M)${(f)${$(__sdkman_list_versions "${words[3]}")//[*+>]+( )/-}}[@]:# *}[@]}[@]:#-*}"
			fi
			;;
		h|home|u|use|d|default|rm|uninstall)
			compadd -X "Installed Versions of ${words[3]}:"$'\n' -- "${${(f)$(find -L -- "${SDKMAN_CANDIDATES_DIR}/${words[3]}" -mindepth 1 -maxdepth 1 -type d -not -name 'current')}[@]:t}"
			;;
		esac
		;;
	5)
		case "${words[2]}" in
		i|install)
			_files -X "Path to Local Installation of ${words[3]} ${words[4]}:"$'\n' -/
			;;
		esac
		;;
	esac
}

compdef _sdk sdk
