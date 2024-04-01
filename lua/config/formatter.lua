local util = require "formatter.util"
require'formatter'.setup {
    filetype = {
        go = {require'formatter.filetypes.go'.goimports},
        rust = {
            function()
                return
                    {exe = "rustfmt", args = {"--edition=2021"}, stdin = true}
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
        vue = {
            -- require'formatter.filetypes.vue'.prettier,
            function()
                return util.withl(function(parser)
                    if not parser then
                        return {
                            exe = "prettier",
                            args = {
                                "--stdin-filepath",
                                util.escape_path(
                                    util.get_current_buffer_file_path()),
                                "--use-tabs", "--tab-width=2",
                                "--vue-indent-script-and-style"
                            },
                            stdin = true,
                            try_node_modules = true
                        }
                    end

                    return {
                        exe = "prettier",
                        args = {
                            "--stdin-filepath",
                            util.escape_path(util.get_current_buffer_file_path()),
                            "--parser", parser, "--use-tabs", "--tab-width=2",
                            "--vue-indent-script-and-style"
                        },
                        stdin = true,
                        try_node_modules = true
                    }
                end, "vue")()
            end
        }
    }
}

