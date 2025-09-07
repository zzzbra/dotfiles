local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black, -- python code formatting
        null_ls.builtins.formatting.isort, -- python import sorting
    }
})
