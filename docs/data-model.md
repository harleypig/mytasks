# Data Model

This document describes the task data structure, fields, and relationships.

## Task Semantics

### Basic Fields

Every task includes these core fields:

* **ID**: Unique identifier for the task
* **Description**: Short description of the task
* **Status**: Current state (pending, done, deleted, etc.)
* **Created/modified timestamps**: When the task was created and last modified
* **Due date / scheduled date**: Optional date fields for scheduling
* **Tags**: Array of tags for categorization
* **Project/context**: Optional project or context grouping

### Optional Fields

Tasks may also include:

* **Parents / dependents**: Task graph relationships (see below)
* **Notes / freeform body text**: Additional details beyond the description

---

## Task Graph / Dependencies

Tasks can have relationships with other tasks:

* **Parent/child relationships**: Tasks can have parent tasks or child tasks
* **Dependencies**: Tasks can depend on other tasks being completed

The exact depth and complexity of these relationships is still under consideration (see Open Design Questions).

---

## Open Design Questions

### ID Strategy

* Human-friendly incremental IDs vs. UUIDs vs. hash (e.g., based on content)?
* How to avoid collisions when multiple machines create tasks concurrently?

### Task Graph / Dependencies

* How deeply do I want to lean into parent/child or dependency graphs?
* How do I model these relationships in a way that survives sync/merge?

### Conflict Strategy

* When two machines edit the same task file:

  * How to detect which field "wins"?
  * Do I want field-wise merges or "last-writer wins"?
* Is it acceptable to occasionally drop to manual conflict resolution via `git mergetool`?

---

## File Format Details

Tasks are stored as TOML files. See [design-decisions.md](design-decisions.md) for more information on the TOML format choice.

