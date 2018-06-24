ENVY_CONFIG_DIR="${ENVY_CONFIG_DIR:-${HOME}/.envy}"
ENVY_DEFAULT_ENV="${ENVY_DEFAULT_ENV:-default}"

function _envy_start() {
	_envy_load ${ENVY_DEFAULT_ENV} &>/dev/null || true
}

function _envy_load() {
	local new_profile_path="${ENVY_CONFIG_DIR}/${1}"

	if [[ ! -f ${new_profile_path} ]]; then
		echo "Cannot find envy file '${new_profile_path}'"
		return 1
	fi

	source ${new_profile_path}
}

function _envy_create() {
	local new_profile_path="${ENVY_CONFIG_DIR}/${1}"

	[[ -z "${1}" ]] && echo "No profile name argument" && return 1
	[[ ! -d "${ENVY_CONFIG_DIR}" ]] && mkdir -p ${ENVY_CONFIG_DIR}
	echo "#!/bin/bash" > ${new_profile_path}
	echo "Created empty profile: ${new_profile_path}"
}

function _envy_edit() {
	local profile_path="${ENVY_CONFIG_DIR}/${1}"

	[[ -z "${1}" ]] && echo "No profile name argument" && return 1
	[[ ! -f "${profile_path}" ]] && echo "Profile does not exists" && return 1
	${EDITOR} ${profile_path}
}

function envy() {
	case "${1}" in
		create)
			_envy_create ${2}
			;;

		edit)
			_envy_edit ${2}
			;;

		*)
			_envy_load ${1}
	esac
}

_envy_start
