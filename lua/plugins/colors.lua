return {
--    {
--        'askfiy/visual_studio_code',
--        name = 'visual_studio_code',
--        priority = 1000,
--        config = function()
--            require('visual_studio_code').setup {
--                mode = 'light',
--            }
--            vim.cmd.colorscheme 'visual_studio_code'
--        end,
--    },
--    {
--        'catppuccin/nvim',
--        name = 'catppuccin',
--        priority = 10,
--        config = function()
--            require('catppuccin').setup {
--                flavour = 'latte',
--            }
--            vim.cmd.colorscheme 'catppuccin'
--        end,
--    },
    {
        -- "nyoom-engineering/oxocarbon.nvim",
        "EdenEast/nightfox.nvim"
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        options = { theme = 'catppuccin' },
    },
}

