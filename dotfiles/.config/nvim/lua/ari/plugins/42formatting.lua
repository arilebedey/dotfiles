return {
  "MoulatiMehdi/42norm.nvim",
  ft = { "c", "cpp" }, -- Only load for C and C++ files
  config = function()
    local norm = require("42norm")

    norm.setup({
      header_on_save = true,     -- Insert/update 42 header on save
      format_on_save = true,     -- Format code on save
      linter_on_change = true,   -- Update diagnostics when buffer changes
      timeout = 3000,            -- Timeout for norminette (in milliseconds)
    })

    -- Key mappings
    -- F5 to run norminette and check norms
    vim.keymap.set("n", "<F5>", function()
      norm.check_norms()
    end, { desc = "Update 42norms diagnostics", noremap = true, silent = true })

    -- Ctrl+F to format the buffer (or choose another key if this conflicts)
    vim.keymap.set("n", "<C-f>", function()
      norm.format()
    end, { desc = "Format buffer on 42norms", noremap = true, silent = true })

    -- F1 to add/update the 42 header (or choose another key if this conflicts)
    vim.keymap.set("n", "<F1>", function()
      norm.stdheader()
    end, { desc = "Insert 42header", noremap = true, silent = true })

    -- Create convenient commands
    vim.api.nvim_create_user_command("Norminette", function()
      norm.check_norms()
    end, {})
    
    vim.api.nvim_create_user_command("Format42", function()
      norm.format()
    end, {})
    
    vim.api.nvim_create_user_command("Stdheader", function()
      norm.stdheader()
    end, {})
  end,
}
