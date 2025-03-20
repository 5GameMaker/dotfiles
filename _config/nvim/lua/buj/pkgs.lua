local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Lib
    'echasnovski/mini.nvim',

    -- LSP
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'petertriho/cmp-git',
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-jdtls',
    'SergioRibera/cmp-dotenv',
    'https://gitlab.com/schrieveslaach/sonarlint.nvim',

    -- GUI
    { 'akinsho/bufferline.nvim', commit = '2e3c8cc5a57ddd32f1edd2ffd2ccb10c09421f6c', dependencies = 'nvim-tree/nvim-web-devicons' },
    { 'catppuccin/nvim',         name = 'catppuccin',                                 priority = 1000 },
    'nvim-tree/nvim-tree.lua',
    'mkropat/vim-ezguifont',
    -- '5GameMaker/autoclose.nvim', (using local version)
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
    },
    'windwp/nvim-ts-autotag',
    'echasnovski/mini.move',

    -- Highlighting
    'nvim-treesitter/nvim-treesitter',
    'IndianBoy42/tree-sitter-just',
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
    'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',

    -- Git
    'tpope/vim-fugitive',

    -- Tools
    'ziontee113/color-picker.nvim',
    {
        'kylechui/nvim-surround',
        version = '*',
        event = 'VeryLazy',
        config = function() require('nvim-surround').setup({}) end
    },
})
