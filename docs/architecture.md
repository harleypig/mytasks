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

### Repository Structure

A task repository has the following structure:

```
task-repo/
├── tasks/              # Directory containing task files (TOML)
│   ├── <task-id>.toml
│   └── ...
├── config.toml         # Repository configuration (hooks, settings)
└── .git/               # Git repository (if using git for sync)
```

The `config.toml` file in the repository root contains:
* Hook definitions (see [Design Decisions](design-decisions.md))
* Repository-specific settings
* Optional metadata

This structure keeps configuration version-controlled alongside tasks, ensuring hooks and settings sync across machines.

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
* Provide hooks system for automation and integration (separate from git hooks).

---

## Component Design

The system will consist of:

* **Data layer**: File-based storage using TOML format
* **Core logic**: Task operations (create, read, update, delete, query)
* **Hooks system**: Event-driven script execution for automation and integration
* **CLI interface**: Command-line tool for user interaction
* **Git integration**: Detection and interaction with git repositories
* **Conflict handling**: Detection and resolution of merge conflicts
* **Configuration management**: TOML-based configuration including hooks

### Hooks System Architecture

The hooks system is integrated into the core task operations:

* **Hook discovery**: Loads hook configuration from TOML config file at repository initialization
* **Hook execution**: Executes hooks at appropriate points in task operation lifecycle
* **Hook context**: Provides task data, operation type, and environment to hook scripts
* **Error handling**: Manages hook failures gracefully with configurable abort behavior
* **Performance**: Hooks are designed to be fast and non-blocking where possible

Hooks enable:
* **Validation**: Pre-operation validation of task data
* **Automation**: Post-operation actions (notifications, logging, etc.)
* **Integration**: Connect with external systems and tools
* **Customization**: Extend functionality without modifying core code

