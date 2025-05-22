local opts = {}

vim.keymap.set('n', '<C-e>', ':Neotree filesystem focus right<CR>', opts)

vim.keymap.set("n", "<leader>d", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, opts)
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>sh', builtin.help_tags, opts)
vim.keymap.set('n', '<leader>sg', builtin.live_grep, opts)
