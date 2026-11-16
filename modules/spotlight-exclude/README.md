# spotlight-exclude

Keeps build folders out of Spotlight: `node_modules`, Python `.venv`, and
Rust `target/`. Without it, Spotlight indexes every file inside them, and
searches fill up with package files (about 85,000 `package.json` files under
`~/dev` on tv-scorpion, almost all inside `node_modules`).

Replaces the npm tool `spotlight-manager`, which did the same thing but
needed Node and three npm packages, and was last updated in 2021.

## Use

Run it from a terminal that has **Full Disk Access** (System Settings >
Privacy & Security). A tmux session started before that access was
granted doesn't have it, so use a plain tab. Run it as yourself, not with
`sudo`; it asks for your password when it needs it.

```bash
~/dotfiles/modules/spotlight-exclude/spotlight-exclude status
~/dotfiles/modules/spotlight-exclude/spotlight-exclude apply --dry-run
~/dotfiles/modules/spotlight-exclude/spotlight-exclude apply
~/dotfiles/modules/spotlight-exclude/spotlight-exclude undo
```

Run `apply` again whenever there are new clones. Nothing runs on a
schedule: a background job would need Full Disk Access granted to the
shell itself, which is too broad for tidying search results.

## How it works

- `rules` says where to look and which folder names to skip.
- `apply` finds the matching folders and adds them to the exclusion list
  in `/System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist`,
  the same list as System Settings > Spotlight > Search Privacy. It then
  restarts Spotlight's indexer (`mds`) so the change takes effect.
- Before each change, the old list is saved to
  `~/.local/state/spotlight-exclude/`.
- `undo` removes only exclusions the rules match; ones you added in System
  Settings are left alone.

## Remove

Run `undo`, then delete this folder.
