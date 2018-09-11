# YubiKey Plugin

YubiKey plugin -- Provides aliases to help use YubiKey tokens comfortably

## Usage

This plugin will first try to detect location of the 'opensc-pkcs11.so' library, unless already specified in the $OPENSC env var (that is, before source-ing oh-my-zsh).

Afterwards, it will try to detect if a 'shared ssh-agent' is already running, through a file in `/run/user/$UID`, or if no such directory, in `/tmp` as a fallback.

Then it will define several aliases. You can see them by issuing the command `alias | grep yubi-`.

## Optional Parameters

These parameters can be set **_before_** source-ing oh-my-zsh to customize the settings:

`YUBI_SHOWKEYS`
> If set to '1' or 'y' or 'yes' (case-insensitive), will list the keys contained in the 'shared ssh-agent'

`YUBI_SSHAGENT_AUTOINIT`
> If set to '1' or 'y' or 'yes' (case-insensitive), will automatically initialize the 'shared ssh-agent' if one is not found

