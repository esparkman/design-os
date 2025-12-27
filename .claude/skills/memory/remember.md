# /remember

Save discoveries, decisions, or preferences to the persistent memory database.

## Usage

```
/remember decision: We use Devise for authentication with magic links
/remember preference: Always use system tests over request specs for UI flows
/remember entity: Customer belongs_to Tenant, has_many Orders
/remember discovery: Found ButtonComponent at app/components/base/button_component.rb
```

## Step 1: Parse Input

Identify the type from the user's input:
- `decision:` → Save to decisions table
- `preference:` → Save to preferences table
- `entity:` → Save to entities table
- `discovery:` → Save to discoveries table

Extract the content after the type indicator.

## Step 2: Construct SQL

Based on the type, construct the appropriate INSERT statement.

### For Decisions

```bash
sqlite3 design-context/memory.sqlite "INSERT INTO decisions (topic, decision, rationale, source) VALUES ('[extracted_topic]', '[decision_text]', '[rationale_if_provided]', 'user')"
```

### For Preferences

```bash
sqlite3 design-context/memory.sqlite "INSERT OR REPLACE INTO preferences (category, key, value, notes) VALUES ('[category]', '[key]', '[value]', '[notes]')"
```

### For Entities

```bash
sqlite3 design-context/memory.sqlite "INSERT OR REPLACE INTO entities (name, description, relationships, attributes, location) VALUES ('[name]', '[description]', '[relationships_json]', '[attributes_json]', '[location]')"
```

### For Discoveries

```bash
sqlite3 design-context/memory.sqlite "INSERT INTO discoveries (category, name, location, description, metadata) VALUES ('[category]', '[name]', '[location]', '[description]', '[metadata_json]')"
```

## Step 3: Execute

Run the constructed SQL command using Bash.

## Step 4: Confirm

Report what was saved to the user:

"✓ Saved [type]: [summary]"

If the save failed, report the error and suggest a fix.

## Examples

**Input:** `/remember decision: We use ViewComponent for all UI components because it provides better testability`

**Output:**
```
✓ Saved decision:
  Topic: UI Components
  Decision: We use ViewComponent for all UI components
  Rationale: Provides better testability
```

**Input:** `/remember preference: testing/approach = system tests for UI flows`

**Output:**
```
✓ Saved preference:
  Category: testing
  Key: approach
  Value: system tests for UI flows
```
