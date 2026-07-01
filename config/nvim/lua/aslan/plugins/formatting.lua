-- ============================================================================
-- FORMATTING PHILOSOPHY  (this file is the decision record)
-- ----------------------------------------------------------------------------
-- Formatting is OPT-IN, per project. A project declares which formatter it
-- wants by COMMITTING that tool's config file; the editor only ever honors
-- what the project asked for. We never impose a formatter -- or a global
-- config -- on a project that did not opt in.
--
--   * <leader>f is MANUAL only. There is deliberately NO format-on-save.
--   * The project's committed config SELECTS the tool. One rule for every
--     language; only the set of available tools differs.
--   * No opt-in? Fall back to the language server's own formatter if it has
--     one (ts_ls does), otherwise do nothing (pyright has none -> no-op).
--     The LSP's formatter only ever reflects YOUR editor settings
--     (shiftwidth, expandtab, .editorconfig) -- never an external opinion.
--   * Every formatter binary is installed via Mason (mason-tool-installer in
--     lsp.lua), so the dotfiles are self-describing and nvm-independent.
--
-- Opt-in signals (content-checked, not mere file existence):
--   Python  ruff  -> [tool.ruff] in pyproject.toml, or ruff.toml/.ruff.toml
--           black -> [tool.black] in pyproject.toml
--           isort -> [tool.isort] in pyproject.toml, .isort.cfg,
--                    or [isort] in setup.cfg / tox.ini
--   JS/TS   prettier -> .prettierrc* / prettier.config.* / a top-level
--                       "prettier" key in package.json
--           biome    -> biome.json / biome.jsonc   (pattern primed but inert;
--                       to adopt: add "biome" to mason-tool-installer +
--                       uncomment the arm below)
--
-- Precedence: one project, one toolchain. Ruff supersedes black/isort when a
-- project opts into ruff -- the same way biome would supersede prettier.
-- ============================================================================

-- find the nearest matching file walking up from the buffer, stopping at $HOME
local function find_up(names, ctx)
  local hit = vim.fs.find(names, {
    upward = true,
    path = ctx.dirname,
    stop = vim.uv.os_homedir(),
    type = "file",
  })
  return hit[1]
end

local function file_matches(path, pattern)
  if not path then return false end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return false end
  return table.concat(lines, "\n"):find(pattern) ~= nil
end

-- top-level package.json key check (a dependency literally named in
-- devDependencies must NOT count as opting in -- hence a real JSON decode)
local function pkg_json_has_key(ctx, key)
  local pkg = find_up({ "package.json" }, ctx)
  if not pkg then return false end
  local ok, lines = pcall(vim.fn.readfile, pkg)
  if not ok then return false end
  local ok2, decoded = pcall(vim.json.decode, table.concat(lines, "\n"))
  return ok2 and type(decoded) == "table" and decoded[key] ~= nil
end

-- ---- opt-in predicates (conform condition signature: fn(self, ctx)) --------
local function ruff_optin(_, ctx)
  if find_up({ "ruff.toml", ".ruff.toml" }, ctx) then return true end
  return file_matches(find_up({ "pyproject.toml" }, ctx), "%[tool%.ruff")
end

local function black_optin(_, ctx)
  return file_matches(find_up({ "pyproject.toml" }, ctx), "%[tool%.black%]")
end

local function isort_optin(_, ctx)
  if find_up({ ".isort.cfg" }, ctx) then return true end
  if file_matches(find_up({ "pyproject.toml" }, ctx), "%[tool%.isort%]") then return true end
  return file_matches(find_up({ "setup.cfg", "tox.ini" }, ctx), "%[isort%]")
end

local function prettier_optin(_, ctx)
  local cfgs = {
    ".prettierrc", ".prettierrc.json", ".prettierrc.yaml", ".prettierrc.yml",
    ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
    ".prettierrc.toml", "prettier.config.js", "prettier.config.cjs",
    "prettier.config.mjs",
  }
  if find_up(cfgs, ctx) then return true end
  return pkg_json_has_key(ctx, "prettier")
end

-- local function biome_optin(_, ctx)
--   return find_up({ "biome.json", "biome.jsonc" }, ctx) ~= nil
-- end

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format (project-config gated)",
      },
    },
    config = function()
      require("conform").setup({
        -- manual only -- no format_on_save key on purpose
        formatters = {
          ruff_format           = { condition = ruff_optin },
          ruff_organize_imports = { condition = ruff_optin },
          isort = { condition = function(s, c) return isort_optin(s, c) and not ruff_optin(s, c) end },
          black = { condition = function(s, c) return black_optin(s, c) and not ruff_optin(s, c) end },
          prettierd = { condition = prettier_optin },
          -- biome  = { condition = biome_optin },
        },
        formatters_by_ft = {
          -- imports-sorter runs before the formatter; gated arms are mutually
          -- exclusive (ruff vs black/isort) so only one toolchain ever fires
          python          = { "ruff_organize_imports", "ruff_format", "isort", "black" },
          javascript      = { "prettierd" }, -- prepend "biome" to prefer it when adopted
          javascriptreact = { "prettierd" },
          typescript      = { "prettierd" },
          typescriptreact = { "prettierd" },
          json            = { "prettierd" },
          css             = { "prettierd" },
          html            = { "prettierd" },
        },
      })
    end,
  },
}
