#!/usr/bin/env bash
set -euo pipefail

# copilot-configs installer
# https://github.com/woliveiras/copilot-configs
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/woliveiras/copilot-configs/main/install.sh | bash
#   ~/.copilot-configs/install.sh --project
#   ~/.copilot-configs/install.sh --project --force

REPO_URL="https://github.com/woliveiras/copilot-configs.git"
INSTALL_DIR="$HOME/.copilot-configs"
FORCE=false
PROJECT=false

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[ok]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }
error() { printf "\033[1;31m[error]\033[0m %s\n" "$1" >&2; }

detect_vscode_dir() {
  case "$(uname -s)" in
    Darwin)
      echo "$HOME/Library/Application Support/Code/User"
      ;;
    Linux)
      echo "$HOME/.config/Code/User"
      ;;
    *)
      error "Unsupported OS: $(uname -s)"
      exit 1
      ;;
  esac
}

# Copy a file, respecting --force flag
# Usage: safe_copy <src> <dest>
safe_copy() {
  local src="$1" dest="$2"
  if [[ -f "$dest" ]] && [[ "$FORCE" == "false" ]]; then
    warn "Skipped (already exists): $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  ok "Copied: $dest"
}

# Copy a directory tree, respecting --force flag
# Usage: safe_copy_tree <src_dir> <dest_dir>
safe_copy_tree() {
  local src_dir="$1" dest_dir="$2"
  find "$src_dir" -type f | while read -r src_file; do
    local rel_path="${src_file#"$src_dir"/}"
    safe_copy "$src_file" "$dest_dir/$rel_path"
  done
}

# ---------------------------------------------------------------------------
# Parse args
# ---------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT=true; shift ;;
    --force)   FORCE=true; shift ;;
    --help|-h)
      cat <<EOF
copilot-configs installer

Usage:
  install.sh              Install/update global Copilot configs
  install.sh --project    Apply project template to current directory
  install.sh --force      Overwrite existing files

Options:
  --project   Copy .github/ template into the current working directory
  --force     Overwrite files that already exist (default: skip)
  --help      Show this help message

Examples:
  # Install global configs
  curl -fsSL https://raw.githubusercontent.com/woliveiras/copilot-configs/main/install.sh | bash

  # Apply project template
  ~/.copilot-configs/install.sh --project

  # Apply project template, overwriting existing files
  ~/.copilot-configs/install.sh --project --force
EOF
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      exit 1
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Project mode: copy template into current directory
# ---------------------------------------------------------------------------

if [[ "$PROJECT" == "true" ]]; then
  if [[ ! -d "$INSTALL_DIR" ]]; then
    error "copilot-configs not installed. Run the installer first:"
    error "  curl -fsSL https://raw.githubusercontent.com/woliveiras/copilot-configs/main/install.sh | bash"
    exit 1
  fi

  info "Applying project template to $(pwd)..."

  # Copy .github/ template
  safe_copy_tree "$INSTALL_DIR/project/.github" "./.github"

  # Copy mise.toml template (only if it doesn't exist, regardless of --force)
  if [[ ! -f "./mise.toml" ]]; then
    cp "$INSTALL_DIR/project/mise.toml" "./mise.toml"
    ok "Copied: ./mise.toml"
  else
    warn "Skipped (already exists): ./mise.toml"
  fi

  echo ""
  ok "Project template applied!"
  info "Next steps:"
  info "  1. Edit .github/copilot-instructions.md with your project details"
  info "  2. Remove instruction files for languages you don't use"
  info "  3. Uncomment tools in mise.toml for your stack"
  info "  4. Edit .github/hooks/guardrails-rules.txt to customize guardrails"
  exit 0
fi

# ---------------------------------------------------------------------------
# Global install mode
# ---------------------------------------------------------------------------

info "Installing copilot-configs..."

# Clone or update
if [[ -d "$INSTALL_DIR/.git" ]]; then
  info "Updating existing installation..."
  git -C "$INSTALL_DIR" pull --ff-only --quiet 2>/dev/null || {
    warn "Could not fast-forward. Re-cloning..."
    rm -rf "$INSTALL_DIR"
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
  }
  ok "Updated: $INSTALL_DIR"
else
  if [[ -d "$INSTALL_DIR" ]]; then
    warn "Removing non-git directory at $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"
  fi
  git clone --quiet "$REPO_URL" "$INSTALL_DIR"
  ok "Cloned: $INSTALL_DIR"
fi

# Detect VS Code user directory
VSCODE_USER_DIR="$(detect_vscode_dir)"

if [[ ! -d "$VSCODE_USER_DIR" ]]; then
  warn "VS Code user directory not found: $VSCODE_USER_DIR"
  warn "Skipping global prompt installation. Install VS Code first."
else
  # Install global prompts
  info "Installing global prompts..."
  PROMPTS_DIR="$VSCODE_USER_DIR/prompts"
  mkdir -p "$PROMPTS_DIR"

  if [[ -d "$INSTALL_DIR/user/prompts" ]]; then
    for f in "$INSTALL_DIR/user/prompts"/*.prompt.md; do
      [[ -f "$f" ]] || continue
      safe_copy "$f" "$PROMPTS_DIR/$(basename "$f")"
    done
  fi
fi

# Check for mise
if ! command -v mise &> /dev/null; then
  echo ""
  info "mise (tool version manager) is not installed."
  info "mise manages Go, Node, pnpm, Python, uv, and other tools."
  info "Install it with: curl https://mise.run | sh"
  info "Learn more: https://mise.jdx.dev"
fi

echo ""
ok "copilot-configs installed!"
info "Global prompts are available in VS Code (type / in Copilot chat)."
info ""
info "To apply project template to a repository:"
info "  cd your-project && ~/.copilot-configs/install.sh --project"
