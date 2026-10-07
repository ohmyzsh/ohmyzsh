#!/bin/zsh -f
# Offline responses for actual completion network requests.
emulate -LR zsh
local request=${${@[(r)http*]}%%\?*}
print -r -- "$request" >> "$OLLAMA_TEST_REQUESTS"
[[ -f "$OLLAMA_TEST_SCRATCH/offline" && $request == https://ollama.com/* ]] && exit 7
case $request in
  */api/tags) cat "$OLLAMA_TEST_FIXTURES/local-models.json" ;;
  */api/ps) cat "$OLLAMA_TEST_FIXTURES/running-models.json" ;;
  */library/gemma3/tags) print -r -- '<a href="/library/gemma3:1b"><span>1b</span></a>' ;;
  */library/sort-model/tags) cat "$OLLAMA_TEST_FIXTURES/sort-tags.html" ;;
  */library/qwen3.5/tags)
    cat "$OLLAMA_TEST_FIXTURES/qwen-tags.html"
    [[ -f "$OLLAMA_TEST_SCRATCH/updated" ]] && print -r -- '<a href="/library/qwen3.5:9b-mlx"><span>9b-mlx</span></a>'
    ;;
  */team/custom/tags) print -r -- '<a href="/team/custom:small-v1"><span>small-v1</span></a>' ;;
  */search|*/library) cat "$OLLAMA_TEST_FIXTURES/library.html" ;;
  *) print -r -- "UNEXPECTED: $request" >> "$OLLAMA_TEST_REQUESTS"; exit 22 ;;
esac
exit 0
