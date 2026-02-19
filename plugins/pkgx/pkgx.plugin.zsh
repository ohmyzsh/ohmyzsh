# If pkgx is not found, don't do the rest of the script
if (( ! $+commands[pkgx] )); then
  return
fi
source <(pkgx --shellcode)
