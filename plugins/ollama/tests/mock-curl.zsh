#!/bin/zsh -f
# Offline responses for the shared service and the user's local daemon.
emulate -LR zsh
local request=${@[(r)http*]} model names parameter sort
integer index
for (( index = 1; index <= $#; index++ )); do
  if [[ $argv[index] == --data-urlencode ]]; then
    parameter=$argv[$(( ++index ))]
    case $parameter in
      model=*) model=${parameter#model=} ;;
      names=*) names=${parameter#names=} ;;
      sort=*) sort=${parameter#sort=} ;;
    esac
  fi
done
local logged=$request
[[ -n $model ]] && logged+="?model=$model"
[[ -n $names ]] && logged+="?names=$names"
[[ -n $sort ]] && logged+="?sort=$sort"
print -r -- "$logged" >> "$OLLAMA_TEST_REQUESTS"
[[ -f "$OLLAMA_TEST_SCRATCH/offline" && $request == */api/v1/* ]] && exit 7
if [[ -f "$OLLAMA_TEST_SCRATCH/invalid-response" &&
      $request == */api/v1/* ]]; then
  print '<html>service temporarily unavailable</html>'
  exit 0
fi
case $request in
  */api/tags) cat "$OLLAMA_TEST_FIXTURES/local-models.json" ;;
  */api/ps) cat "$OLLAMA_TEST_FIXTURES/running-models.json" ;;
  */api/v1/models)
    if [[ $sort == newest ]]; then
      cat "$OLLAMA_TEST_FIXTURES/newest-models.tsv"
    elif [[ $sort == popular ]]; then
      cat "$OLLAMA_TEST_FIXTURES/popular-models.tsv"
    elif [[ -n $names ]]; then
      awk -F '\t' -v names=",$names," \
        'index(names, "," $1 ",") { print }' \
        "$OLLAMA_TEST_FIXTURES/model-names.tsv"
    else
      cat "$OLLAMA_TEST_FIXTURES/model-names.tsv"
    fi
    ;;
  */api/v1/tags)
    case $model in
      gemma3) cat "$OLLAMA_TEST_FIXTURES/gemma-tags.tsv" ;;
      sort-model) cat "$OLLAMA_TEST_FIXTURES/sort-tags.tsv" ;;
      qwen3.5|library/qwen3.5)
        if [[ $model == library/* ]]; then
          awk '{ print "library/" $0 }' "$OLLAMA_TEST_FIXTURES/qwen-tags.tsv"
        else
          cat "$OLLAMA_TEST_FIXTURES/qwen-tags.tsv"
        fi
        [[ -f "$OLLAMA_TEST_SCRATCH/updated" ]] && \
          print -r -- "$model:9b-mlx"$'\t7800000000\t7.8GB\t0'
        ;;
      team/custom) print -r -- $'team/custom:small-v1\t122000000\t122MB\t0' ;;
      team/cold) exit 22 ;;
      *)
        print -r -- "UNEXPECTED: $logged" >> "$OLLAMA_TEST_REQUESTS"
        exit 22
        ;;
    esac
    ;;
  *) print -r -- "UNEXPECTED: $logged" >> "$OLLAMA_TEST_REQUESTS"; exit 22 ;;
esac
exit 0
