local packer = require'packer'

-- packer initialize
local conf = {
	display = {
		open_fn = function()
			return require'packer.util'.float { border = 'rounded' }
		end
	}
}
packer.init(conf)

-- plugins
packer.startup {
	function()
		-- packer.nvim
		use 'wbthomason/packer.nvim'
	
		-- Colorscheme
		use {
			'projekt0n/github-nvim-theme',
			config = function()
				require'github-theme'.setup()
			end
		}
	
		-- nvim-tree
		use {
			'kyazdani42/nvim-tree.lua',
			requires = {
				'kyazdani42/nvim-web-devicons', -- optional, for file icon
			},
			tag = 'nightly', -- optional, updated every week.
			config = function()
				require'config.nvim-tree'
			end
		}
		
		-- bufferline
		use {
			'akinsho/bufferline.nvim',
			tag = 'v2.*',
			requires = 'kyazdani42/nvim-web-devicons',
			config = function()
				require'config.bufferline'
			end
		}

		-- Collection of configurations for the built-in LSP client
		use {
			'neovim/nvim-lspconfig',
			config = function()
				require'config.lspconfig'
			end
		}

		-- nvim-cmp
		use {
			'hrsh7th/nvim-cmp',
			requires = {
				'neovim/nvim-lspconfig',
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'hrsh7th/cmp-cmdline',
				
				-- For vsnip users.
				'hrsh7th/cmp-vsnip',
				'hrsh7th/vim-vsnip',
				
				-- For luasnip users.
				'L3MON4D3/LuaSnip',
				'saadparwaiz1/cmp_luasnip',
				
				-- For ultisnips users.
				'SirVer/ultisnips',
				'quangnguyen30192/cmp-nvim-ultisnips',
				
				-- For snippy users.
				'dcampos/nvim-snippy',
				'dcampos/cmp-snippy',
			},
			config = function()
				require'config.nvim-cmp'
			end
		}

		-- nvim-dap
		use {
			'mfussenegger/nvim-dap',
			config = function()
				require'config.nvim-dap'
			end
		}

		-- nvim-dap-ui
		use {
			'rcarriga/nvim-dap-ui',
			requires = {
				'mfussenegger/nvim-dap'
			},
			config = function()
				require'config.nvim-dap-ui'
			end
		}
	
		-- nvim-dap-virtual-text
		use {
			'theHamsta/nvim-dap-virtual-text',
			requires = {
				'mfussenegger/nvim-dap'
			},
			config = function()
				require'config.nvim-dap-virtual-text'
			end
		}
		
		-- lualine
		use {
			'nvim-lualine/lualine.nvim',
			requires = {
				'kyazdani42/nvim-web-devicons',
				opt = true
			},
			config = function()
				require'config.lualine'
			end
		}

		-- toggleterm
		use {
			'akinsho/toggleterm.nvim', 
			tag = 'v1.*', 
			config = function()
  				require'config.toggleterm'
			end
		}

		-- vim-spectre
		use {
			'windwp/nvim-spectre',
			requires = {
				'kyazdani42/nvim-web-devicons',
				'nvim-lua/plenary.nvim'
			},
			config = function()
				require'spectre'.setup {}
			end
		}

		-- comment
		use {
			'numToStr/Comment.nvim',
			config = function()
				require'Comment'.setup {}
			end
		}

	end
}
