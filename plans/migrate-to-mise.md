# Migrate to mise for tool version management

Currently `install.sh` installs tools via brew with no version pinning.
`mise` would allow declaring exact versions of tools (neovim, node, python, etc.)
in a `mise.toml`, making the dev environment reproducible across machines.

## References
- https://mise.jdx.dev
- Drop-in replacement for asdf, supports all the same plugins
