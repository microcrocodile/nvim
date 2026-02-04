return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        delay = 5,
    },
    keys = {
        {
            "<leader>?",
            function()
                require('which-key').show({
                    global = false,
                })
            end,
            desc = 'Buffer Local Keymaps'
        }
    }
}
