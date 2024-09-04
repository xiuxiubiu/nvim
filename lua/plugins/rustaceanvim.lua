return {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {tools = {float_win_config = {border = "single"}}}
    end
}
