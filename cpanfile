# Perl dependency file (equivalent to requirements.txt)
# Install dependencies with: cpanm --installdeps .

# Runtime dependencies
requires 'TOML::Tiny', '0';

# Test dependencies
on test => sub {
  requires 'Path::Tiny', '0';
  # Test::More is part of Perl core, so no need to declare it
};

# Note: Additional dependencies will be added as milestones progress
# See docs/DEVELOPMENT.md for planned dependencies:
# - Data::UUID (UUID generation)
# - Time::Piece (date/time handling)
# - DateTime (comprehensive date/time, if needed)
# - File::NFSLock (advisory file locking)
# - Getopt::Long (command-line option parsing)
# - App::Cmd (CLI application framework, or alternatives)

