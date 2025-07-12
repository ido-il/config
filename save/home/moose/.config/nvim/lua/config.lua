vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = '#FFFF00', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'WarningMsg', { fg = '#00FF00', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'Error', { fg = '#00FF00', bg = 'NONE' })

vim.opt.number = true
vim.opt.relativenumber = true

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

