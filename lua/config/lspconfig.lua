local lspconfig = require 'lspconfig'
local util = require 'lspconfig/util'

-- ccls
-- lspconfig.clangd.setup {}
lspconfig.ccls.setup {}

-- gopls
lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {unusedparams = true},
            -- staticcheck = true,
            hoverKind = "FullDocumentation",
            codelenses = {upgrade_dependency = true}
            -- allowModfileModifications = true,
        }
    }
}

-- rust-analyzer
-- lspconfig.rust_analyzer.setup {
-- 	cmd = {"rust-analyzer"},
-- }

-- lua-language-server
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
}

-- typescript-language-server
lspconfig.tsserver.setup {}

-- volar
-- require'lspconfig'.volar.setup {
--     filetypes = {
--         'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue',
--         'json'
--     }
-- }

-- deno
-- require'lspconfig'.denols.setup {}

-- html
-- lspconfig.html.setup {}

-- python
lspconfig.anakin_language_server.setup {}

-- tailwindcss
lspconfig.tailwindcss.setup {
    filetypes = {
        "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure",
        "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb",
        "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html",
        "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx",
        "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "less",
        "postcss", "sass", "scss", "stylus", "sugarss", "javascript",
        "javascriptreact", "reason", "rescript", "typescript",
        "typescriptreact", "vue", "svelte", "templ"
    }
}

-- css
require'lspconfig'.cssls.setup {}

-- sql
require'lspconfig'.sqlls.setup {}
