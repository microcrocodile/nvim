return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPre", "BufNewFile" },
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
                'yaml',
                'python',
                'json',
                'markdown',
                'markdown_inline',
                'css',
                'bash',
                'dockerfile',
                'gitignore',
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                  init_selection = "<C-m>",
                  node_incremental = "<C-m>",
                  scope_incremental = false,
                  node_decremental = "<bs>",
                },
            },
            auto_install = false,
        })
    end
}
