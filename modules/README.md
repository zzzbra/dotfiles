# modules

Opt-in extras. `install.sh` never runs anything here; you switch a module on
by hand, on the machines that want it.

Each module is one self-contained folder:

- a `README.md` saying what it does, how to use it and how to remove it;
- its settings, kept apart from its code;
- its command(s).

Nothing outside the folder refers to it, so deleting the folder removes the
module completely.

| Module | What |
|---|---|
| `spotlight-exclude/` | Keeps `node_modules`, `.venv` and Rust `target/` out of Spotlight |
