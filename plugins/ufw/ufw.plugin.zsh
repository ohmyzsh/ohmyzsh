# Function: Full reset and allow SSH only
ufw-lockdown() {
  echo "Locking down firewall (allow only SSH)..."
  sudo ufw reset
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw enable
}
