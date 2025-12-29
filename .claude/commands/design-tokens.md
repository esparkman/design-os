---
description: Define or extract color palettes and typography tokens. Use to establish or document the design system's foundational tokens.
---

# /design-tokens

Define or extract the foundational design tokens for a project. Works in both brownfield (extract from existing) and greenfield (define new) modes.

## Purpose

- Extract color palettes from existing CSS/Tailwind
- Define or document typography scale
- Establish spacing, border radius, and shadow tokens
- Create `design-context/tokens/` documentation
- Save token decisions to Pensieve memory

## Mode Detection

Check for brownfield vs greenfield:

```bash
# Brownfield if manifest exists
ls design-context/manifest.json 2>/dev/null
```

- **Brownfield:** Extract tokens from existing codebase, propose consolidation
- **Greenfield:** Define new tokens based on user requirements

---

## Brownfield Mode: Extract Tokens

### Step 1: Find Token Sources

Search for where tokens are defined:

```bash
# Tailwind v4 theme (CSS-based)
grep -r "@theme" app/assets/stylesheets/ --include="*.css" 2>/dev/null
grep -r "@import.*tailwindcss" app/assets/stylesheets/ --include="*.css" 2>/dev/null

# CSS custom properties
grep -r "--.*:" app/assets/stylesheets/ --include="*.css" 2>/dev/null

# Tailwind v3 config (if exists)
ls tailwind.config.js tailwind.config.ts 2>/dev/null
```

### Step 2: Extract Colors

#### From Tailwind v4 CSS

Look for `@theme` blocks:

```css
@theme {
  --color-primary-50: #eff6ff;
  --color-primary-500: #3b82f6;
  --color-primary-900: #1e3a8a;
}
```

#### From CSS Custom Properties

```css
:root {
  --primary: #3b82f6;
  --secondary: #6b7280;
  --success: #22c55e;
}
```

#### From Inline Tailwind Classes

Scan components for commonly used color classes:

```bash
# Find color classes in components
grep -rhoE "(bg|text|border|ring)-(slate|gray|zinc|neutral|stone|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-[0-9]+" app/components/ app/views/ 2>/dev/null | sort | uniq -c | sort -rn | head -30
```

Build a color frequency map to identify the primary palette.

### Step 3: Extract Typography

```bash
# Find font definitions
grep -r "font-family\|--font" app/assets/stylesheets/ --include="*.css" 2>/dev/null

# Find font imports
grep -r "@font-face\|fonts.googleapis\|fonts.bunny" app/ --include="*.css" --include="*.html.erb" 2>/dev/null
```

Identify:
- Primary font family (headings)
- Body font family
- Monospace font (code)
- Font size scale in use

### Step 4: Extract Spacing & Sizing

```bash
# Find spacing patterns
grep -rhoE "(p|m|gap|space)-(x|y)?-?[0-9]+" app/components/ app/views/ 2>/dev/null | sort | uniq -c | sort -rn | head -20

# Find border radius patterns
grep -rhoE "rounded(-[a-z]+)?" app/components/ app/views/ 2>/dev/null | sort | uniq -c | sort -rn
```

### Step 5: Document Extracted Tokens

Create `design-context/tokens/colors.json`:

```json
{
  "extracted_at": "2024-01-15T10:30:00Z",
  "source": "brownfield-extraction",
  "colors": {
    "primary": {
      "name": "Blue",
      "tailwind": "blue",
      "values": {
        "50": "#eff6ff",
        "100": "#dbeafe",
        "200": "#bfdbfe",
        "300": "#93c5fd",
        "400": "#60a5fa",
        "500": "#3b82f6",
        "600": "#2563eb",
        "700": "#1d4ed8",
        "800": "#1e40af",
        "900": "#1e3a8a",
        "950": "#172554"
      },
      "usage": {
        "primary_action": "500",
        "primary_hover": "600",
        "primary_text": "700",
        "primary_bg": "50"
      }
    },
    "neutral": {
      "name": "Stone",
      "tailwind": "stone",
      "values": {
        "50": "#fafaf9",
        "500": "#78716c",
        "900": "#1c1917"
      },
      "usage": {
        "text": "900",
        "text_muted": "500",
        "background": "50",
        "border": "200"
      }
    },
    "semantic": {
      "success": { "value": "#22c55e", "tailwind": "green-500" },
      "warning": { "value": "#eab308", "tailwind": "yellow-500" },
      "error": { "value": "#ef4444", "tailwind": "red-500" },
      "info": { "value": "#3b82f6", "tailwind": "blue-500" }
    }
  },
  "dark_mode": {
    "detected": true,
    "strategy": "class-based",
    "mappings": {
      "background": { "light": "stone-50", "dark": "stone-900" },
      "text": { "light": "stone-900", "dark": "stone-50" }
    }
  }
}
```

Create `design-context/tokens/typography.json`:

```json
{
  "extracted_at": "2024-01-15T10:30:00Z",
  "source": "brownfield-extraction",
  "typography": {
    "fontFamily": {
      "sans": {
        "value": ["Inter", "system-ui", "sans-serif"],
        "css": "font-sans",
        "source": "Google Fonts"
      },
      "mono": {
        "value": ["JetBrains Mono", "monospace"],
        "css": "font-mono",
        "source": "Google Fonts"
      }
    },
    "fontSize": {
      "xs": { "size": "0.75rem", "lineHeight": "1rem" },
      "sm": { "size": "0.875rem", "lineHeight": "1.25rem" },
      "base": { "size": "1rem", "lineHeight": "1.5rem" },
      "lg": { "size": "1.125rem", "lineHeight": "1.75rem" },
      "xl": { "size": "1.25rem", "lineHeight": "1.75rem" },
      "2xl": { "size": "1.5rem", "lineHeight": "2rem" },
      "3xl": { "size": "1.875rem", "lineHeight": "2.25rem" },
      "4xl": { "size": "2.25rem", "lineHeight": "2.5rem" }
    },
    "fontWeight": {
      "normal": "400",
      "medium": "500",
      "semibold": "600",
      "bold": "700"
    }
  }
}
```

Create `design-context/tokens/spacing.json`:

```json
{
  "extracted_at": "2024-01-15T10:30:00Z",
  "spacing": {
    "scale": "tailwind-default",
    "common": ["1", "2", "3", "4", "6", "8", "12", "16"],
    "usage": {
      "component_padding": "4",
      "section_gap": "8",
      "page_margin": "6"
    }
  },
  "borderRadius": {
    "none": "0",
    "sm": "0.125rem",
    "default": "0.25rem",
    "md": "0.375rem",
    "lg": "0.5rem",
    "xl": "0.75rem",
    "2xl": "1rem",
    "full": "9999px",
    "common": ["md", "lg"]
  },
  "shadow": {
    "sm": "0 1px 2px 0 rgb(0 0 0 / 0.05)",
    "default": "0 1px 3px 0 rgb(0 0 0 / 0.1)",
    "md": "0 4px 6px -1px rgb(0 0 0 / 0.1)",
    "lg": "0 10px 15px -3px rgb(0 0 0 / 0.1)",
    "common": ["sm", "md"]
  }
}
```

### Step 6: Propose Consolidation

If inconsistencies are found, propose consolidation:

```
## Token Consolidation Recommendations

### Colors
Currently using 3 different blue shades for primary actions:
- `blue-500` (45 occurrences)
- `blue-600` (12 occurrences)
- `indigo-500` (8 occurrences)

**Recommendation:** Standardize on `blue-500` for primary, `blue-600` for hover.

### Typography
Found 4 different heading patterns:
- `text-2xl font-bold` (Dashboard)
- `text-xl font-semibold` (Cards)
- `text-lg font-medium` (Modals)
- `text-2xl font-semibold` (Settings)

**Recommendation:** Create heading hierarchy:
- H1: `text-2xl font-semibold`
- H2: `text-xl font-semibold`
- H3: `text-lg font-medium`

Would you like me to create a consolidated token file?
```

---

## Greenfield Mode: Define Tokens

### Step 1: Gather Requirements

Ask the user about their design preferences:

```
## Design Token Setup

I'll help you define your design tokens. Please answer these questions:

### Brand Colors
1. What's your primary brand color? (hex code or description like "vibrant blue")
2. Do you have a secondary accent color?
3. What neutral palette do you prefer? (warm grays, cool grays, slate, stone)

### Typography
4. What font do you want for headings? (Inter, Plus Jakarta Sans, etc.)
5. What font for body text? (same as headings, or different)
6. Do you need a monospace font for code?

### Style
7. What's the overall feel? (minimal, playful, corporate, bold)
8. Border radius preference? (sharp, slightly rounded, very rounded)
9. Will you support dark mode?
```

### Step 2: Generate Token Files

Based on user input, create token files.

#### Example: Modern SaaS Tokens

`design-context/tokens/colors.json`:

```json
{
  "created_at": "2024-01-15T10:30:00Z",
  "source": "greenfield-definition",
  "colors": {
    "primary": {
      "name": "Indigo",
      "tailwind": "indigo",
      "values": {
        "50": "#eef2ff",
        "100": "#e0e7ff",
        "200": "#c7d2fe",
        "300": "#a5b4fc",
        "400": "#818cf8",
        "500": "#6366f1",
        "600": "#4f46e5",
        "700": "#4338ca",
        "800": "#3730a3",
        "900": "#312e81",
        "950": "#1e1b4b"
      }
    },
    "accent": {
      "name": "Emerald",
      "tailwind": "emerald",
      "values": {
        "500": "#10b981",
        "600": "#059669"
      }
    },
    "neutral": {
      "name": "Slate",
      "tailwind": "slate"
    },
    "semantic": {
      "success": "#22c55e",
      "warning": "#f59e0b",
      "error": "#ef4444",
      "info": "#3b82f6"
    }
  }
}
```

### Step 3: Generate Tailwind v4 CSS

Create recommended CSS for Tailwind v4:

```css
/* app/assets/stylesheets/tokens.css */

@import "tailwindcss";

@theme {
  /* Primary - Indigo */
  --color-primary-50: #eef2ff;
  --color-primary-100: #e0e7ff;
  --color-primary-500: #6366f1;
  --color-primary-600: #4f46e5;
  --color-primary-700: #4338ca;

  /* Accent - Emerald */
  --color-accent-500: #10b981;
  --color-accent-600: #059669;

  /* Semantic */
  --color-success: #22c55e;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
  --color-info: #3b82f6;

  /* Typography */
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", monospace;
}
```

---

## Step 7: Save to Pensieve

Save token decisions:

```json
{
  "type": "decision",
  "topic": "Design Tokens - Colors",
  "content": "Primary color is indigo (indigo-500: #6366f1), neutral is slate, accent is emerald",
  "rationale": "Indigo conveys trust and professionalism for SaaS, emerald accent for CTAs"
}
```

```json
{
  "type": "decision",
  "topic": "Design Tokens - Typography",
  "content": "Using Inter for all text, JetBrains Mono for code",
  "rationale": "Inter is highly readable and professional, works well at all sizes"
}
```

---

## Output Summary

```
## Design Tokens Defined

### Colors
| Role | Color | Tailwind | Hex |
|------|-------|----------|-----|
| Primary | Indigo | indigo-500 | #6366f1 |
| Primary Hover | Indigo | indigo-600 | #4f46e5 |
| Accent | Emerald | emerald-500 | #10b981 |
| Neutral | Slate | slate-* | — |
| Success | Green | green-500 | #22c55e |
| Warning | Amber | amber-500 | #f59e0b |
| Error | Red | red-500 | #ef4444 |

### Typography
| Role | Font | Weight | Size |
|------|------|--------|------|
| Headings | Inter | 600 | varies |
| Body | Inter | 400 | base |
| Code | JetBrains Mono | 400 | sm |

### Spacing
- Component padding: `p-4` (16px)
- Section gap: `gap-6` (24px)
- Border radius: `rounded-lg`

### Files Created
- `design-context/tokens/colors.json`
- `design-context/tokens/typography.json`
- `design-context/tokens/spacing.json`

### Next Steps
1. Run `/design-shell` to design the application shell
2. Run `/design-screen [section]` to create screens using these tokens
```

## Notes

- Always use Tailwind's built-in color palette when possible
- For Tailwind v4, define custom tokens in CSS `@theme` blocks
- Dark mode support should be class-based (`dark:` variants)
- Save all decisions to Pensieve for cross-session continuity
