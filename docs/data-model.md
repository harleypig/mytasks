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

Tasks may also include recurrence-related fields:

* **Recurrence type**: Type of recurrence pattern (`fixed`, `relative`, `sequential`, or `none`)
* **Recurrence interval**: Interval for fixed/relative patterns (e.g., "daily", "weekly", "7 days")
* **Auto-completion deadline**: When to auto-handle incomplete recurring tasks
* **Auto-completion action**: Action to take (`complete`, `skip`, `delete`)
* **Parent recurrence ID**: Links task instances to their recurrence template
* **Sequence number**: Position in sequence (for sequential patterns)

### Optional Fields

Tasks may also include:

* **Parents / dependents**: Task graph relationships (see below)
* **Notes / freeform body text**: Additional details beyond the description
* **Recurrence pattern**: Configuration for repeating tasks (see below)

---

## Repeating Tasks

Tasks can be configured to repeat automatically, supporting three distinct patterns:

### 1. Daily/Weekly Recurring Tasks

**Pattern**: Tasks that must be done regularly (e.g., "take medication daily", "weekly team meeting").

**Behavior**:
* Task is generated on a fixed schedule (daily, weekly, etc.)
* If not completed by a deadline (e.g., midnight), the task is auto-handled (completed, skipped, or deleted based on configuration)
* Next task is generated immediately after auto-handling, maintaining the fixed schedule
* Example: Daily medication task auto-completes at midnight if not marked done, and the next day's task is created

**Use cases**: Medication reminders, regular meetings, routine maintenance

### 2. "Lawn Mower" Pattern

**Pattern**: Tasks that should be done regularly, but scheduling is relative to completion (e.g., "mow lawn weekly").

**Behavior**:
* Task is generated with an initial due date
* If completed early or late, the next task is scheduled relative to the **completion date**, not the original due date
* If skipped, the next task is scheduled relative to when it was skipped/auto-handled
* Example: Lawn mowing due Saturday, but done Monday → next task due 7 days from Monday, not Saturday

**Use cases**: Weekly chores, periodic maintenance, flexible recurring tasks

### 3. "Reading" Pattern (Sequential)

**Pattern**: Sequential tasks where each must be completed before the next is generated (e.g., "read chapter 1", "read chapter 2").

**Behavior**:
* Next task is only generated when the current task is marked as completed
* Missing a day doesn't create a backlog of tasks
* Tasks are generated sequentially, one at a time
* Example: Reading chapter 1 → only when marked done does chapter 2 task appear

**Use cases**: Sequential reading, step-by-step projects, progressive learning

### Recurrence Configuration

Tasks with recurrence patterns include:

* **Recurrence type**: `fixed` (daily/weekly), `relative` (lawn mower), or `sequential` (reading)
* **Interval**: For fixed and relative types, the interval (e.g., "daily", "weekly", "7 days")
* **Auto-completion deadline**: For recurring tasks with a due date, when to auto-handle incomplete tasks (e.g., "midnight", "end of day")
* **Auto-completion action**: What to do with incomplete tasks (`complete`, `skip`, `delete`)
* **Template**: Base task data to use when generating the next instance
* **Sequence position**: For sequential tasks, current position in the sequence

### Task Generation and Auto-Completion

**Generation triggers**:
* Fixed recurring: On schedule (e.g., daily at midnight)
* Relative recurring: When current task is completed or auto-handled
* Sequential: Only when current task is marked as completed

**Auto-completion process** (for fixed recurring tasks):
1. System checks for tasks past their auto-completion deadline
2. Applies configured auto-completion action (complete/skip/delete)
3. Generates next task instance according to the recurrence pattern
4. Logs the auto-completion event for audit purposes

**Multi-host considerations**:
* Auto-completion should be idempotent (safe to run on multiple machines)
* Generation timestamps and sequence numbers help prevent duplicate task creation
* Conflict resolution handles cases where multiple machines generate tasks simultaneously

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

### Recurring Tasks Implementation

* **Auto-completion timing**: How should auto-completion be triggered?
  * Cron job? Background daemon? On-demand check?
  * Should it run automatically on every command, or require explicit invocation?
* **Multi-host coordination**: How to prevent duplicate task generation when multiple machines run auto-completion?
  * Use timestamps and sequence numbers?
  * Lock files or other coordination mechanisms?
* **Recurrence template storage**: Where should recurrence templates be stored?
  * In the task file itself?
  * Separate template files?
  * Configuration file?
* **Auto-completion action defaults**: What should the default action be for incomplete recurring tasks?
  * Complete, skip, or delete?
  * Should this be configurable per task or globally?

---

## File Format Details

Tasks are stored as TOML files. See [design-decisions.md](design-decisions.md) for more information on the TOML format choice.

