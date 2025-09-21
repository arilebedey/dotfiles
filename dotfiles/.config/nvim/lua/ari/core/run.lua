local read_theme = require("ari.core.functions.read_theme")
local tree_config = require("ari.core.functions.tree_config")
local read_lsp = require("ari.core.functions.read_lsp")

-- Apply the last selected theme
read_theme.apply_last_theme()

-- Pre-load tree configuration
tree_config.get_tree_state()

-- Apply LSP toggle state
read_lsp.apply_last_lsp_state()
