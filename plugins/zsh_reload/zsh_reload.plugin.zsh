print ${(%):-"%F{yellow}The \`zsh_reload\` plugin is deprecated and will be removed."}
print ${(%):-"Use \`%Bomz reload%b\` or \`%Bexec zsh%b\` instead.%f"}

src() {
  print ${(%):-"%F{yellow}$0 is deprecated. Use \`%Bomz reload%b\` or \`%Bexec zsh%b\` instead.%f\n"}
  omz reload
}
