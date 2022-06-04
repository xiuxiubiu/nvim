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
