; 覆盖 nvim-treesitter master 分支的 markdown 注入查询
; master 分支依赖自定义 directive `#set-lang-from-info-string!`,
; 在 Neovim 0.12 上已失效(master 官方支持上限 0.11),导致
; fenced code block 不产生注入、代码块无语法高亮。
; 这里改用 Neovim 0.12 内置 runtime 的标准写法(@injection.language)。

(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
