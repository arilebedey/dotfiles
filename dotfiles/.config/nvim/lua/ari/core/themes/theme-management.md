# Neovim Theme Management Guide

This document explains how to add, remove, and manage themes in your Neovim configuration.

## Theme Organization

The theme system is organized into several key components:

1. **Theme Files** - Individual theme configuration files in `lua/ari/core/themes/`
2. **Theme Switcher** - Core functionality to load and save themes in `lua/ari/core/functions/theme_switcher.lua`
3. **Keybindings** - All theme keybindings are centralized in `lua/ari/core/keybinds/themes.lua`
4. **Theme Storage** - Current theme is stored in `lua/ari/core/variables/theme.txt`

## Theme Structure

Themes can be structured in one of three ways:

1. **Direct module with a config function**:
   ```lua
   local M = {}
   
   M.config = function()
     vim.cmd("colorscheme theme_name")
     -- Additional configuration
   end
   
   return M
   ```

2. **Lazy plugin specification with a config function**:
   ```lua
   return {
     "author/theme-plugin",
     priority = 1000,
     config = function()
       vim.cmd("colorscheme theme_name")
       -- Additional configuration
     end
   }
   ```

3. **Lazy plugin specification as a list (recommended)**:
   ```lua
   local M = {}
   
   M.config = function()
     -- Your theme configuration here
     vim.cmd("colorscheme theme_name")
     vim.cmd('set laststatus=0')
   end
   
   return {
     {
       "author/theme-plugin",
       priority = 1000,
       config = M.config
     }
   }
   ```

The theme switcher is designed to handle all these formats automatically, but the third approach (with a separate config function) provides the best compatibility.

## Adding a New Theme

To add a new theme to your configuration:

1. Create a new Lua file in `lua/ari/core/themes/` with the name of your theme (e.g., `mytheme.lua`).
2. Structure the file using the recommended format above.
3. Make sure the config function properly sets the colorscheme and any additional configuration.
4. Add a keyboard shortcut in `lua/ari/core/keybinds/themes.lua` to activate your theme:

   ```lua
   kms('n', '<leader>tmy', 
     ':lua require("ari.core.functions.theme_switcher").load_theme("mytheme")<CR>',
     { noremap = true, silent = true, desc = "Switch to My Theme" })
   ```

5. Make sure your `init.lua` loads the theme keybindings:
   ```lua
   -- Load theme keybindings
   require("ari.core.keybinds.themes")
   ```

## Example Theme File

Here's an example of a well-structured theme file for the "nightfox" theme:

```lua
-- ari/core/themes/nightfox.lua
local M = {}

M.config = function()
  require("nightfox").setup({
    options = {
      styles = {
        comments = "italic",
        keywords = "bold",
        types = "italic,bold",
      },
      inverse = {
        match_paren = false,
        visual = false,
        search = false,
      },
      dim_inactive = false,
    },
    groups = {
      all = {
        LineNr = { fg = "palette.fg3" },
      },
    },
  })
  
  vim.cmd("colorscheme nightfox")
  vim.cmd('set laststatus=0')
end

-- For Lazy package manager
return {
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = M.config
  },
}
```

This structure works with both the theme switcher and Lazy plugin manager.

## Removing a Theme

To remove a theme from your configuration:

1. Delete the theme's Lua file from `lua/ari/core/themes/`.
2. Remove the associated keybinding from `lua/ari/core/keybinds/themes.lua`.
3. If the removed theme was your last active theme, set a new default theme by modifying the theme.txt file:
   ```
   echo "onedark" > ~/.config/nvim/lua/ari/core/variables/theme.txt
   ```

## Troubleshooting

If a theme isn't loading correctly:

1. Check that the theme name in the colorscheme command matches the actual theme name.
2. Make sure the theme's plugin is properly installed through your package manager.
3. Verify that the theme file follows one of the supported structures above.
4. Check for errors by running `:messages` in Neovim.
5. Enable debug logging by adding to your init.lua:
   ```lua
   vim.g.theme_switcher_debug = true
   ```

## Theme Keybindings

All theme keybindings follow a consistent pattern:
- `<leader>t` + two-letter abbreviation for the theme

Utility keybindings:
- `<leader>tl` - List all available themes
- `<leader>tc` - Show current theme

You can find and modify all theme keybindings in `lua/ari/core/keybinds/themes.lua`.
