-- .../core/run.lua
local read_theme = require("ari.core.functions.read_theme")
local tree_config = require("ari.core.functions.tree_config")

-- Apply the last selected theme
read_theme.apply_last_theme()

-- Pre-load tree configuration
tree_config.get_tree_state()
