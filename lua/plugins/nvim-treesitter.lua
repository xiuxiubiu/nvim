return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "query", "elixir", "heex",
                "javascript", "html", "java", "python", "typescript", "go",
                "json", "xml", "sql", "rust", "yaml"
            },
            sync_install = false,
            highlight = {enable = true},
            indent = {enable = true},
            modules = {},
            auto_install = true,
            ignore_install = {}
        })
        -- Workaround for Neovim 0.12.0 upstream crash with YAML injections
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/8626
        vim.treesitter.query.set("yaml", "injections", "")
    end
}

