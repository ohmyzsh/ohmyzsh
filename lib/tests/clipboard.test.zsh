#!/usr/bin/zsh -df

test_dir=$(mktemp -d) || exit 1
trap 'rm -rf "$test_dir"' EXIT

cat > "$test_dir/clip.exe" <<'EOF'
#!/bin/sh
exit 0
EOF

cat > "$test_dir/powershell.exe" <<'EOF'
#!/bin/sh
printf 'first\r\nsecond\r\n'
EOF

chmod +x "$test_dir/clip.exe" "$test_dir/powershell.exe"
PATH="$test_dir:$PATH"
OSTYPE=linux-gnu

source "${0:A:h}/../clipboard.zsh"

actual=$(clippaste)
expected=$'first\nsecond'
if [[ "$actual" != "$expected" ]]; then
  print -u2 'WSL clipboard paste should remove PowerShell carriage returns'
  exit 1
fi
