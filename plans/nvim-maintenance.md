# Neovim Maintenance Notes

## Background

Session in Feb 2026 involved a significant upgrade from Neovim 0.10.2 → 0.11.6.
The root cause was plugin drift: mason-lspconfig updated to v2.x and nvim-lspconfig
updated to v3.x, both of which dropped support for Neovim 0.10 and require the
native LSP API (`vim.lsp.config`, `vim.lsp.enable`) introduced in 0.11.

## What changed

- **Neovim upgraded** to 0.11.6 via `brew upgrade neovim`
- **lsp-zero removed** — was a convenience wrapper, now unnecessary with native 0.11 LSP API
- **LSP config rewritten** (`lua/aslan/plugins/lsp.lua`):
  - mason-lspconfig `handlers` removed (dropped in v2.x)
  - Per-server config now uses `vim.lsp.config('server_name', {...})`
  - Global capabilities set via `vim.lsp.config('*', { capabilities = ... })`
  - mason-lspconfig setup simplified to just `ensure_installed` + `automatic_enable` (default)
- **leap.nvim** — repo moved from GitHub (`ggandor/leap.nvim`) to Codeberg
  (`https://codeberg.org/andyg/leap.nvim`). `set_default_keymaps()` was removed
  from the API; replaced with explicit `<Plug>` mappings.
- **LuaSnip** — reinstalled clean due to accumulated stale submodule entries
  (`deps/jsregexp005`, `deps/jsregexp006`) left over from a previous packer installation.

## Luac cache gotcha

Neovim compiles Lua to bytecode and caches it in `~/.cache/nvim/luac/`. When
`:Lazy sync` updates plugin source files, the cache can become stale — Neovim
loads old bytecode instead of the updated source. Symptoms: deprecation warnings
or errors that don't match any text in the installed files.

**Fix:** delete the stale cache entries manually:
```
rm ~/.cache/nvim/luac/*<plugin-name>*
```

**Permanent fix (TODO):** add a `vim.loader.reset()` autocmd to `lazy.lua` that
fires after every sync, so the luac cache is automatically invalidated:

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "LazySync",
  callback = function() vim.loader.reset() end,
})
```

This belongs in `config/nvim/lua/aslan/lazy.lua`.

## Plugin API compatibility lesson

When plugins release major versions, they often drop support for older Neovim
APIs. The pattern to watch for:
- nvim-lspconfig, mason-lspconfig, and similar "glue" plugins tend to track
  Neovim releases closely
- Running `:Lazy sync` regularly without also keeping Neovim up to date is
  a recipe for breakage
- Once mise is adopted, Neovim version can be pinned explicitly to prevent
  silent drift
