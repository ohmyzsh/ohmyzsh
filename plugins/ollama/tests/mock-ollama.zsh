#!/bin/zsh -f
emulate -LR zsh
if [[ $* == 'launch --help' ]]; then
  print -r -- 'launch --help' >> "$OLLAMA_TEST_CALLS"
  cat "$OLLAMA_TEST_FIXTURES/launch-help.txt"
else
  print -r -- "UNEXPECTED: $*" >> "$OLLAMA_TEST_CALLS"
  exit 1
fi
