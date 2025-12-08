# Architecture

This document describes the system architecture and deployment model.

## Repository / Deployment Model

Each installation of the task manager should behave like a standalone project repository:

* A task repository is **self-contained** and can run entirely locally with no remote configured.
* All functionality (creating, listing, updating tasks, etc.) must work with:

  * No network access.
  * No central server.
  * No git remote.
* If desired, the same repository can be linked to one or more remotes (e.g., GitHub, GitLab, a bare repo on a server), and:

  * Sync is handled using normal `git` workflows (`pull`, `push`, `fetch`, etc.).
  * There is no assumption of a single "canonical" or always-on server.
* Multiple machines can collaborate on the same task repository the same way they would on a code repository:

  * Clone, branch, commit, merge, push, and pull are all valid workflows.
  * Conflicts are resolved using standard git tooling.

In other words, a task repo should behave exactly like a code repo: fully functional on its own, with optional remotes for sync and collaboration, but no hard dependency on them.

---

## Interoperability Through Git

Because the task repository is just a git-managed directory of plain-text files, any external tool that understands git can also interact with the task data. This enables:

* Mobile or desktop apps that embed a git client (e.g., an Android app) to clone, edit, or sync tasks directly.
* Third-party tools to parse or manipulate tasks without needing to integrate with a custom API or service.
* Automation or scripting layers to consume tasks the same way they would consume files in any code repository.

This design keeps task data maximally open, inspectable, and ecosystem-friendly—any tool that understands git and text files can participate.

---

## Environment & Constraints

### User Environment

* I manage multiple machines/servers (including remote boxes).
* I already have:

  * `git` everywhere.
  * SSH everywhere.
  * Familiarity with shell scripting and automation.
* I prefer:

  * Keyboard-centric workflows.
  * Tools that can be scripted, piped, and composed.

### System Requirements

This means the task manager should:

* Fit well into a dotfiles / infra-as-code environment.
* Avoid hidden magic.
* Play nicely with `git` hooks, cron jobs, etc.

---

## Component Design

(To be expanded as implementation progresses)

The system will consist of:

* **Data layer**: File-based storage using TOML format
* **Core logic**: Task operations (create, read, update, delete, query)
* **CLI interface**: Command-line tool for user interaction
* **Git integration**: Detection and interaction with git repositories
* **Conflict handling**: Detection and resolution of merge conflicts

