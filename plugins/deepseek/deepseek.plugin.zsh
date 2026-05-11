#!/bin/zsh

ds() {
  # --- preflight checks ---
  if [[ ! $+commands[curl] ]]; then
    echo "ds: curl must be installed." >&2
    return 1
  fi
  if [[ ! $+commands[jq] ]]; then
    echo "ds: jq must be installed." >&2
    return 1
  fi
  if [[ -z "$DEEPSEEK_API_KEY" ]]; then
    echo "ds: DEEPSEEK_API_KEY is not set." >&2
    return 1
  fi
  if [[ $# -eq 0 ]]; then
    echo "ds: usage — ds <natural language query>" >&2
    return 1
  fi

  # --- system prompt ---
  local sys_prompt="You're an in-line zsh assistant running on ${OSTYPE}. Your task is to answer the questions without any commentation at all, providing only the code to run in terminal. You can assume that the user understands that they need to fill in placeholders like <PORT>. You're not allowed to explain anything and you're not a chatbot. 
You only provide shell commands or code. Keep the responses to one-liner answers as much as possible. Do not decorate the answer with tickmarks."

  # --- build JSON payload safely with jq ---
  local payload
  payload=$(jq -n \
    --arg system "$sys_prompt" \
    --arg user "$*" \
    '{
      model: "deepseek-v4-flash",
      messages: [
        {role: "system", content: $system},
        {role: "user",   content: $user}
      ],
      stream: false
    }') || {
    echo "ds: failed to build JSON payload." >&2
    return 1
  }

  # --- call DeepSeek API ---
  local response
  response=$(curl https://api.deepseek.com/chat/completions -s \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${DEEPSEEK_API_KEY}" \
    -d "$payload" 2>&1) || {
    echo "ds: API request failed (network error)." >&2
    return 1
  }

  # --- extract result ---
  local result
  result=$(jq -r '.choices[0].message.content // empty' <<< "$response" 2>/dev/null)

  if [[ -z "$result" ]]; then
    local err_msg
    err_msg=$(jq -r '.error.message // "unknown error"' <<< "$response" 2>/dev/null)
    echo "ds: ${err_msg}" >&2
    return 1
  fi

  # --- copy to system clipboard (cross-platform) ---
  if [[ "$OSTYPE" == darwin* ]]; then
    print -r -- "$result" | pbcopy
  elif command -v wl-copy &>/dev/null; then
    print -r -- "$result" | wl-copy
  elif command -v xclip &>/dev/null; then
    print -r -- "$result" | xclip -selection clipboard
  fi

  # --- echo result to terminal for visibility ---
  echo "$result"

  # --- push into ZLE buffer so it sits on the next prompt line ---
  #     user can edit it or press Enter to execute immediately.
  print -z "$result"
}

