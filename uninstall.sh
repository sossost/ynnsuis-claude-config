#!/bin/bash
set -euo pipefail

# ============================================================
# .claude Template Uninstaller
# Restores from the most recent backup
# ============================================================

TARGET_DIR="$HOME/.claude"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Find the most recent backup
LATEST_BACKUP=$(ls -dt "$HOME"/.claude-backup-* 2>/dev/null | head -1)

if [ -z "$LATEST_BACKUP" ]; then
  error "No backup found. Cannot restore."
fi

echo ""
echo "  Found backup: $LATEST_BACKUP"
echo "  This will replace ~/.claude/ with the backup."
echo ""
read -p "  Proceed? (y/N) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  info "Cancelled."
  exit 0
fi

# Restore
rm -rf "$TARGET_DIR"
mv "$LATEST_BACKUP" "$TARGET_DIR"

info "Restored ~/.claude/ from $LATEST_BACKUP"
echo ""
echo "  Remaining backups:"
ls -d "$HOME"/.claude-backup-* 2>/dev/null || echo "    (none)"
echo ""
