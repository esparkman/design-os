# /session-start

Load context from the persistent memory system at the start of a conversation. This skill should run automatically at the beginning of every session.

## Purpose

Restore context from previous sessions so you can:
- Continue work in progress
- Remember prior decisions
- Apply learned preferences
- Avoid re-asking resolved questions

## Step 1: Check Memory Database

First, verify the memory database exists:

```bash
if [ -f "design-context/memory.sqlite" ]; then
  echo "Memory database found"
else
  echo "No memory database found - this appears to be a fresh installation"
fi
```

If no database exists, inform the user:

"This appears to be a fresh Design OS installation. No prior context to load.

Next steps:
1. Run `/analyze-app` to understand your codebase
2. Run `/product-vision` to start planning"

And stop here.

## Step 2: Load Last Session

```bash
sqlite3 -header design-context/memory.sqlite "
  SELECT started_at, summary, work_in_progress, next_steps, tags
  FROM sessions
  ORDER BY started_at DESC
  LIMIT 1
"
```

## Step 3: Load Key Decisions

```bash
sqlite3 -header design-context/memory.sqlite "
  SELECT topic, decision
  FROM decisions
  ORDER BY decided_at DESC
  LIMIT 10
"
```

## Step 4: Load Preferences

```bash
sqlite3 -header design-context/memory.sqlite "
  SELECT category, key, value
  FROM preferences
  ORDER BY category, key
"
```

## Step 5: Load Open Questions

```bash
sqlite3 -header design-context/memory.sqlite "
  SELECT question, context
  FROM open_questions
  WHERE status = 'open'
  ORDER BY created_at DESC
  LIMIT 5
"
```

## Step 6: Create New Session Record

```bash
sqlite3 design-context/memory.sqlite "
  INSERT INTO sessions (started_at, tags)
  VALUES (datetime('now'), '')
"
```

## Step 7: Present Context

Format and present the loaded context:

```
## Session Started

### Last Session
**Date:** [started_at]
**Summary:** [summary]

### Work in Progress
[work_in_progress or "None"]

### Planned Next Steps
[next_steps or "None"]

### Key Decisions
- [topic]: [decision]
- [topic]: [decision]
...

### Your Preferences
- [category]/[key]: [value]
...

### Open Questions
- [question]
...

---

Ready to continue. What would you like to work on?
```

If this is the first session after a fresh install:

```
## Session Started (Fresh Installation)

No prior context found. This is a fresh Design OS installation.

To get started:
1. Run `/analyze-app` to understand your existing codebase
2. Or run `/product-vision` to start planning from scratch

What would you like to do?
```
