#!/usr/bin/env bash
set -euo pipefail

# copilot-configs uninstaller
# Removes global configs installed by install.sh
# Does NOT remove project-level configs (.github/ in your repos)

INSTALL_DIR="$HOME/.copilot-configs"

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[ok]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }

detect_vscode_dir() {
  case "$(uname -s)" in
    Darwin) echo "$HOME/Library/Application Support/Code/User" ;;
    Linux)  echo "$HOME/.config/Code/User" ;;
    *)      echo "" ;;
  esac
}

info "Uninstalling copilot-configs..."

# Remove global prompts
VSCODE_USER_DIR="$(detect_vscode_dir)"
if [[ -n "$VSCODE_USER_DIR" ]] && [[ -d "$VSCODE_USER_DIR/prompts" ]]; then
  if [[ -d "$INSTALL_DIR/user/prompts" ]]; then
    for f in "$INSTALL_DIR/user/prompts"/*.prompt.md; do
      [[ -f "$f" ]] || continue
      local_file="$VSCODE_USER_DIR/prompts/$(basename "$f")"
      if [[ -f "$local_file" ]]; then
        rm "$local_file"
        ok "Removed: $local_file"
      fi
    done
  fi
fi

# Remove installation directory
if [[ -d "$INSTALL_DIR" ]]; then
  rm -rf "$INSTALL_DIR"
  ok "Removed: $INSTALL_DIR"
else
  warn "Installation directory not found: $INSTALL_DIR"
fi

echo ""
ok "copilot-configs uninstalled."
info "Project-level configs (.github/) were NOT removed."
info "Remove them manually if needed: rm -rf .github/agents .github/skills .github/hooks .github/instructions"
