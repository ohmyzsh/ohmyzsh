#!/usr/bin/env zsh

EMOJI=(💩 🐦 🚀 🐞 🎨 🍕 🐭 👽 ☕️ 🔬 💀 🐷 🐼 🐶 🐸 🐧 🐳 🌟 🍔 🍣 🍻 ⛵️ 🔮 💰 💎 💾 💜 🍪 🌞 🌍 🐌 🐓 🍄 )

function random_emoji {
  echo -n "$EMOJI[$RANDOM%$#EMOJI+1]"
}

PROMPT="$(random_emoji)  "
RPROMPT='%{$fg_bold[colour255]%}%c$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=" : "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
