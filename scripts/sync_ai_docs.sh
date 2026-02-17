#!/usr/bin/env bash
# Sync master.md and rules.md to all AI agent instruction files.
# Runs as a pre-commit hook; automatically stages the copied files.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

MASTER="master.md"
RULES="rules.md"

# Destinations for master.md
MASTER_TARGETS=(
    "AGENTS.md"
    "GEMINI.md"
    ".claude/claude.md"
    ".codex/agents.md"
    ".gemini/gemini.md"
    ".github/copilot-instructions.md"
)

# Destinations for rules.md
RULES_TARGETS=(
    ".claude/rules/rules.md"
    ".codex/rules/rules.md"
    ".gemini/rules/rules.md"
)

changed=0

sync_file() {
    local src="$1"
    local dst="$2"
    if ! cmp -s "$src" "$dst" 2>/dev/null; then
        cp "$src" "$dst"
        git add "$dst"
        echo "synced: $src -> $dst"
        changed=1
    fi
}

for dst in "${MASTER_TARGETS[@]}"; do
    sync_file "$MASTER" "$dst"
done

for dst in "${RULES_TARGETS[@]}"; do
    sync_file "$RULES" "$dst"
done

if [ "$changed" -eq 0 ]; then
    echo "sync_ai_docs: already up to date"
fi
