# Design OS

A bi-directional design intelligence system for Claude Code that can be installed into any brownfield Rails application.

## What Design OS Does

1. **LEARN** — Analyze existing app's designs (components, patterns, tokens)
2. **DOCUMENT** — Catalog what exists in Design OS format
3. **DESIGN** — Create new components matching existing patterns
4. **REIMAGINE** — Take existing components and propose improvements
5. **REMEMBER** — Persist knowledge across conversation boundaries

## Installation

### Quick Install

From your Rails project root:

```bash
curl -sSL https://raw.githubusercontent.com/evansparkman/design-os/main/install.sh | bash
```

### Manual Install

1. Copy `.claude/skills/` to your project
2. Create `design-context/` folder
3. Install Pensieve MCP: `claude mcp add pensieve npx @esparkman/pensieve`
4. Copy `agents.md` to your project root
5. Add Design OS reference to your `CLAUDE.md`

## Getting Started

After installation, start Claude Code in your project:

```bash
claude
```

Then run these commands:

1. `/session-start` — Initialize the memory system
2. `/analyze-app` — Understand your existing codebase
3. `/product-vision` — Start planning your product

## Available Skills

### Memory Skills

| Skill | Purpose |
|-------|---------|
| `/remember` | Save discoveries, decisions, or preferences |
| `/recall` | Query the knowledge base |
| `/session-start` | Load context at conversation start |
| `/session-end` | Persist learnings before ending |

### Brownfield Analysis Skills

| Skill | Purpose |
|-------|---------|
| `/analyze-app` | Scan codebase, populate design-context/ |
| `/document-component` | Create detailed component documentation |
| `/extract-patterns` | Identify reusable patterns |
| `/reimagine-component` | Propose improvements with migration path |

### Design Skills

| Skill | Purpose |
|-------|---------|
| `/product-vision` | Define product overview |
| `/product-roadmap` | Plan sections |
| `/design-tokens` | Define/extract colors and typography |
| `/design-shell` | Design/document application shell |
| `/shape-section` | Define section specification |
| `/sample-data` | Create sample data and Ruby types |
| `/design-screen` | Create ViewComponent screen designs |
| `/screenshot-design` | Capture design screenshots |
| `/export-product` | Generate handoff package |

## Project Structure

After installation, your project will have:

```
your-rails-app/
├── .claude/
│   └── skills/
│       ├── design-os/          # Core design skills
│       └── memory/             # Memory system skills
│
├── design-context/             # Knowledge about THIS project
│   ├── manifest.json           # Analysis metadata
│   ├── components/             # Discovered components
│   ├── patterns/               # Identified patterns
│   └── tokens/                 # Extracted design tokens
│
├── product/                    # Design intent
│   ├── product-overview.md
│   ├── product-roadmap.md
│   ├── design-system/
│   ├── shell/
│   └── sections/
│
├── agents.md                   # Design OS directives
└── CLAUDE.md                   # Entry point
```

## Memory System

Design OS uses [Pensieve](https://www.npmjs.com/package/@esparkman/pensieve), an MCP server for persistent memory across conversation boundaries. This means:

- **No more re-explaining** — Decisions and preferences are remembered
- **Continuous learning** — Discoveries compound over time
- **Session continuity** — Pick up exactly where you left off
- **Auto-loading** — Context loads automatically when you start a conversation

### Setup

```bash
claude mcp add pensieve npx @esparkman/pensieve
```

### Usage

```
/remember decision: We use Devise for authentication with magic links
/remember preference: Always use system tests over request specs
/recall authentication
/recall preferences:testing
```

## Brownfield vs Greenfield

Design OS automatically detects which mode to use:

- **Brownfield**: When `design-context/manifest.json` exists, skills adapt to match existing patterns
- **Greenfield**: When starting fresh, skills create from scratch

## Requirements

- Claude Code CLI
- Ruby on Rails project (recommended)
- Pensieve MCP server (`@esparkman/pensieve`) for persistent memory
- ViewComponent gem (for screen designs)

## License

MIT
