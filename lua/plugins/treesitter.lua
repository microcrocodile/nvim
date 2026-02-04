return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        local configs = require('nvim-treesitter.configs')

        configs.setup({
            highlight = {
                enable = true,
            },
            indent = {
                enable = true
            },
            autotag = {
                enable = true
            },
            ensure_installed = {
                'c',
                'vim',
                'vimdoc',
                'lua',
                'tsx',
                'typescript',
                'javascript',
                'html',
                'python',
            },
            auto_install = false,
        })
    end
}
