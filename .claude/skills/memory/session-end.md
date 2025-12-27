# /session-end

Persist learnings and summarize the session before context is cleared. This should be run before ending a conversation or when the user indicates they're done.

## Purpose

Save everything learned during this session so the next conversation can pick up seamlessly:
- Summarize accomplishments
- Note work in progress
- Record planned next steps
- Persist any undiscovered decisions or preferences

## Step 1: Gather Session Information

Ask the user (or infer from conversation):
- What was accomplished this session?
- What is still in progress?
- What are the planned next steps?

If the user doesn't provide this, attempt to summarize based on the conversation.

## Step 2: Identify Key Files

List the key files that were worked on during this session:

```bash
# If git is available, check recent changes
git diff --name-only HEAD~1 2>/dev/null || echo "Unable to detect changed files"
```

Or track files mentioned during the conversation.

## Step 3: Update Session Record

Find the current session and update it:

```bash
sqlite3 design-context/memory.sqlite "
  UPDATE sessions
  SET
    ended_at = datetime('now'),
    summary = '[session_summary]',
    work_in_progress = '[wip_description]',
    next_steps = '[next_steps]',
    key_files = '[json_array_of_files]',
    tags = '[relevant_tags]'
  WHERE id = (SELECT MAX(id) FROM sessions)
"
```

## Step 4: Persist Any New Decisions

If any decisions were made during the session that weren't explicitly saved:

```bash
sqlite3 design-context/memory.sqlite "
  INSERT INTO decisions (topic, decision, rationale, source)
  VALUES ('[topic]', '[decision]', '[rationale]', 'inferred')
"
```

## Step 5: Record Any New Discoveries

If any patterns or components were discovered:

```bash
sqlite3 design-context/memory.sqlite "
  INSERT INTO discoveries (category, name, location, description, metadata)
  VALUES ('[category]', '[name]', '[location]', '[description]', '[metadata]')
"
```

## Step 6: Note Open Questions

If there are unresolved questions:

```bash
sqlite3 design-context/memory.sqlite "
  INSERT INTO open_questions (question, context, status)
  VALUES ('[question]', '[context]', 'open')
"
```

## Step 7: Confirm Session Saved

Present a summary to the user:

```
## Session Saved

### Summary
[what was accomplished]

### Work in Progress
[what's still ongoing]

### Next Steps
[planned actions for next session]

### Key Files
- [file1]
- [file2]

### Decisions Recorded
- [decision1]
- [decision2]

### Open Questions
- [question1]

---

Your session has been saved. When you start a new conversation,
run `/session-start` to restore this context.
```

## Automatic Triggers

Consider running `/session-end` when:
- User says "goodbye", "done", "that's all", etc.
- User explicitly requests to save progress
- A significant milestone is completed

## Example

**User:** "Okay, I think we're done for now. We finished the invoice list component."

**Response:**
```
## Session Saved

### Summary
Completed invoice list component with ViewComponent, including:
- InvoiceListComponent with filtering
- InvoiceRowComponent with status badges
- Stimulus controller for search

### Work in Progress
Invoice detail view (partially designed)

### Next Steps
1. Complete invoice detail view
2. Add PDF export functionality
3. Connect to real data

### Key Files
- app/components/invoices/invoice_list_component.rb
- app/components/invoices/invoice_row_component.rb
- app/javascript/controllers/invoices_list_controller.js

### Decisions Recorded
- Use Stimulus for client-side filtering (not Turbo Frames)

---

Your session has been saved. See you next time!
```
