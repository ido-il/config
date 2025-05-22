return {
	{
		"hrsh7th/nvim-cmp",

		dependencies = {
			"petertriho/cmp-git",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets"
		},

		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			-- TODO: find more snippers :P
			-- load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- configure cmp
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					['<C-j>'] = cmp.mapping.select_next_item(),
					['<C-k>'] = cmp.mapping.select_prev_item(),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),

				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
				}, {
					{ name = 'luasnip' },
				})
			})

			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'git' },
				}, {
					{ name = 'buffer' },
				})
			})
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",

		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},

		config = function()
			local mason = require("mason")
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			mason.setup({
				-- mason config here
			})

			mason_lspconfig.setup({
				handlers = {
					function(server_name)
						lspconfig[server_name].setup {
							capabilities = capabilities
						}
					end
				},

				ensure_installed = {
					-- TODO: check names for LSPs of:
					-- * python
					-- * rust
					-- * bash
					-- * c/cpp
				},

				automatic_enable = true
			})
		end
	}
}
