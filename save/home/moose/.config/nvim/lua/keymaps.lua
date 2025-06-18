local opts = {}

vim.keymap.set('n', '<C-e>', ':Neotree filesystem focus right<CR>', opts)

vim.keymap.set("n", "<leader>d", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, opts)
vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, opts)
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, opts)
vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, opts)
