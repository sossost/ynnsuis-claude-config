#!/bin/bash
set -euo pipefail

# ============================================================
# .claude Template Installer
# Installs the template to ~/.claude/ with backup
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ============================================================
# Pre-flight checks
# ============================================================

if [ ! -f "$SCRIPT_DIR/CLAUDE.md" ]; then
  error "CLAUDE.md not found. Run this script from the template root directory."
fi

# ============================================================
# Backup existing config
# ============================================================

if [ -d "$TARGET_DIR" ]; then
  info "Backing up existing ~/.claude/ to $BACKUP_DIR"
  cp -r "$TARGET_DIR" "$BACKUP_DIR"
  info "Backup created at $BACKUP_DIR"
else
  info "No existing ~/.claude/ found. Creating fresh install."
  mkdir -p "$TARGET_DIR"
fi

# ============================================================
# Install template files
# ============================================================

# Directories to sync
DIRS="agents commands rules skills"

for dir in $DIRS; do
  if [ -d "$SCRIPT_DIR/$dir" ]; then
    info "Installing $dir/"
    mkdir -p "$TARGET_DIR/$dir"
    cp -r "$SCRIPT_DIR/$dir/"* "$TARGET_DIR/$dir/" 2>/dev/null || true
  fi
done

# Install CLAUDE.md
info "Installing CLAUDE.md"
cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"

# Install settings.json (merge strategy: don't overwrite if exists)
if [ -f "$TARGET_DIR/settings.json" ]; then
  warn "settings.json already exists. Skipping to preserve your hooks."
  warn "Template version saved as settings.template.json for reference."
  cp "$SCRIPT_DIR/settings.json" "$TARGET_DIR/settings.template.json"
else
  info "Installing settings.json"
  cp "$SCRIPT_DIR/settings.json" "$TARGET_DIR/settings.json"
fi

# ============================================================
# Preserve local settings
# ============================================================

# settings.local.json is never overwritten
if [ -f "$BACKUP_DIR/.claude/settings.local.json" ] && [ ! -f "$TARGET_DIR/settings.local.json" ]; then
  cp "$BACKUP_DIR/.claude/settings.local.json" "$TARGET_DIR/settings.local.json"
  info "Preserved settings.local.json"
fi

# ============================================================
# Skills with subdirectories
# ============================================================

for skill_dir in "$SCRIPT_DIR/skills"/*/; do
  if [ -d "$skill_dir" ]; then
    skill_name=$(basename "$skill_dir")
    mkdir -p "$TARGET_DIR/skills/$skill_name"
    cp -r "$skill_dir"* "$TARGET_DIR/skills/$skill_name/" 2>/dev/null || true
    info "Installed skill: $skill_name"
  fi
done

# ============================================================
# Summary
# ============================================================

echo ""
info "Installation complete!"
echo ""
echo "  Installed to: $TARGET_DIR"
if [ -d "$BACKUP_DIR" ]; then
  echo "  Backup at:    $BACKUP_DIR"
fi
echo ""
echo "  Files installed:"
echo "    - CLAUDE.md"
echo "    - settings.json"

for dir in $DIRS; do
  if [ -d "$TARGET_DIR/$dir" ]; then
    count=$(find "$TARGET_DIR/$dir" -type f | wc -l | tr -d ' ')
    echo "    - $dir/ ($count files)"
  fi
done

echo ""
echo "  Next steps:"
echo "    1. Review ~/.claude/CLAUDE.md and customize"
echo "    2. Copy templates/project-claude.md into your project's .claude/"
echo "    3. Start a new Claude Code session to load the config"
echo ""

# ============================================================
# Cleanup prompt
# ============================================================

if [ -d "$BACKUP_DIR" ]; then
  echo -e "  ${YELLOW}To restore previous config:${NC}"
  echo "    rm -rf ~/.claude && mv $BACKUP_DIR ~/.claude"
  echo ""
fi
