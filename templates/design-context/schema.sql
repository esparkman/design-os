-- Design OS Memory System Schema
-- This schema creates the persistent knowledge base for cross-session continuity.

-- Core discoveries about the codebase
CREATE TABLE IF NOT EXISTS discoveries (
  id INTEGER PRIMARY KEY,
  category TEXT NOT NULL,        -- 'component', 'pattern', 'entity', 'route', 'helper'
  name TEXT NOT NULL,
  location TEXT,                 -- file path
  description TEXT,
  metadata JSON,                 -- flexible structured data
  discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  confidence REAL DEFAULT 1.0    -- 0.0-1.0 confidence score
);

-- Architectural and design decisions
CREATE TABLE IF NOT EXISTS decisions (
  id INTEGER PRIMARY KEY,
  topic TEXT NOT NULL,           -- 'authentication', 'styling', 'naming', etc.
  decision TEXT NOT NULL,        -- what was decided
  rationale TEXT,                -- why it was decided
  alternatives TEXT,             -- what was considered but rejected
  decided_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  source TEXT                    -- 'user', 'inferred', 'documented'
);

-- User preferences and conventions
CREATE TABLE IF NOT EXISTS preferences (
  id INTEGER PRIMARY KEY,
  category TEXT NOT NULL,        -- 'coding_style', 'testing', 'naming', 'workflow'
  key TEXT NOT NULL,
  value TEXT NOT NULL,
  notes TEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(category, key)
);

-- Session summaries for continuity
CREATE TABLE IF NOT EXISTS sessions (
  id INTEGER PRIMARY KEY,
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  summary TEXT,                  -- what was accomplished
  work_in_progress TEXT,         -- what was left incomplete
  next_steps TEXT,               -- planned next actions
  key_files JSON,                -- files that were important
  tags TEXT                      -- comma-separated tags for filtering
);

-- Entities/domain model understanding
CREATE TABLE IF NOT EXISTS entities (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  relationships JSON,            -- {"belongs_to": [...], "has_many": [...]}
  attributes JSON,               -- key attributes discovered
  location TEXT,                 -- model file path
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Open questions and blockers
CREATE TABLE IF NOT EXISTS open_questions (
  id INTEGER PRIMARY KEY,
  question TEXT NOT NULL,
  context TEXT,
  status TEXT DEFAULT 'open',    -- 'open', 'resolved', 'deferred'
  resolution TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_discoveries_category ON discoveries(category);
CREATE INDEX IF NOT EXISTS idx_discoveries_name ON discoveries(name);
CREATE INDEX IF NOT EXISTS idx_decisions_topic ON decisions(topic);
CREATE INDEX IF NOT EXISTS idx_preferences_category ON preferences(category);
CREATE INDEX IF NOT EXISTS idx_sessions_started_at ON sessions(started_at);
CREATE INDEX IF NOT EXISTS idx_open_questions_status ON open_questions(status);
