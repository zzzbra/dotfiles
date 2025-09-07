# Git Configuration

This directory contains global Git configuration files that are symlinked to your home directory.

## Files

### `config` → `~/.gitconfig`
Global Git configuration including:
- User information (name, email)
- Credential helpers
- Default branch name (`main`)
- Push settings
- Platform-specific credential configurations

### `ignore` → `~/.gitignore`
Global gitignore patterns that apply to all repositories on your system. These are patterns you want to ignore everywhere (like OS-specific files, editor configs, etc.) but don't belong in individual project `.gitignore` files.

### `gitmessage` → `~/.gitmessage`
Commit message template that appears in your editor when you run `git commit`. Follows conventional commit format with:
- Type prefix (feat, fix, docs, etc.)
- Subject line (50 chars max)
- Body explaining the "why" (wrapped at 72 chars)
- Footer with issue references and breaking changes

## Git Template Directory (Future)

When we need Git repository templates (for hooks, default files, etc.), they should be organized as:

```
git/
├── README.md           (this file)
├── config             (→ ~/.gitconfig)
├── ignore             (→ ~/.gitignore)
├── gitmessage         (→ ~/.gitmessage)
└── templates/         (→ ~/.git_templates/)
    ├── hooks/
    │   ├── pre-commit
    │   ├── prepare-commit-msg
    │   └── commit-msg
    ├── info/
    │   └── exclude
    └── description
```

The `templates/` directory would contain templates for initializing new repositories with `git init`. This would include:
- **hooks/**: Git hooks that run at various points in the Git workflow
- **info/exclude**: Repository-specific ignore patterns (like .gitignore but not tracked)
- **description**: Repository description for Git web interfaces

## Conventions

### Commit Messages
We follow [Conventional Commits](https://www.conventionalcommits.org/) specification:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `perf:` Performance improvements
- `test:` Test additions/changes
- `build:` Build system changes
- `ci:` CI/CD changes
- `chore:` Other changes

### Global Ignores
The global gitignore should only contain:
- OS-specific files (`.DS_Store`, `Thumbs.db`, etc.)
- Editor/IDE files that you personally use
- Personal tool outputs

Project-specific patterns should go in the project's `.gitignore`.

## Adding New Git Configurations

1. Add the file to this directory
2. Update `makesymlinks.sh` to include it in the symlink process
3. Document it in this README
4. Consider if it should be user-specific (might need templating)

## Platform-Specific Notes

### macOS
- Git Credential Manager is installed via Homebrew
- Keychain integration is handled by `osxkeychain` helper

### Linux
- May need to install `git-credential-libsecret` for credential storage
- Update the credential helper in config accordingly

## Resources
- [Git Documentation](https://git-scm.com/docs)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Git Templates](https://git-scm.com/docs/git-init#_template_directory)