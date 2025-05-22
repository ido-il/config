return {
	"nvim-treesitter/nvim-treesitter",

	config = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
		require('nvim-treesitter.configs').setup({
			highlight = { enable = true, },
			auto_install = true,
		})
	end
}
