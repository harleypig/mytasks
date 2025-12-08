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

