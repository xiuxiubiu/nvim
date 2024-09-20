return {
    "mhartington/formatter.nvim",
    version = "*",
    config = function(_)
        require("formatter").setup {
            filetype = {
                go = {require'formatter.filetypes.go'.goimports},
                rust = {
                    function()
                        return {
                            exe = "rustfmt",
                            args = {"--edition=2021"},
                            stdin = true
                        }
                    end
                },
                c = {require'formatter.filetypes.c'.clangformat},
                lua = {require'formatter.filetypes.lua'.luaformat},
                html = {require'formatter.filetypes.html'.prettier},
                javascript = {require'formatter.filetypes.javascript'.prettier},
                typescript = {require'formatter.filetypes.typescript'.prettier},
                javascriptreact = {
                    require'formatter.filetypes.javascriptreact'.prettier
                },
                typescriptreact = {
                    require'formatter.filetypes.typescriptreact'.prettier
                },
                json = {require'formatter.filetypes.json'.prettier},
                css = {require'formatter.filetypes.css'.prettier},
                vue = {require'formatter.filetypes.vue'.prettier},
                java = {require'formatter.filetypes.java'.google_java_format},
                python = {require'formatter.filetypes.python'.yapf}
            }
        }
    end
}
