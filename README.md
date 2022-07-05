# nvim
neovim configurations

## terminal错误
```shell
# Test if the shell is launched in Neovim's Terminal
if [[ -n "${NVIM_LISTEN_ADDRESS}" ]]
then
    # TODO update the path each time Vim has a major upgrade
    export VIMRUNTIME=/usr/share/vim/vim82
fi
```

## golang tools
```shell
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

## check provider
```
checkhealth provider
```

## python3
```
pip3 install neovim
```

## nvim-spectre
https://github.com/nvim-pack/nvim-spectre

## clangd
https://github.com/clangd/clangd

## lldb-vscode
https://github.com/llvm/llvm-project/tree/main/lldb/tools/lldb-vscode
