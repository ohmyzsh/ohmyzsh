if (( ! $+commands[npx] )); then
  return
fi

if ! npx_fallback_script="$(npx --shell-auto-fallback zsh 2>/dev/null)"; then
  print -u2 ${(%):-"%F{yellow}This \`npx\` version ($(npx --version)) is not supported.%f"}
else
  source <(<<< "$npx_fallback_script")
fi

print -u2 ${(%):-"%F{yellow}The \`npx\` plugin is deprecated and will be removed soon. %BPlease disable it%b.%f"}
unset npx_fallback_script
