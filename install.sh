#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="skills-sync"
REPO_RAW="https://raw.githubusercontent.com/lucas-homer/skills-sync/master"

echo "Installing skills-sync..."

# Create install directory
mkdir -p "$INSTALL_DIR"

# If running from a local clone, copy the script; otherwise download it
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)" || SCRIPT_DIR=""
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$SCRIPT_NAME" ]; then
  cp "$SCRIPT_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
  echo "  Copied $SCRIPT_NAME to $INSTALL_DIR/"
else
  curl -sSL "$REPO_RAW/$SCRIPT_NAME" -o "$INSTALL_DIR/$SCRIPT_NAME"
  echo "  Downloaded $SCRIPT_NAME to $INSTALL_DIR/"
fi
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Ensure ~/.local/bin is in PATH
add_to_path() {
  local rc_file="$1"
  if [ -f "$rc_file" ]; then
    if ! grep -q '\.local/bin' "$rc_file" 2>/dev/null; then
      echo '' >> "$rc_file"
      echo '# Added by skills-sync installer' >> "$rc_file"
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc_file"
      echo "  Added ~/.local/bin to PATH in $(basename "$rc_file")"
      return 0
    fi
  fi
  return 1
}

path_updated=false
if [ -f "$HOME/.zshrc" ]; then
  add_to_path "$HOME/.zshrc" && path_updated=true
fi
if [ -f "$HOME/.bashrc" ]; then
  add_to_path "$HOME/.bashrc" && path_updated=true
fi
# If neither rc file exists but we're on macOS with zsh default
if [ ! -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.bashrc" ]; then
  touch "$HOME/.zshrc"
  add_to_path "$HOME/.zshrc" && path_updated=true
fi

echo ""
echo "Done! skills-sync installed to $INSTALL_DIR/$SCRIPT_NAME"

if [ "$path_updated" = true ]; then
  echo ""
  echo "PATH was updated. Run 'source ~/.zshrc' or open a new terminal."
fi

echo ""
echo "Next steps:"
echo "  skills-sync init          # First machine: create gist"
echo "  skills-sync init <id>     # Other machines: link to existing gist"
