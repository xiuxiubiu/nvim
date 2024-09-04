return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "query", "elixir", "heex",
                "javascript", "html", "java", "python", "typescript", "go",
                "json", "xml", "sql", "rust"
            },
            sync_install = false,
            highlight = {enable = true},
            indent = {enable = true},
            modules = {},
            auto_install = true,
            ignore_install = {}
        })
    end
}

