# Development Guide

This document describes the development environment and setup needed to work on this project.

## Prerequisites

### Required Tools

* **Perl**: Version 5.20 or later (check with `perl -v`)
* **Git**: For version control
* **local::lib**: For managing Perl module dependencies (isolated from system Perl)
* **cpanm** (or equivalent): For installing Perl modules (CPAN::Minus or `cpan`)
* **Make**: For build automation (if using Makefile-based builds)

### Development Environment

* **Unix-like system**: Linux, macOS, WSL, or similar
* **Shell**: Bash or compatible shell
* **Text editor**: Any editor capable of editing Perl and Markdown files

## Perl Environment Setup

### Using local::lib

The project uses **`local::lib`** for managing Perl module dependencies. This keeps project dependencies isolated from the system Perl installation.

#### Initial Setup

1. Install `local::lib` if not already available:
   ```bash
   # Install via cpanm (recommended)
   curl -L https://cpanmin.us | perl - App::cpanminus
   cpanm --local-lib=~/perl5 local::lib
   
   # Or install via cpan
   cpan local::lib
   ```

2. Configure your shell to use `local::lib`:
   ```bash
   # Add to your ~/.bashrc or ~/.zshrc
   eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

#### Project-Specific Setup

The project uses a bootstrap script to set up the local::lib environment:

```bash
./scripts/bootstrap.sh
```

This script:
* Creates the `.local-lib/` directory in the project root (dot-prefixed to keep the root directory clean)
* Generates `scripts/local-env.sh` with the necessary environment variables for local::lib
* Installs project dependencies automatically (if dependency files exist)

After running the bootstrap script, you must manually source `scripts/local-env.sh` to activate the environment:

```bash
source scripts/local-env.sh
```

**Note**: The bootstrap script only needs to be run once (or after cloning the repository). However, you must source `scripts/local-env.sh` each time you start a new shell session to work on the project.

### Installing Perl Modules

Before installing or using Perl modules, ensure you have sourced the local::lib environment:

```bash
source scripts/local-env.sh
```

Then install project dependencies using `cpanm`:

```bash
# Install cpanm if not already installed (uses local::lib)
curl -L https://cpanmin.us | perl - App::cpanminus

# Install project dependencies (when defined)
# Modules will be installed to your .local-lib directory
cpanm --installdeps .
```

**Note**: With `local::lib` configured and `scripts/local-env.sh` sourced, `cpanm` will automatically install modules to your `.local-lib/` directory without requiring root access.

### Key CPAN Modules

Based on the implementation notes, the project will use:

* `Path::Tiny` - File path manipulation
* `File::Spec` - Portable file path operations
* `TOML::Tiny` - TOML parsing and generation
* `Data::UUID` - UUID generation
* `Time::Piece` - Date/time handling
* `DateTime` - Comprehensive date/time (if needed)
* `File::NFSLock` - Advisory file locking
* `Getopt::Long` - Command-line option parsing
* `App::Cmd` - CLI application framework (or alternatives)

**Note**: A `cpanfile` or `Makefile.PL` will be created as dependencies are finalized (see Milestone 1).

## Project Structure

```
mytask/
├── .local-lib/        # local::lib directory (dot-named for clean root)
├── bin/               # Tool scripts (the application executables)
├── scripts/           # Development scripts (e.g., local-env.sh)
├── docs/              # Documentation
├── lib/               # Perl modules (when created)
├── t/                 # Tests (when created)
├── examples/          # Example scripts/configs (when created)
├── AGENTS.md          # AI agent guidelines
├── TODO.md            # Open questions and tasks
└── README.md          # Project overview (when created)
```

### Directory Naming Conventions

To keep the root directory clean, files and directories that are not part of the core project structure should be **dot-named** (prefixed with a dot). Examples:

* **`.local-lib/`** - local::lib directory for Perl module dependencies
* **`.git/`** - Git repository metadata (standard)
* **`.gitignore`** - Git ignore patterns (standard)
* Other development artifacts should follow this pattern

### Directory Purposes

* **`bin/`** - Contains tool scripts (the actual application executables). These are the user-facing commands that will be installed or executed.
* **`scripts/`** - Contains development scripts (e.g., `local-env.sh` for setting up local development environment). These are helper scripts for developers, not part of the application itself.

## Development Workflow

### Getting Started

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd mytask
   ```

2. Run the bootstrap script:
   ```bash
   ./scripts/bootstrap.sh
   ```
   This script:
   * Sets up the `.local-lib/` directory for project-specific Perl modules
   * Creates `scripts/local-env.sh` with the necessary environment variables
   * Installs project dependencies (if `cpanfile`, `Makefile.PL`, or `Build.PL` exists)

3. Activate the local::lib environment:
   ```bash
   source scripts/local-env.sh
   ```
   **Important**: You must source `scripts/local-env.sh` each time you work on this project (see [Working on the Project](#working-on-the-project)).

4. Review documentation:
   * Start with `docs/README.md` for project overview
   * Review `docs/milestones.md` for development milestones
   * Check `docs/design-decisions.md` for key design choices
   * Review `AGENTS.md` for development guidelines

### Working on the Project

Each time you start working on the project in a new shell session, you must activate the local::lib environment:

```bash
source scripts/local-env.sh
```

This sets up the necessary environment variables (like `PERL5LIB`) so that Perl can find modules installed in `.local-lib/`. Without sourcing this script, Perl commands won't be able to use the project's local dependencies.

**Why manual sourcing?** The bootstrap script doesn't automatically source the environment for your shell because:
* Environment variables set in a script don't persist to your shell session
* Making it explicit helps you understand what's happening
* You'll remember to source it each time you work on the project

You can verify the environment is active by checking for the `PERL5LIB` variable:
```bash
echo $PERL5LIB
```

### Working on Milestones

Each milestone has specific requirements (see `docs/milestones.md`):

1. **Documentation**: Complete documentation before implementation
2. **Tests**: Write tests as you implement (test framework TBD)
3. **Implementation**: Working code that satisfies milestone requirements
4. **Versioning**: Follow versioning guidelines (minor for milestones 1-5, major for milestone 6+)

### Code Style

Follow Perl best practices:

* Use `strict` and `warnings`
* Follow consistent indentation (spaces or tabs - to be decided)
* Write clear, readable code over clever optimizations
* Document complex logic with comments
* Follow repository naming conventions (see `AGENTS.md`)

## Testing

**Status**: Testing framework to be determined (see TODO.md - Testing Strategy)

Once a testing framework is chosen, tests will be located in the `t/` directory and run pattern:
* `t/*.t` - Test files
* Use standard Perl testing conventions

## Building and Packaging

**Status**: Build system to be determined

Future considerations:
* `Makefile.PL` or `Build.PL` for module installation
* `cpanfile` for dependency management
* Fatpacking or PAR::Packer for standalone executables (if desired)

## Documentation

Documentation is maintained in the `docs/` directory:

* **README.md** - Project overview and entry point
* **milestones.md** - Development milestones
* **design-decisions.md** - Key design decisions
* **data-model.md** - Task data structure
* **architecture.md** - System architecture
* **cli-design.md** - CLI interface specification
* **implementation-notes.md** - Implementation language and tools
* **migration.md** - Migration and export documentation
* **DEVELOPMENT.md** - This file

Documentation follows these principles:
* Word wrapping at 78 columns in Markdown and comments
* Clear, practical examples
* Consistent terminology

## Contributing

For detailed contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md).

Quick reference:
* Follow milestone structure (see `docs/milestones.md`)
* Write tests for all code changes
* Update documentation as you implement features
* Follow guidelines in `AGENTS.md`

## Future Development Environment Updates

As milestones are completed, this document will be updated to include:

* **Milestone 1**: Task file format examples and validation tools
* **Milestone 2**: CLI command structure and testing
* **Milestone 3**: Configuration file examples and validation
* **Milestone 4**: Hook script examples and testing framework
* **Later milestones**: Additional tools and processes as needed

---

**Note**: This is a living document. Update it as the development environment evolves and new tools or processes are established.

