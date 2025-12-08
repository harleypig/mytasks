# CLI Design

This document specifies the command-line interface for the task manager.

## Design Principles

The CLI should provide:

* **Reasonable CLI UX**:

  * `task add`, `task list`, `task done`, etc. or similar verbs.
  * Output suitable for TUI use or shell piping.
  * Easy to integrate into scripts and other tools.

* **Keyboard-centric workflows**: Optimized for fast, scriptable interactions.

* **Composability**: Commands should work well with pipes, filters, and other Unix tools.

---

## Command Structure

(To be designed - placeholder for future CLI specification)

The exact command name is still under consideration (see Open Design Questions).

### Proposed Commands

* `task add` - Create a new task
* `task list` - List tasks with optional filtering
* `task show` - Display details of a specific task
* `task done` - Mark a task as completed
* `task edit` - Edit an existing task
* `task delete` - Delete a task
* `task sync` - Sync with git remotes (if configured)

---

## Open Design Questions

### CLI Command Name

* What should the CLI command be called?

  * `mytask` (matches project name)
  * `task` (generic, might conflict with Taskwarrior)
  * `tt` or `t` (short alias)
  * Something else?

### Output Formats

* Should commands support multiple output formats (plain text, JSON, TOML)?
* How should list output be formatted for optimal readability and scriptability?

### Filtering and Querying

* What filtering options should be available?
* How should complex queries be expressed?

---

## Integration Points

The CLI should integrate well with:

* **Task hooks**: Built-in hooks system for task operation automation (see [Design Decisions](design-decisions.md))
* **Git hooks**: Pre-commit, post-commit hooks for automatic syncing
* **Cron jobs**: Scheduled task processing
* **Shell scripts**: Easy to call from automation
* **TUI tools**: Output format suitable for terminal UI consumption

### Hook Integration

The CLI executes hooks automatically during task operations:
* Pre-operation hooks can validate or modify task data before operations
* Post-operation hooks can trigger notifications, logging, or other side effects
* Hook execution is transparent to users but can be monitored via verbose/debug flags
* Failed hooks can optionally abort operations or just log warnings

