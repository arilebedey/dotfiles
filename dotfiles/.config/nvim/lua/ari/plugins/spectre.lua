return {
    'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
    event = 'VeryLazy',
    keys = {
        {
            '<leader>R',
            '<cmd>lua require("spectre").toggle()<cr>',
            desc = 'Toggle [R]eplace (Spectre)',
        },
        {
            '<leader>rw',
            '<cmd>lua require("spectre").open_visual({select_word=true})<cr>',
            desc = '[R]eplace current [W]ord (Spectre)',
        },
        {
            '<leader>rb',
            '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
            desc = '[R]eplace on current [B]uffer (Spectre)',
        },
    },
    config = function()
        require('spectre').setup({
            live_update = false, -- auto execute search again when you write to any file in vim
        })
    end,
}
