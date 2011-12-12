function zsh_stats() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}
