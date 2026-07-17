return {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewRefresh" },
    config = function()
        require("markdown_preview").setup({
            -- 默认值如下,按需取消注释调整
            -- instance_mode = "takeover",  -- "takeover"(单页共享) | "multi"(每实例一页)
            -- port = 0,                    -- 0 = 自动(takeover 用 8421)
            -- open_browser = true,
            -- default_theme = "dark",      -- "dark" | "light"
            -- debounce_ms = 300,
            -- scroll_sync = true,          -- 浏览器跟随光标滚动
            -- mermaid_renderer = "js",     -- 装了 mermaid-rs-renderer 可改 "rust" 提速
        })
    end,
}
