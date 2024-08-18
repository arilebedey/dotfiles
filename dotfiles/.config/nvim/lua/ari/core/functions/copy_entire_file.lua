local function copy_entire_file()
	local current_pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd("normal! ggVGy")
	vim.api.nvim_win_set_cursor(0, current_pos)
end

-- Add the function to the module's exports
return {
  copy_entire_file = copy_entire_file
}

