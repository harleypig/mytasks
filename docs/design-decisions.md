# Design Decisions

This document captures the key design decisions made for the task manager system.

## Storage Model Decision

**Initial approach**: Flat `tasks/` directory with all task files in a single location.

* Status encoded in file metadata (not filesystem location)
* Simple to implement and reason about
* Easy to list, search, and manipulate with standard tools

**Future extensibility**: Structure can be added later if needed (e.g., `tasks/by-project/`, `tasks/archive/`) without breaking existing workflows. This hybrid approach allows us to start simple and evolve the organization as requirements become clearer.

---

## File Format

Tasks will be stored as **TOML** files with the following structure:

* TOML frontmatter for structured metadata (ID, status, dates, tags, etc.)
* Optional freeform body text for notes/description
* Human-readable and merge-friendly
* Easy to parse with standard tools (`toml-cli`, `jq` with TOML support, etc.)

TOML provides a good balance between human readability and structured data, making it ideal for tasks that need to be both machine-parseable and manually editable.

---

## Hooks System

The task manager includes a **hooks system** (similar to git hooks but separate from git) that allows users to execute scripts at specific events during task operations. Hooks are a first-class feature designed into the system from the start, not bolted on later.

### Hook Events

Hooks can be triggered at the following events:

* **pre-create**: Before a task is created
* **post-create**: After a task is successfully created
* **pre-update**: Before a task is updated
* **post-update**: After a task is successfully updated
* **pre-delete**: Before a task is deleted
* **post-delete**: After a task is successfully deleted
* **pre-list**: Before listing tasks (allows filtering/modification of query)
* **post-list**: After listing tasks (allows post-processing of results)

### Hook Configuration Format

Hooks are configured in a TOML configuration file (e.g., `.mytask/config.toml` or `config.toml` in the repository root). Each hook event is defined as a **top-level TOML table** (section), allowing multiple hooks per event:

```toml
[hooks.pre-create]
script = "/path/to/pre-create-script.sh"
enabled = true

[hooks.post-create]
script = "/path/to/post-create-script.sh"
enabled = true

[hooks.pre-update]
script = "/path/to/pre-update-script.sh"
enabled = true
```

### Hook Execution

* Hooks receive task data (as TOML or JSON) via stdin
* Hooks can modify task data (pre- hooks) or perform side effects (post- hooks)
* Pre- hooks can abort the operation by exiting with non-zero status
* Hook scripts are executed in the repository root directory
* Hook failures are logged but don't necessarily abort operations (configurable per hook)

### Design Rationale

* **TOML top-level tables**: Using TOML top-level sections (tables) provides a clean, structured way to define hooks that's consistent with the task file format
* **Separate from git**: Hooks are independent of git hooks, allowing task-specific automation without interfering with git workflows
* **First-class feature**: Built into the core architecture ensures hooks are reliable, well-tested, and properly integrated with all task operations
* **Scriptable**: Hooks enable automation, validation, notifications, and integration with other tools

