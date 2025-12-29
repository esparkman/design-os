# Agent Directives for Design OS

Design OS is a **bi-directional design intelligence system** that can be installed into any brownfield Rails application. It helps you understand existing patterns, design new components that match, and maintain knowledge across conversation boundaries.

> **Attribution:** Design OS is based on the original [Design OS](https://buildermethods.com) concepts by **Brian Casel** from BuilderMethods. This fork focuses on brownfield Rails applications and ViewComponent workflows.

---

## The Five Pillars

1. **LEARN** — Analyze existing app's designs (components, patterns, tokens)
2. **DOCUMENT** — Catalog what exists in Design OS format
3. **DESIGN** — Create new components matching existing patterns
4. **REIMAGINE** — Take existing components and propose improvements
5. **REMEMBER** — Persist knowledge across conversation boundaries

---

## Brownfield vs Greenfield Mode

Design OS automatically detects which mode to use:

- **Brownfield**: `design-context/manifest.json` exists → work with existing codebase
- **Greenfield**: No manifest → creating from scratch

Skills adapt their behavior based on mode.

---

## Memory System

Design OS uses [Pensieve](https://www.npmjs.com/package/@esparkman/pensieve), an MCP server for persistent memory.

### Setup

```bash
claude mcp add pensieve npx @esparkman/pensieve
```

### Automatic Session Management

At the start of every conversation:
1. Pensieve auto-loads context when the MCP server starts
2. Run `/session-start` to display loaded context and start session tracking
3. Continue with full context of prior decisions

Before ending a session:
1. Run `/session-end` to persist learnings
2. Summarize accomplishments and remaining work
3. Record any new decisions or discoveries

### Memory Types

| Type | Purpose |
|------|---------|
| `discovery` | Components, patterns, entities found in codebase |
| `decision` | Architectural and design choices with rationale |
| `preference` | User preferences for coding style, testing, etc. |
| `entity` | Domain model understanding |

### Pensieve MCP Tools

| Tool | Purpose |
|------|---------|
| `pensieve_remember` | Save decisions, preferences, discoveries, entities |
| `pensieve_recall` | Query stored knowledge |
| `pensieve_session_start` | Start session tracking |
| `pensieve_session_end` | End session with summary |
| `pensieve_get_context` | Get full context dump |
| `pensieve_resolve_question` | Resolve open questions |

---

## File Structure

### Design OS (The Tool)

**Slash Commands** (user-invoked with `/command`):
```
.claude/commands/
├── analyze-app.md        # /analyze-app - Scan Rails codebase
├── design-screen.md      # /design-screen - Create ViewComponent screens
├── design-shell.md       # /design-shell - Design application shell
├── design-tokens.md      # /design-tokens - Define/extract tokens
├── document-component.md # /document-component - Document existing components
├── export-product.md     # /export-product - Generate handoff package
├── extract-patterns.md   # /extract-patterns - Identify reusable patterns
├── product-roadmap.md    # /product-roadmap - Plan sections
├── product-vision.md     # /product-vision - Define product overview
├── recall.md             # /recall - Query knowledge base
├── reimagine-component.md # /reimagine-component - Propose improvements
├── remember.md           # /remember - Save to memory
├── sample-data.md        # /sample-data - Create test data
├── screenshot-design.md  # /screenshot-design - Capture screenshots
├── session-end.md        # /session-end - End session with summary
├── session-start.md      # /session-start - Start session, load context
└── shape-section.md      # /shape-section - Define section spec
```


### Project-Specific (Created Per Project)

```
design-context/             # Understanding of THIS codebase
├── manifest.json           # Analysis metadata
├── components/             # Discovered components
├── patterns/               # Identified patterns
├── tokens/                 # Extracted design tokens
└── snapshots/              # Point-in-time analysis

product/                    # Design intent for THIS project
├── product-overview.md
├── product-roadmap.md
├── design-system/
├── shell/
├── sections/
└── reimagined/             # Improvement proposals
```

---

## Workflows

### Solo Developer (Brownfield)

```
1. /session-start           → Load prior context
2. /analyze-app             → Understand existing codebase
3. Review design-context/   → Validate understanding
4. /shape-section           → Plan new section
5. /design-screen           → Create matching patterns
6. Review in Lookbook       → Validate design
7. /session-end             → Persist learnings
```

### Team Handoff

```
1. Designer: /analyze-app         → Capture current state
2. Designer: /design-tokens       → Extract and propose consolidation
3. Designer: /reimagine-component → Propose improvements
4. Team: Review proposals         → In product/reimagined/
5. Designer: /design-screen       → New screens matching proposals
6. /export-product                → Incremental handoff package
7. Developer: Implement           → Using integration instructions
```

### New Feature (Brownfield)

```
1. /session-start           → Load context
2. /recall patterns         → Review existing patterns
3. /shape-section           → Define new section
4. /sample-data             → Create test data
5. /design-screen           → Create ViewComponents
6. /remember decision: ...  → Record key decisions
7. /session-end             → Save progress
```

---

## Skill Reference

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

---

## Design Requirements

### ViewComponents Must Be Props-Based

All ViewComponents accept data via initialize parameters. Never query the database directly in components.

```ruby
# Good: Data passed via initialize
class InvoiceListComponent < ViewComponent::Base
  def initialize(invoices:, on_view: nil)
    @invoices = invoices
    @on_view = on_view
  end
end

# Bad: Querying database in component
class InvoiceListComponent < ViewComponent::Base
  def initialize
    @invoices = Invoice.all  # Don't do this!
  end
end
```

### Match Existing Patterns

In brownfield mode, generated components should match the existing codebase's:
- Color palette and design tokens
- Component structure and naming
- Stimulus controller patterns
- Layout and spacing conventions

### Responsive + Dark Mode

All designs must:
- Use Tailwind responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`)
- Include `dark:` variants for all colors
- Work on mobile, tablet, and desktop

---

## Tailwind CSS Directives

- **Tailwind CSS v4**: Always use v4 patterns (not v3)
- **No tailwind.config.js**: v4 doesn't use config files
- **Built-in Utilities**: Prefer built-in classes over custom CSS
- **Built-in Colors**: Use Tailwind's color palette (stone, lime, etc.)

---

## Rails Integration

Design OS integrates with specialized Rails agents:

| Agent | Role |
|-------|------|
| `@rails-viewcomponent-engineer` | ViewComponent design, slots, variants |
| `@rails-hotwire-engineer` | Turbo Frames, Turbo Streams, Stimulus |
| `@rails-model-engineer` | Models, migrations, ActiveRecord |
| `@rails-controller-engineer` | Controllers, routing, APIs |
| `@rails-testing-expert` | Component tests, system tests |
| `@rails-architect` | System design, architecture |

---

## Key Principles

1. **Memory-aware** — Every skill queries and updates the knowledge base
2. **Pattern-matching** — New designs match existing codebase patterns
3. **Props-based** — All ViewComponents are portable and testable
4. **Dual-mode** — Skills work for both brownfield and greenfield
5. **Portable** — Design OS installs cleanly into any Rails project
6. **Continuity** — Knowledge persists across conversation boundaries
