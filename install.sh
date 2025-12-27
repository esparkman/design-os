#!/bin/bash
# Design OS Installer
# Installs Design OS into any Rails project for brownfield design intelligence.

set -e

DESIGN_OS_VERSION="${DESIGN_OS_VERSION:-main}"
REPO_URL="${DESIGN_OS_REPO:-https://github.com/evansparkman/design-os}"

echo "========================================"
echo "  Design OS Installer"
echo "========================================"
echo ""

# Check if we're in a reasonable project directory
if [ ! -f "Gemfile" ] && [ ! -f "package.json" ] && [ ! -d ".git" ]; then
  echo "Warning: This doesn't look like a project directory."
  echo "Are you sure you want to install Design OS here? (y/N)"
  read -r response
  if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

echo "Installing Design OS..."
echo ""

# Create .claude/skills if it doesn't exist
mkdir -p .claude/skills

# Clone or download skills
if command -v git &> /dev/null; then
  echo "→ Cloning Design OS..."
  git clone --depth 1 --branch "$DESIGN_OS_VERSION" "$REPO_URL" /tmp/design-os-install 2>/dev/null || {
    echo "  Falling back to default branch..."
    git clone --depth 1 "$REPO_URL" /tmp/design-os-install
  }
  cp -r /tmp/design-os-install/.claude/skills/* .claude/skills/
  SCHEMA_PATH="/tmp/design-os-install/templates/design-context/schema.sql"
  AGENTS_PATH="/tmp/design-os-install/agents.md"
else
  echo "→ Downloading Design OS..."
  curl -sSL "$REPO_URL/archive/$DESIGN_OS_VERSION.zip" -o /tmp/design-os.zip
  unzip -q /tmp/design-os.zip -d /tmp/
  cp -r /tmp/design-os-*/.claude/skills/* .claude/skills/
  SCHEMA_PATH="/tmp/design-os-*/templates/design-context/schema.sql"
  AGENTS_PATH="/tmp/design-os-*/agents.md"
fi

echo "→ Creating design-context folder..."
mkdir -p design-context/components design-context/patterns design-context/tokens design-context/snapshots

# Initialize SQLite database with schema
if [ -f "$SCHEMA_PATH" ]; then
  echo "→ Initializing memory database..."
  sqlite3 design-context/memory.sqlite < "$SCHEMA_PATH"
else
  echo "  Warning: Could not find schema.sql, skipping database initialization"
fi

# Create product folder
echo "→ Creating product folder..."
mkdir -p product/sections product/design-system product/shell

# Handle CLAUDE.md
if [ -f "CLAUDE.md" ]; then
  echo "→ Appending Design OS to existing CLAUDE.md..."
  if ! grep -q "Design OS" CLAUDE.md; then
    echo -e "\n\n# Design OS\n\nRefer to @agents.md\n\n## Session Initialization\n\nAt the start of every conversation, automatically run \`/session-start\` to load context from the persistent memory system." >> CLAUDE.md
  fi
else
  echo "→ Creating CLAUDE.md..."
  cat > CLAUDE.md << 'EOF'
# Design OS

Refer to @agents.md

## Session Initialization

At the start of every conversation, automatically run `/session-start` to load context from the persistent memory system.
EOF
fi

# Copy agents.md if not present
if [ ! -f "agents.md" ]; then
  if [ -f "$AGENTS_PATH" ]; then
    echo "→ Copying agents.md..."
    cp "$AGENTS_PATH" ./agents.md
  fi
else
  echo "→ agents.md already exists, skipping"
fi

# Add to .gitignore if needed
if [ -f ".gitignore" ]; then
  if ! grep -q "design-context/memory.sqlite" .gitignore; then
    echo "→ Adding memory.sqlite to .gitignore..."
    echo -e "\n# Design OS (optional - remove if you want to share memory)\n# design-context/memory.sqlite" >> .gitignore
  fi
fi

# Cleanup
rm -rf /tmp/design-os-install /tmp/design-os.zip /tmp/design-os-*

echo ""
echo "========================================"
echo "  Design OS installed successfully!"
echo "========================================"
echo ""
echo "Files created:"
echo "  .claude/skills/design-os/  - Core design skills"
echo "  .claude/skills/memory/     - Memory system skills"
echo "  design-context/            - Project knowledge base"
echo "  product/                   - Design intent"
echo ""
echo "Next steps:"
echo "  1. Start Claude Code in this directory"
echo "  2. Run /session-start to initialize memory"
echo "  3. Run /analyze-app to understand your codebase"
echo "  4. Run /product-vision to start planning"
echo ""
