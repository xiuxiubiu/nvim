local api = vim.api
local g = vim.g
local opt = vim.opt

opt.termguicolors = true -- Enable colors in termimal
opt.hlsearch = true -- Set highlight on search
opt.number = true -- Make line numbers default
opt.tabstop = 4 -- set ts=4
opt.sw = 4 -- set sw=4
opt.mouse = 'a' -- Enable mouse mode
opt.ignorecase = true -- Case insensitive searching unless /C or capital search
opt.signcolumn = 'yes' -- Always show sign column
opt.clipboard = 'unnamedplus' -- AAccess system clipboard
