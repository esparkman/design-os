# /remember

Save discoveries, decisions, or preferences to Pensieve memory.

## Usage

```
/remember decision: We use Devise for authentication with magic links
/remember preference: Always use system tests over request specs for UI flows
/remember entity: Customer belongs_to Tenant, has_many Orders
/remember discovery: Found ButtonComponent at app/components/base/button_component.rb
```

## Step 1: Parse Input

Identify the type from the user's input:
- `decision:` → Save as decision
- `preference:` → Save as preference
- `entity:` → Save as entity
- `discovery:` → Save as discovery

Extract the content after the type indicator.

## Step 2: Use Pensieve MCP Tool

Use the `pensieve_remember` MCP tool with the appropriate parameters.

### For Decisions

```json
{
  "type": "decision",
  "topic": "[extracted_topic]",
  "content": "[decision_text]",
  "rationale": "[rationale_if_provided]"
}
```

### For Preferences

```json
{
  "type": "preference",
  "category": "[category]",
  "key": "[key]",
  "value": "[value]"
}
```

### For Entities

```json
{
  "type": "entity",
  "name": "[entity_name]",
  "description": "[description]",
  "relationships": "[relationships]",
  "location": "[file_location_if_known]"
}
```

### For Discoveries

```json
{
  "type": "discovery",
  "category": "[component|pattern|token|other]",
  "name": "[name]",
  "location": "[file_path]",
  "description": "[description]"
}
```

## Step 3: Confirm

Report what was saved to the user:

"Saved [type]: [summary]"

If the save failed, report the error and suggest a fix.

## Examples

**Input:** `/remember decision: We use ViewComponent for all UI components because it provides better testability`

**Action:** Call `pensieve_remember` with:
```json
{
  "type": "decision",
  "topic": "UI Components",
  "content": "We use ViewComponent for all UI components",
  "rationale": "Provides better testability"
}
```

**Output:**
```
Saved decision:
  Topic: UI Components
  Decision: We use ViewComponent for all UI components
  Rationale: Provides better testability
```

**Input:** `/remember preference: testing/approach = system tests for UI flows`

**Action:** Call `pensieve_remember` with:
```json
{
  "type": "preference",
  "category": "testing",
  "key": "approach",
  "value": "system tests for UI flows"
}
```

**Output:**
```
Saved preference:
  Category: testing
  Key: approach
  Value: system tests for UI flows
```
