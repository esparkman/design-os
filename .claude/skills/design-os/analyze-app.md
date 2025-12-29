---
name: analyze-app
description: Scan and analyze an existing Rails codebase to understand components, patterns, and design tokens. Use this to populate design-context/ and establish baseline understanding of a brownfield project.
---

# /analyze-app

Analyze an existing Rails application to understand its design patterns, components, and tokens. This creates the foundation for brownfield design work.

## Purpose

- Discover existing ViewComponents and their patterns
- Identify Stimulus controllers and their conventions
- Extract color palettes and typography from CSS/Tailwind
- Map layout structures and navigation patterns
- Create `design-context/` with analysis results
- Save discoveries to Pensieve memory

## Step 1: Verify Rails Application

First, confirm this is a Rails application:

```bash
# Check for Rails indicators
ls -la Gemfile config/application.rb app/
```

If not a Rails app, inform the user and exit.

## Step 2: Create Design Context Directory

Create the `design-context/` directory structure:

```
design-context/
├── manifest.json           # Analysis metadata
├── components/             # Discovered components
├── patterns/               # Identified patterns
├── tokens/                 # Extracted design tokens
└── snapshots/              # Point-in-time analysis
```

## Step 3: Scan for ViewComponents

Search for ViewComponent files:

```bash
# Find all ViewComponent files
find app/components -name "*.rb" -type f 2>/dev/null

# Find component templates
find app/components -name "*.html.erb" -type f 2>/dev/null
```

For each component found:
1. Read the component class to understand its props (initialize parameters)
2. Read the template to understand its structure
3. Look for Stimulus controller references (`data-controller`)
4. Identify Tailwind classes used

Create a component entry:

```json
{
  "name": "ButtonComponent",
  "path": "app/components/button_component.rb",
  "template": "app/components/button_component.html.erb",
  "props": ["label", "variant", "size", "disabled"],
  "stimulus_controllers": ["button"],
  "tailwind_classes": ["bg-blue-500", "hover:bg-blue-600", "px-4", "py-2"],
  "slots": ["icon"],
  "variants": ["primary", "secondary", "danger"]
}
```

## Step 4: Scan for Stimulus Controllers

Search for Stimulus controllers:

```bash
# Find all Stimulus controllers
find app/javascript/controllers -name "*_controller.js" -type f 2>/dev/null
find app/javascript/controllers -name "*_controller.ts" -type f 2>/dev/null
```

For each controller found:
1. Identify targets, values, and actions
2. Note which components reference this controller
3. Understand the controller's purpose

Create a controller entry:

```json
{
  "name": "dropdown_controller",
  "path": "app/javascript/controllers/dropdown_controller.js",
  "targets": ["menu", "button"],
  "values": ["open"],
  "actions": ["toggle", "close"],
  "used_by": ["DropdownComponent", "NavbarComponent"]
}
```

## Step 5: Extract Design Tokens

### Colors

Look for color definitions in:
- `app/assets/stylesheets/` (CSS custom properties)
- `app/frontend/` or `app/javascript/` (if using modern asset pipeline)
- Tailwind config or CSS `@theme` blocks (Tailwind v4)
- Inline Tailwind classes in components

```bash
# Search for color definitions
grep -r "color" app/assets/stylesheets/ --include="*.css" 2>/dev/null
grep -r "@theme" app/assets/stylesheets/ --include="*.css" 2>/dev/null
grep -r "tailwind" . --include="*.css" 2>/dev/null | head -20
```

Extract color palette:

```json
{
  "colors": {
    "primary": {
      "50": "#f0f9ff",
      "500": "#3b82f6",
      "900": "#1e3a8a"
    },
    "semantic": {
      "success": "#22c55e",
      "warning": "#eab308",
      "error": "#ef4444"
    }
  }
}
```

### Typography

Look for font definitions:

```bash
# Search for font definitions
grep -r "font-family\|font-size\|@font-face" app/assets/stylesheets/ --include="*.css" 2>/dev/null
```

Extract typography scale:

```json
{
  "typography": {
    "fontFamily": {
      "sans": ["Inter", "system-ui", "sans-serif"],
      "mono": ["JetBrains Mono", "monospace"]
    },
    "fontSize": {
      "xs": "0.75rem",
      "sm": "0.875rem",
      "base": "1rem",
      "lg": "1.125rem",
      "xl": "1.25rem"
    }
  }
}
```

## Step 6: Analyze Layout Structure

Find layout files:

```bash
# Find layout files
ls -la app/views/layouts/
```

For each layout:
1. Identify the shell structure (header, sidebar, main, footer)
2. Note navigation patterns
3. Find shared partials

Create layout documentation:

```json
{
  "layouts": {
    "application": {
      "path": "app/views/layouts/application.html.erb",
      "structure": {
        "header": "shared/_header",
        "sidebar": "shared/_sidebar",
        "main": "yield",
        "footer": "shared/_footer"
      },
      "navigation": {
        "type": "sidebar",
        "items": ["Dashboard", "Projects", "Settings"]
      }
    }
  }
}
```

## Step 7: Identify Patterns

Look for recurring patterns:

### Card Patterns
```bash
grep -r "card\|Card" app/components/ app/views/ --include="*.erb" --include="*.rb" 2>/dev/null | head -20
```

### List Patterns
```bash
grep -r "list\|List" app/components/ app/views/ --include="*.erb" --include="*.rb" 2>/dev/null | head -20
```

### Form Patterns
```bash
grep -r "form\|Form" app/components/ app/views/ --include="*.erb" --include="*.rb" 2>/dev/null | head -20
```

### Table Patterns
```bash
grep -r "table\|Table" app/components/ app/views/ --include="*.erb" --include="*.rb" 2>/dev/null | head -20
```

Document patterns found:

```json
{
  "patterns": {
    "card": {
      "components": ["CardComponent", "DashboardCardComponent"],
      "structure": "header + body + footer",
      "variants": ["default", "elevated", "bordered"]
    },
    "list": {
      "components": ["ListComponent", "ListItemComponent"],
      "structure": "container + items",
      "features": ["selectable", "sortable"]
    }
  }
}
```

## Step 8: Write Manifest

Create `design-context/manifest.json`:

```json
{
  "version": "1.0.0",
  "analyzed_at": "2024-01-15T10:30:00Z",
  "rails_version": "7.1.0",
  "app_name": "MyApp",
  "mode": "brownfield",
  "summary": {
    "components_count": 15,
    "controllers_count": 8,
    "layouts_count": 2,
    "patterns_identified": 4
  },
  "paths": {
    "components": "app/components",
    "controllers": "app/javascript/controllers",
    "stylesheets": "app/assets/stylesheets",
    "layouts": "app/views/layouts"
  }
}
```

## Step 9: Save to Pensieve Memory

Use `pensieve_remember` to save key discoveries:

### Save Component Discoveries
For each significant component:
```json
{
  "type": "discovery",
  "category": "component",
  "name": "[ComponentName]",
  "location": "[file_path]",
  "description": "[brief description of component purpose and props]"
}
```

### Save Pattern Discoveries
For each identified pattern:
```json
{
  "type": "discovery",
  "category": "pattern",
  "name": "[PatternName]",
  "location": "[primary_file_path]",
  "description": "[how this pattern is used in the app]"
}
```

### Save Token Discoveries
```json
{
  "type": "discovery",
  "category": "token",
  "name": "color-palette",
  "location": "[css_file_path]",
  "description": "[summary of color system]"
}
```

## Step 10: Present Summary

Output a summary for the user:

```
## Analysis Complete

### Application
- **Name:** MyApp
- **Rails Version:** 7.1.0
- **Mode:** Brownfield

### Components Found
- 15 ViewComponents discovered
- Key components: ButtonComponent, CardComponent, ModalComponent...

### Stimulus Controllers
- 8 controllers found
- Key controllers: dropdown, modal, form-validation...

### Design Tokens
- Primary color: blue-500 (#3b82f6)
- Font family: Inter
- [See design-context/tokens/ for full palette]

### Patterns Identified
- Card pattern (3 variants)
- List pattern (with selection)
- Form pattern (with validation)
- Table pattern (sortable)

### Next Steps
1. Run `/design-tokens` to refine token documentation
2. Run `/document-component [name]` to deep-dive into specific components
3. Run `/extract-patterns` to formalize reusable patterns

### Files Created
- design-context/manifest.json
- design-context/components/[component].json (per component)
- design-context/patterns/[pattern].json (per pattern)
- design-context/tokens/colors.json
- design-context/tokens/typography.json
```

## Error Handling

### No Components Found
If no ViewComponents exist:
```
No ViewComponents found in app/components/.

This app may use:
- ERB partials (app/views/shared/)
- Phlex components
- ViewComponent in a non-standard location

Would you like me to scan for ERB partials instead?
```

### No Stimulus Controllers
If no Stimulus controllers exist:
```
No Stimulus controllers found.

This app may use:
- Vanilla JavaScript
- jQuery
- Another frontend framework

The analysis will continue without controller documentation.
```

## Notes

- This skill creates the `design-context/` directory which signals brownfield mode
- Run this skill first before other design skills in a brownfield project
- Re-run after significant changes to update the analysis
- All discoveries are saved to Pensieve for cross-session continuity
