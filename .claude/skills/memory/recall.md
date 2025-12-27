# /recall

Query the knowledge base for specific information.

## Usage

```
/recall authentication         → Returns all auth-related decisions
/recall entities               → Returns domain model understanding
/recall session:last           → Returns last session summary
/recall preferences:testing    → Returns testing preferences
/recall components             → Returns discovered components
/recall patterns               → Returns identified patterns
```

## Step 1: Parse Query

Identify what the user wants to recall:
- Topic keyword → Search decisions and discoveries
- `entities` → List all entities
- `session:last` → Get last session
- `preferences:[category]` → Get preferences in category
- `components` → List discovered components
- `patterns` → List identified patterns
- `questions` → List open questions

## Step 2: Construct Query

### Topic Search (Default)

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT 'decision' as type, topic, decision as content, decided_at as timestamp
  FROM decisions
  WHERE topic LIKE '%[query]%' OR decision LIKE '%[query]%'
  UNION ALL
  SELECT 'discovery' as type, name as topic, description as content, discovered_at as timestamp
  FROM discoveries
  WHERE name LIKE '%[query]%' OR description LIKE '%[query]%'
  ORDER BY timestamp DESC
  LIMIT 20
"
```

### Entities

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT name, description, relationships, location
  FROM entities
  ORDER BY name
"
```

### Last Session

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT started_at, ended_at, summary, work_in_progress, next_steps
  FROM sessions
  ORDER BY started_at DESC
  LIMIT 1
"
```

### Preferences by Category

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT category, key, value, notes
  FROM preferences
  WHERE category = '[category]'
  ORDER BY key
"
```

### Components

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT name, location, description
  FROM discoveries
  WHERE category = 'component'
  ORDER BY name
"
```

### Patterns

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT name, description, metadata
  FROM discoveries
  WHERE category = 'pattern'
  ORDER BY name
"
```

### Open Questions

```bash
sqlite3 -header -column design-context/memory.sqlite "
  SELECT question, context, status, created_at
  FROM open_questions
  WHERE status = 'open'
  ORDER BY created_at DESC
"
```

## Step 3: Execute and Format

Run the query and format the results in a readable way.

## Step 4: Present Results

Display the results to the user in a clear format:

```
## Recall: [query]

Found [N] results:

### Decisions
- [Topic]: [Decision] (recorded [date])

### Discoveries
- [Name]: [Description] at [location]

### Preferences
- [category]/[key]: [value]
```

If no results found:
"No memories found for '[query]'. Try a different search term or run /analyze-app to discover more about your codebase."
