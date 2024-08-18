-- Function to copy the full path of the current file to the clipboard
local function copy_current_file_path()
  -- Get the full path of the current file
  local file_path = vim.fn.expand('%:p')
  -- Check if the file path is not empty
  if file_path == '' then
    print('No file path to copy.')
    return
  end

  -- Copy the file path to the clipboard using Vim's clipboard functionality
  vim.fn.setreg('+', file_path)
  print('Copied file path: ' .. file_path)
end

-- Add the function to the module's exports
return {
  copy_current_file_path = copy_current_file_path
}

