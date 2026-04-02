#!/usr/bin/env zsh
# keyman.plugin.zsh -- SSH & GPG key management plugin for oh-my-zsh
#
# Usage: add 'keyman' to plugins in ~/.zshrc
#
# Configuration (in .zshrc, before plugins=(...)):
#   zstyle ':omz:plugins:keyman' lang en          # en (default) | zh
#   zstyle ':omz:plugins:keyman' debug true        # show load message (default: false)
#   zstyle ':omz:plugins:keyman' default-ssh-type ed25519  # ed25519 | rsa | ecdsa

# Require at least one of ssh-keygen or gpg
(( $+commands[ssh-keygen] + $+commands[gpg] )) || return

# =====================================================
#  Persistent globals
# =====================================================
typeset -gA _km_msg

typeset -g _km_red=$'\033[0;31m'
typeset -g _km_green=$'\033[0;32m'
typeset -g _km_yellow=$'\033[0;33m'
typeset -g _km_blue=$'\033[0;34m'
typeset -g _km_cyan=$'\033[0;36m'
typeset -g _km_reset=$'\033[0m'

_km_info()  { print -r -- "${_km_blue}[keyman]${_km_reset} $*" }
_km_ok()    { print -r -- "${_km_green}[keyman] ✅${_km_reset} $*" }
_km_warn()  { print -r -- "${_km_yellow}[keyman] ⚠️${_km_reset}  $*" }
_km_err()   { print -r -- "${_km_red}[keyman] ❌${_km_reset} $*" }

# Cross-platform clipboard
_km_copy_to_clipboard() {
  local content="$1"
  if command -v pbcopy &>/dev/null; then
    printf '%s' "$content" | pbcopy
  elif command -v xclip &>/dev/null; then
    printf '%s' "$content" | xclip -selection clipboard
  elif command -v wl-copy &>/dev/null; then
    printf '%s' "$content" | wl-copy
  elif command -v clip.exe &>/dev/null; then
    printf '%s' "$content" | clip.exe
  else
    _km_warn "${_km_msg[clipboard_not_found]}"
    return 1
  fi
}

# =====================================================
#  Initialization (scoped via anonymous function)
# =====================================================
function {
  local lang
  zstyle -s ':omz:plugins:keyman' lang lang || lang=en

  case "$lang" in
    zh)
      _km_msg=(
        # -- clipboard --
        clipboard_not_found   "未找到剪贴板工具 (pbcopy/xclip/wl-copy/clip.exe)"
        # -- general --
        cancelled             "已取消"
        deleted               "已删除"
        confirm_delete        "确认删除？(y/N) "
        about_to_delete       "即将删除:"
        label_private_key     "私钥:"
        label_public_key      "公钥:"
        label_pubkey_content  "公钥内容:"
        label_file            "文件:"
        label_type            "类型:"
        label_fingerprint     "指纹:"
        label_comment         "注释:"
        # -- km-ssh-new --
        ssh_dir_created       "已创建 ~/.ssh 目录"
        file_exists           "文件已存在"
        confirm_overwrite     "是否覆盖？(y/N) "
        creating_key          "正在创建 %s 密钥..."
        unsupported_key_type  "不支持的密钥类型: %s (可选: ed25519, rsa, ecdsa)"
        key_created           "密钥已创建"
        added_to_agent        "已添加到 ssh-agent"
        key_creation_failed   "密钥创建失败"
        # -- km-ssh-ls --
        ssh_dir_not_found     "~/.ssh 目录不存在"
        no_ssh_keys_found     "未找到任何 SSH 公钥"
        # -- km-ssh-copy --
        pubkey_not_found      "公钥文件不存在"
        available_pubkeys     "可用的公钥："
        none                  "(无)"
        pubkey_copied         "公钥已复制到剪贴板"
        # -- km-ssh-rm --
        usage_ssh_rm          "用法: km-ssh-rm <keyfile>"
        key_not_found         "密钥不存在"
        # -- km-gpg-quick-new --
        usage_gpg_quick_new   "用法: km-gpg-quick-new \"姓名\" \"邮箱\" [过期时间]"
        email_has_gpg_key     "该邮箱已有 GPG 密钥:"
        confirm_create_new    "继续创建新密钥？(y/N) "
        creating_gpg_key      "正在创建 GPG 密钥..."
        label_name            "  姓名:"
        label_email           "  邮箱:"
        label_expiry          "  过期:"
        gpg_key_created       "GPG 密钥已创建"
        gpg_key_creation_failed "GPG 密钥创建失败"
        # -- km-gpg-ls --
        gpg_secret_key_list   "GPG 私钥列表:"
        gpg_public_key_list   "GPG 公钥列表:"
        # -- km-gpg-pub --
        usage_gpg_pub         "用法: km-gpg-pub <邮箱或KeyID>"
        gpg_key_not_found     "未找到密钥"
        gpg_public_key        "GPG 公钥"
        # -- km-gpg-priv --
        usage_gpg_priv        "用法: km-gpg-priv <邮箱或KeyID>"
        gpg_secret_not_found  "未找到私钥"
        warn_export_secret    "即将导出私钥！请确保在安全环境下操作"
        confirm_export        "确认导出？(y/N) "
        # -- km-gpg-copy --
        usage_gpg_copy        "用法: km-gpg-copy <邮箱或KeyID>"
        gpg_pubkey_copied     "GPG 公钥已复制到剪贴板"
        # -- km-gpg-fp --
        usage_gpg_fp          "用法: km-gpg-fp <邮箱或KeyID>"
        # -- km-gpg-rm --
        usage_gpg_rm          "用法: km-gpg-rm <邮箱或KeyID>"
        about_to_delete_gpg   "即将删除 GPG 密钥"
        key_info              "密钥信息:"
        # -- debug --
        loaded                "已加载，输入 keyman 查看帮助"
        # -- help --
        help_text \
"╔═══════════════════════════════════════════════════════════════╗
║                       keyman 密钥管理                        ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  SSH 命令:                                                    ║
║  ──────────────────────────────────────────────────────       ║
║  km-ssh-new  [comment] [file] [type]  创建 SSH 密钥          ║
║  km-ssh-ls                            列出所有 SSH 公钥      ║
║  km-ssh-copy [pubkey_file]            复制公钥到剪贴板       ║
║  km-ssh-rm   <keyfile>                删除 SSH 密钥对        ║
║                                                               ║
║  GPG 命令:                                                    ║
║  ──────────────────────────────────────────────────────       ║
║  km-gpg-new                           创建密钥（交互式）     ║
║  km-gpg-quick-new \"姓名\" \"邮箱\" [期限] 创建密钥（快速）  ║
║  km-gpg-ls [-s|--secret]              列出密钥               ║
║  km-gpg-pub  <id>                     导出公钥               ║
║  km-gpg-priv <id>                     导出私钥               ║
║  km-gpg-copy <id>                     复制公钥到剪贴板       ║
║  km-gpg-fp   <id>                     查看指纹               ║
║  km-gpg-rm   <id>                     删除密钥               ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝"
      )
      ;;
    *)
      _km_msg=(
        # -- clipboard --
        clipboard_not_found   "Clipboard tool not found (pbcopy/xclip/wl-copy/clip.exe)"
        # -- general --
        cancelled             "Cancelled"
        deleted               "Deleted"
        confirm_delete        "Confirm deletion? (y/N) "
        about_to_delete       "About to delete:"
        label_private_key     "Private key:"
        label_public_key      "Public key:"
        label_pubkey_content  "Public key content:"
        label_file            "File:"
        label_type            "Type:"
        label_fingerprint     "Fingerprint:"
        label_comment         "Comment:"
        # -- km-ssh-new --
        ssh_dir_created       "Created ~/.ssh directory"
        file_exists           "File already exists"
        confirm_overwrite     "Overwrite? (y/N) "
        creating_key          "Creating %s key..."
        unsupported_key_type  "Unsupported key type: %s (supported: ed25519, rsa, ecdsa)"
        key_created           "Key created"
        added_to_agent        "Added to ssh-agent"
        key_creation_failed   "Key creation failed"
        # -- km-ssh-ls --
        ssh_dir_not_found     "~/.ssh directory does not exist"
        no_ssh_keys_found     "No SSH public keys found"
        # -- km-ssh-copy --
        pubkey_not_found      "Public key file not found"
        available_pubkeys     "Available public keys:"
        none                  "(none)"
        pubkey_copied         "Public key copied to clipboard"
        # -- km-ssh-rm --
        usage_ssh_rm          "Usage: km-ssh-rm <keyfile>"
        key_not_found         "Key not found"
        # -- km-gpg-quick-new --
        usage_gpg_quick_new   "Usage: km-gpg-quick-new \"Name\" \"Email\" [expiry]"
        email_has_gpg_key     "This email already has a GPG key:"
        confirm_create_new    "Continue creating new key? (y/N) "
        creating_gpg_key      "Creating GPG key..."
        label_name            "  Name:"
        label_email           "  Email:"
        label_expiry          "  Expiry:"
        gpg_key_created       "GPG key created"
        gpg_key_creation_failed "GPG key creation failed"
        # -- km-gpg-ls --
        gpg_secret_key_list   "GPG secret key list:"
        gpg_public_key_list   "GPG public key list:"
        # -- km-gpg-pub --
        usage_gpg_pub         "Usage: km-gpg-pub <email-or-KeyID>"
        gpg_key_not_found     "Key not found"
        gpg_public_key        "GPG public key"
        # -- km-gpg-priv --
        usage_gpg_priv        "Usage: km-gpg-priv <email-or-KeyID>"
        gpg_secret_not_found  "Secret key not found"
        warn_export_secret    "About to export secret key! Make sure you are in a secure environment"
        confirm_export        "Confirm export? (y/N) "
        # -- km-gpg-copy --
        usage_gpg_copy        "Usage: km-gpg-copy <email-or-KeyID>"
        gpg_pubkey_copied     "GPG public key copied to clipboard"
        # -- km-gpg-fp --
        usage_gpg_fp          "Usage: km-gpg-fp <email-or-KeyID>"
        # -- km-gpg-rm --
        usage_gpg_rm          "Usage: km-gpg-rm <email-or-KeyID>"
        about_to_delete_gpg   "About to delete GPG key"
        key_info              "Key info:"
        # -- debug --
        loaded                "Loaded. Type 'keyman' for help"
        # -- help --
        help_text \
"╔═══════════════════════════════════════════════════════════════╗
║                     keyman - Key Manager                      ║
╠═══════════════════════════════════════════════════════════════╣
║                                                               ║
║  SSH Commands:                                                ║
║  ──────────────────────────────────────────────────────       ║
║  km-ssh-new  [comment] [file] [type]  Create SSH key          ║
║  km-ssh-ls                            List SSH public keys    ║
║  km-ssh-copy [pubkey_file]            Copy pubkey to clipboard║
║  km-ssh-rm   <keyfile>                Delete SSH key pair     ║
║                                                               ║
║  GPG Commands:                                                ║
║  ──────────────────────────────────────────────────────       ║
║  km-gpg-new                           Create key (interactive)║
║  km-gpg-quick-new \"Name\" \"Email\" [exp] Create key (quick) ║
║  km-gpg-ls [-s|--secret]              List keys               ║
║  km-gpg-pub  <id>                     Export public key       ║
║  km-gpg-priv <id>                     Export secret key       ║
║  km-gpg-copy <id>                     Copy pubkey to clipboard║
║  km-gpg-fp   <id>                     Show fingerprint        ║
║  km-gpg-rm   <id>                     Delete key              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝"
      )
      ;;
  esac

  # Debug output
  zstyle -t ':omz:plugins:keyman' debug && _km_info "${_km_msg[loaded]}"
}

# =====================================================
#  SSH Commands
# =====================================================

# Create SSH key
# Usage: km-ssh-new [comment] [keyfile] [type]
km-ssh-new() {
  local comment="${1:-${USER:-$(whoami)}@${HOST:-$(hostname)}}"
  local keyfile="${2:-}"
  local keytype="${3:-}"

  if [[ -z "$keytype" ]]; then
    zstyle -s ':omz:plugins:keyman' default-ssh-type keytype || keytype=ed25519
  fi

  # Set default path by type
  if [[ -z "$keyfile" ]]; then
    case "$keytype" in
      rsa)     keyfile="$HOME/.ssh/id_rsa" ;;
      ecdsa)   keyfile="$HOME/.ssh/id_ecdsa" ;;
      ed25519) keyfile="$HOME/.ssh/id_ed25519" ;;
      *)       keyfile="$HOME/.ssh/id_${keytype}" ;;
    esac
  fi

  # Ensure .ssh directory exists
  if [[ ! -d "$HOME/.ssh" ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    _km_info "${_km_msg[ssh_dir_created]}"
  fi

  # Prevent overwriting existing key
  if [[ -f "$keyfile" ]]; then
    _km_warn "${_km_msg[file_exists]}: $keyfile"
    read -q "REPLY?${_km_msg[confirm_overwrite]}"
    echo
    if [[ "$REPLY" != "y" ]]; then
      _km_info "${_km_msg[cancelled]}"
      return 1
    fi
  fi

  _km_info "$(printf "${_km_msg[creating_key]}" "$keytype")"

  local _km_rc=0
  case "$keytype" in
    rsa)
      ssh-keygen -t rsa -b 4096 -C "$comment" -f "$keyfile" || _km_rc=$?
      ;;
    ecdsa)
      ssh-keygen -t ecdsa -b 521 -C "$comment" -f "$keyfile" || _km_rc=$?
      ;;
    ed25519)
      ssh-keygen -t ed25519 -C "$comment" -f "$keyfile" || _km_rc=$?
      ;;
    *)
      _km_err "$(printf "${_km_msg[unsupported_key_type]}" "$keytype")"
      return 1
      ;;
  esac

  if [[ $_km_rc -eq 0 && -f "${keyfile}.pub" ]]; then
    chmod 600 "$keyfile"
    chmod 644 "${keyfile}.pub"

    _km_ok "${_km_msg[key_created]}"
    print ""
    print -r -- "${_km_cyan}${_km_msg[label_private_key]}${_km_reset} $keyfile"
    print -r -- "${_km_cyan}${_km_msg[label_public_key]}${_km_reset} ${keyfile}.pub"
    print ""
    print -r -- "${_km_cyan}${_km_msg[label_pubkey_content]}${_km_reset}"
    cat "${keyfile}.pub"

    # Add to ssh-agent (start agent if needed)
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
      eval "$(ssh-agent -s)" >/dev/null 2>&1
    fi
    if ssh-add "$keyfile" 2>/dev/null; then
      _km_ok "${_km_msg[added_to_agent]}"
    fi
  else
    _km_err "${_km_msg[key_creation_failed]}"
    return 1
  fi
}

# List all SSH public keys
km-ssh-ls() {
  local found=0

  if [[ ! -d "$HOME/.ssh" ]]; then
    _km_warn "${_km_msg[ssh_dir_not_found]}"
    return 1
  fi

  for pubkey in "$HOME"/.ssh/*.pub(N); do
    found=1
    local info
    info=$(ssh-keygen -l -f "$pubkey" 2>/dev/null) || continue
    local bits=${info%% *}
    local rest=${info#* }
    local fingerprint=${rest%% *}
    rest=${rest#* }
    local keytype=${rest##* }
    local comment=${rest% *}

    print -r -- "${_km_cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${_km_reset}"
    print -r -- "${_km_green}${_km_msg[label_file]}${_km_reset}     $pubkey"
    print -r -- "${_km_green}${_km_msg[label_type]}${_km_reset}     ${keytype} (${bits} bits)"
    print -r -- "${_km_green}${_km_msg[label_fingerprint]}${_km_reset}     $fingerprint"
    print -r -- "${_km_green}${_km_msg[label_comment]}${_km_reset}     $comment"
    print -r -- "${_km_green}${_km_msg[label_pubkey_content]}${_km_reset}"
    cat "$pubkey"
    echo ""
  done

  if [[ $found -eq 0 ]]; then
    _km_warn "${_km_msg[no_ssh_keys_found]}"
  fi
}

# Copy SSH public key to clipboard
# Usage: km-ssh-copy [keyfile]
km-ssh-copy() {
  local pubkey="${1:-$HOME/.ssh/id_ed25519.pub}"

  [[ "$pubkey" != *.pub ]] && pubkey="${pubkey}.pub"

  if [[ ! -f "$pubkey" ]]; then
    _km_err "${_km_msg[pubkey_not_found]}: $pubkey"
    _km_info "${_km_msg[available_pubkeys]}"
    ls "$HOME"/.ssh/*.pub 2>/dev/null || echo "  ${_km_msg[none]}"
    return 1
  fi

  local content=$(cat "$pubkey")
  if _km_copy_to_clipboard "$content"; then
    _km_ok "${_km_msg[pubkey_copied]}: $pubkey"
  fi
}

# Delete SSH key pair
# Usage: km-ssh-rm <keyfile>
km-ssh-rm() {
  if [[ -z "${1:-}" ]]; then
    _km_err "${_km_msg[usage_ssh_rm]}"
    return 1
  fi
  local keyfile="$1"

  keyfile="${keyfile%.pub}"

  if [[ ! -f "$keyfile" && ! -f "${keyfile}.pub" ]]; then
    _km_err "${_km_msg[key_not_found]}: $keyfile"
    return 1
  fi

  _km_warn "${_km_msg[about_to_delete]}"
  [[ -f "$keyfile" ]]      && echo "  ${_km_msg[label_private_key]} $keyfile"
  [[ -f "${keyfile}.pub" ]] && echo "  ${_km_msg[label_public_key]} ${keyfile}.pub"

  read -q "REPLY?${_km_msg[confirm_delete]}"
  echo
  if [[ "$REPLY" == "y" ]]; then
    ssh-add -d "$keyfile" 2>/dev/null
    [[ -f "$keyfile" ]]      && rm -f "$keyfile"
    [[ -f "${keyfile}.pub" ]] && rm -f "${keyfile}.pub"
    _km_ok "${_km_msg[deleted]}"
  else
    _km_info "${_km_msg[cancelled]}"
  fi
}

# =====================================================
#  GPG Commands
# =====================================================

# Create GPG key (interactive)
alias km-gpg-new='gpg --full-generate-key'

# Create GPG key (non-interactive)
# Usage: km-gpg-quick-new "Name" "Email" [expiry]
km-gpg-quick-new() {
  if [[ -z "${1:-}" || -z "${2:-}" ]]; then
    _km_err "${_km_msg[usage_gpg_quick_new]}"
    return 1
  fi
  local name="$1"
  local email="$2"
  local expire="${3:-2y}"

  if gpg --list-keys "$email" &>/dev/null; then
    _km_warn "${_km_msg[email_has_gpg_key]}"
    gpg --list-keys "$email"
    read -q "REPLY?${_km_msg[confirm_create_new]}"
    echo
    [[ "$REPLY" != "y" ]] && return 1
  fi

  _km_info "${_km_msg[creating_gpg_key]}"
  _km_info "${_km_msg[label_name]} $name"
  _km_info "${_km_msg[label_email]} $email"
  _km_info "${_km_msg[label_expiry]} $expire"

  local _km_rc=0
  gpg --batch --gen-key <<EOF || _km_rc=$?
    Key-Type: eddsa
    Key-Curve: ed25519
    Subkey-Type: ecdh
    Subkey-Curve: cv25519
    Name-Real: ${name}
    Name-Email: ${email}
    Expire-Date: ${expire}
    %ask-passphrase
    %commit
EOF

  if [[ $_km_rc -eq 0 ]]; then
    _km_ok "${_km_msg[gpg_key_created]}"
    echo ""
    gpg --list-keys --keyid-format long "$email"
  else
    _km_err "${_km_msg[gpg_key_creation_failed]}"
    return 1
  fi
}

# List GPG keys
# Usage: km-gpg-ls [--secret|-s]
km-gpg-ls() {
  if [[ "$1" == "--secret" || "$1" == "-s" ]]; then
    _km_info "${_km_msg[gpg_secret_key_list]}"
    echo ""
    gpg --list-secret-keys --keyid-format long
  else
    _km_info "${_km_msg[gpg_public_key_list]}"
    echo ""
    gpg --list-keys --keyid-format long
  fi
}

# Export GPG public key
# Usage: km-gpg-pub <email-or-KeyID>
km-gpg-pub() {
  if [[ -z "${1:-}" ]]; then
    _km_err "${_km_msg[usage_gpg_pub]}"
    return 1
  fi
  local key_id="$1"

  if ! gpg --list-keys "$key_id" &>/dev/null; then
    _km_err "${_km_msg[gpg_key_not_found]}: $key_id"
    return 1
  fi

  _km_info "${_km_msg[gpg_public_key]} ($key_id):"
  echo ""
  gpg --armor --export "$key_id"
}

# Export GPG secret key
# Usage: km-gpg-priv <email-or-KeyID>
km-gpg-priv() {
  if [[ -z "${1:-}" ]]; then
    _km_err "${_km_msg[usage_gpg_priv]}"
    return 1
  fi
  local key_id="$1"

  if ! gpg --list-secret-keys "$key_id" &>/dev/null; then
    _km_err "${_km_msg[gpg_secret_not_found]}: $key_id"
    return 1
  fi

  _km_warn "${_km_msg[warn_export_secret]}"
  read -q "REPLY?${_km_msg[confirm_export]}"
  echo

  if [[ "$REPLY" == "y" ]]; then
    gpg --armor --export-secret-keys "$key_id"
  else
    _km_info "${_km_msg[cancelled]}"
  fi
}

# Copy GPG public key to clipboard
# Usage: km-gpg-copy <email-or-KeyID>
km-gpg-copy() {
  if [[ -z "${1:-}" ]]; then
    _km_err "${_km_msg[usage_gpg_copy]}"
    return 1
  fi
  local key_id="$1"

  if ! gpg --list-keys "$key_id" &>/dev/null; then
    _km_err "${_km_msg[gpg_key_not_found]}: $key_id"
    return 1
  fi

  local content=$(gpg --armor --export "$key_id")
  if _km_copy_to_clipboard "$content"; then
    _km_ok "${_km_msg[gpg_pubkey_copied]} ($key_id)"
  fi
}

# Show GPG key fingerprint
# Usage: km-gpg-fp <email-or-KeyID>
km-gpg-fp() {
  if [[ -z "${1:-}" ]]; then
    _km_err "${_km_msg[usage_gpg_fp]}"
    return 1
  fi
  gpg --fingerprint "$1"
}

# Delete GPG key
# Usage: km-gpg-rm <email-or-KeyID>
km-gpg-rm() {
  if [[ -z "${1:-}" ]]; then
    _km_err "${_km_msg[usage_gpg_rm]}"
    return 1
  fi
  local key_id="$1"

  _km_warn "${_km_msg[about_to_delete_gpg]}: $key_id"
  _km_info "${_km_msg[key_info]}"
  gpg --list-keys "$key_id" 2>/dev/null
  echo ""

  read -q "REPLY?${_km_msg[confirm_delete]}"
  echo

  if [[ "$REPLY" == "y" ]]; then
    gpg --delete-secret-and-public-key "$key_id"
    _km_ok "${_km_msg[deleted]}"
  else
    _km_info "${_km_msg[cancelled]}"
  fi
}

# =====================================================
#  Help
# =====================================================
keyman() {
  print -r -- "${_km_msg[help_text]}"
}
