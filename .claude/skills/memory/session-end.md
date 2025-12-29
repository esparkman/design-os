# /session-end

Persist learnings and summarize the session before context is cleared.

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

## Step 3: Save Any Pending Memories

Before ending the session, use `pensieve_remember` to save any decisions, discoveries, or preferences that were made but not yet recorded.

For each unrecorded decision:
```json
{
  "type": "decision",
  "topic": "[topic]",
  "content": "[decision]",
  "rationale": "[rationale]"
}
```

For each unrecorded discovery:
```json
{
  "type": "discovery",
  "category": "[category]",
  "name": "[name]",
  "location": "[location]",
  "description": "[description]"
}
```

## Step 4: End Session with Summary

Use the `pensieve_session_end` MCP tool to finalize the session:

```json
{
  "summary": "[what was accomplished]",
  "work_in_progress": "[what's still ongoing]",
  "next_steps": "[planned actions for next session]",
  "key_files": ["file1.rb", "file2.rb"]
}
```

## Step 5: Confirm Session Saved

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
Pensieve will automatically load this context.
```

## Automatic Triggers

Consider running `/session-end` when:
- User says "goodbye", "done", "that's all", etc.
- User explicitly requests to save progress
- A significant milestone is completed

## Example

**User:** "Okay, I think we're done for now. We finished the invoice list component."

**Action:** Call `pensieve_session_end` with:
```json
{
  "summary": "Completed invoice list component with ViewComponent, including InvoiceListComponent with filtering, InvoiceRowComponent with status badges, and Stimulus controller for search",
  "work_in_progress": "Invoice detail view (partially designed)",
  "next_steps": "1. Complete invoice detail view\n2. Add PDF export functionality\n3. Connect to real data",
  "key_files": [
    "app/components/invoices/invoice_list_component.rb",
    "app/components/invoices/invoice_row_component.rb",
    "app/javascript/controllers/invoices_list_controller.js"
  ]
}
```

**Output:**
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
