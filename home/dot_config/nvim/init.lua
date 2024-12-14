-- disp
-- disp.invisibles
vim.opt.list=true
vim.opt.listchars={tab='> ',multispace='*.',eol='$'}
--disp.misc
vim.opt.number=true
vim.opt.wrap=false

-- edit
-- edit.indent
vim.opt.softtabstop=-1 -- ==shiftwidth
vim.opt.shiftwidth=0 -- ==tabstop
vim.opt.tabstop=2

-- search
-- search.misc
vim.opt.ignorecase=true

-- bind
-- bind.leader
vim.g.mapleader=' '
-- bind.no_highlight
vim.keymap.set({'n','i'},'<esc>','<cmd>noh<cr><esc>',{})
-- bind.window
vim.keymap.set({'n'},'<c-h>','<c-w>h')
vim.keymap.set({'n'},'<c-j>','<c-w>j')
vim.keymap.set({'n'},'<c-k>','<c-w>k')
vim.keymap.set({'n'},'<c-l>','<c-w>l')
vim.keymap.set({'n'},'<c-left>','<c-w>h')
vim.keymap.set({'n'},'<c-down>','<c-w>j')
vim.keymap.set({'n'},'<c-up>','<c-w>k')
vim.keymap.set({'n'},'<c-right>','<c-w>l')
vim.keymap.set({'n'},'<c-c>','<c-w>c')
-- bind.buffer
vim.api.nvim_set_keymap('n','[b','<cmd>bprev<cr>',{desc='Previous buffer'})
vim.api.nvim_set_keymap('n',']b','<cmd>bnext<cr>',{desc='Next buffer'})

-- lazy.nvim
require('lazy_setup')
require('lazy').setup({
	spec={
		{
			'nvim-treesitter/nvim-treesitter',
			build=":TSUpdate",
			main='nvim-treesitter.configs',
			opts={
				ensure_installed={
					'bash','lua','hyprlang',
					'ini','json','toml','yaml',
					'html','css','javascript',
					'arduino','c','cpp','make',
					'glsl','hlsl',
					'python'
				},
				sync_install=false,
				highlight={enable=true},
				indent={enable=true}
			}
		},
		{'nvim-telescope/telescope.nvim',keys={
			{'<c-p>','<cmd>Telescope find_files<cr>',desc='Telescope find_files'}
		}},
		{'nvim-tree/nvim-tree.lua',keys={
			{'<leader>f','<cmd>NvimTreeToggle<cr>',desc='NvimTreeToggle'}
		},opts={}},
		{'numToStr/Comment.nvim'},
		-- colorscheme
		{'navarasu/onedark.nvim',opts=function()require('onedark').load()end},
		-- UI
		{'nvim-lualine/lualine.nvim',opts={options={
			icons_enabled=false,
			theme='onedark'
		}}},
		{'akinsho/bufferline.nvim',opts={options={
			buffer_close_icon='x',
			modified_icon='M'
		}}},
		{'folke/which-key.nvim'},
		-- {'echasnovski/mini.icons',opts={style='ascii'}},
	},
	ui={
		icons={
			cmd='⌘',config='🛠',event='📅',ft='📂',init='⚙',keys='🗝',plugin='🔌',
			runtime='💻',require='🌙',source='📄',start='🚀',task='📌',lazy='💤',
		},
	},
	checker={enabled=true},
})

