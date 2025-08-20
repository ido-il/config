local kanagawa = {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function ()
		require('kanagawa').setup({
			theme = "wave"
		})
		vim.cmd("colorscheme kanagawa")
	end
}

local nord = {
	'shaunsingh/nord.nvim',
	priority = 1000,
	config = function()
		vim.cmd("colorscheme nord")
	end
}

local gruvbox = {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			terminal_colors = true, -- add neovim terminal colors
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "", -- can be "hard", "soft" or empty string
			palette_overrides = {},
			overrides = {},
			dim_inactive = false,
			transparent_mode = false,
		})
		vim.cmd("colorscheme gruvbox")
	end
}

return kanagawa
