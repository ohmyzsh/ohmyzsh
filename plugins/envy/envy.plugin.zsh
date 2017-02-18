ENVY_CONFIG_DIR="${ENVY_CONFIG_DIR:-${HOME}/.envy}"
ENVY_DEFAULT_ENV="${ENVY_DEFAULT_ENV:-default}"

function _envy_start() {
	_envy_load ${ENVY_DEFAULT_ENV} &>/dev/null || true
}

function _envy_load() {
	local new_env_path="${ENVY_CONFIG_DIR}/${1}"

	if [[ ! -f ${new_env_path} ]]; then
		echo "Cannot find envy file '${new_env_path}'"
		return 1
	fi

	source ${new_env_path}
}

function _envy_create() {
	local new_env_path="${ENVY_CONFIG_DIR}/${1}"

	[[ -z "${1}" ]] && echo "No profile name argument" && return 1
	[[ ! -d "${ENVY_CONFIG_DIR}" ]] && mkdir -p ${ENVY_CONFIG_DIR}
	echo "#!/bin/bash" > ${new_env_path}
	echo "Created empty profile: ${new_env_path}"
}

function envy() {
	case "${1}" in
		create)
			_envy_create ${2}
			;;

		*)
			_envy_load ${1}
	esac
}

_envy_start
