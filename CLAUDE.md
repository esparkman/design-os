# Design OS

Refer to @agents.md

## Strict Rules

**NEVER include these in commit messages:**
- `🤖 Generated with [Claude Code](https://claude.com/claude-code)`
- `Co-Authored-By: Claude` or any Claude attribution
- Any auto-generated footers or signatures

Commit messages should be clean, human-readable, and focus only on describing the changes.

## Session Initialization

At the start of every conversation, automatically run `/session-start` to load context from the persistent memory system. This ensures continuity across conversation boundaries.

## Quick Start

If this is a fresh installation in a brownfield Rails project:

1. Run `/session-start` to initialize memory
2. Run `/analyze-app` to understand your existing codebase
3. Run `/product-vision` to start planning

## Available Skills

### Memory Skills
- `/remember` — Save discoveries, decisions, or preferences
- `/recall` — Query the knowledge base
- `/session-start` — Load context (runs automatically)
- `/session-end` — Persist learnings before ending

### Design Skills
- `/product-vision` — Define product overview
- `/product-roadmap` — Plan sections
- `/design-tokens` — Define/extract color and typography
- `/design-shell` — Design/document application shell
- `/shape-section` — Define section specification
- `/sample-data` — Create sample data and types
- `/design-screen` — Create ViewComponent screen designs
- `/screenshot-design` — Capture design screenshots
- `/export-product` — Generate handoff package

### Brownfield Analysis Skills
- `/analyze-app` — Understand existing codebase
- `/document-component` — Catalog existing components
- `/extract-patterns` — Identify reusable patterns
- `/reimagine-component` — Propose improvements
