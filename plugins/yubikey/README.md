# YubiKey Plugin

YubiKey plugin -- Provides aliases to help use YubiKey tokens comfortably

## Usage

This plugin will first try to detect location of the 'opensc-pkcs11.so' library, unless already specified in the $OPENSC env var.

Afterwards, it will try to detect if a 'shared ssh-agent' is already running, through a file in /run (preferred, but must be pre-created with the proper permissions), or in /tmp (fallback).

Then it will define several aliases.

## Optional Parameters

These parameters can be set before source-ing oh-my-zsh to customize the settings:

`YUBI_SHOWKEYS`
> If set to '1' or 'y' or 'yes', will list the keys contained in the 'shared ssh-agent'

`YUBI_SSHAGENT_AUTOINIT`
> If set to '1' or 'y' or 'yes', will automatically initialize the 'shared ssh-agent' if one is not found

