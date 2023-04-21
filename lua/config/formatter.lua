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
        html = {
            function()
                return {
                    exe = "tidy",
                    args = {
                        "-quiet", "-modify", "--indent auto",
                        "--indent-with-tabs yes"
                    },
                    stdin = true
                }
            end
        },
        javascript = {require'formatter.filetypes.javascript'.prettier},
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
                                "--use-tabs", "--tab-width=4",
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
                            "--parser", parser, "--use-tabs", "--tab-width=4",
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

