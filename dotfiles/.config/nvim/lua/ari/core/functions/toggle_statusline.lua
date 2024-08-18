-- ~/.config/nvim/functions/toggle_statusline.lua
local M = {}

function M.toggle_statusline()
    if vim.o.laststatus == 0 then
        vim.o.laststatus = 2
    else
        vim.o.laststatus = 0
    end
end

return M

