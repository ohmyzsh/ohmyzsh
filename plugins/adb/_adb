#compdef adb
#autoload

# in order to make this work, you will need to have the android adb tools

# adb zsh completion, based on homebrew completion

local -a _1st_arguments
_1st_arguments=(
'bugreport:return all information from the device that should be included in a bug report.'
'connect:connect to a device via TCP/IP Port 5555 is default.'
'devices:list all connected devices'
'disconnect:disconnect from a TCP/IP device. Port 5555 is default.'
'emu:run emulator console command'
'forward:forward socket connections'
'get-devpath:print the device path'
'get-serialno:print the serial number of the device'
'get-state:print the current state of the device: offline | bootloader | device'
'help:show the help message'
'install:push this package file to the device and install it'
'jdwp:list PIDs of processes hosting a JDWP transport'
'keygen:generate adb public/private key'
'kill-server:kill the server if it is running'
'logcat:view device log'
'pull:copy file/dir from device'
'push:copy file/dir to device'
'reboot:reboots the device, optionally into the bootloader or recovery program'
'reboot-bootloader:reboots the device into the bootloader'
'remount:remounts the partitions on the device read-write'
'root:restarts the adbd daemon with root permissions'
'sideload:push a ZIP to device and install it'
'shell:run remote shell interactively'
'sync:copy host->device only if changed (-l means list but dont copy)'
'start-server:ensure that there is a server running'
'tcpip:restart host adb in tcpip mode'
'uninstall:remove this app package from the device'
'usb:restart the adbd daemon listing on USB'
'version:show version num'
'wait-for-device:block until device is online'
)

local expl
local -a pkgs installed_pkgs

_arguments \
	'-s[devices]:specify device:->specify_device' \
	'*:: :->subcmds' && return 0

case "$state" in
	specify_device)
	_values -C 'devices' ${$(adb devices -l|awk 'NR>1&& $1 \
		{sub(/ +/," ",$0);gsub(":","\\:",$1); printf "%s[%s] ",$1, $NF}'):-""}
	return
	;;
esac

if (( CURRENT == 1 )); then
	_describe -t commands "adb subcommand" _1st_arguments
	return
fi

_files