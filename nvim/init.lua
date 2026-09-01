-- Neovim configuration.
--
-- This file is only an entry point; everything real lives in lua/.
--   lua/config/lazy.lua     plugin manager bootstrap + plugin install
--   lua/plugins.lua         plugin specifications
--   lua/config/options.lua  editor options, colorscheme, autoreload
--   lua/config/keymaps.lua  non-LSP keymaps and toggles
--   lua/config/cmp.lua      completion
--   lua/config/lsp.lua      LSP keymaps and gopls / ruff / pyright
--   lua/claude_explain.lua  :ClaudeAsk and <leader>ce

-- Must come first: everything below assumes plugins are on the runtimepath.
require("config.lazy")

require("claude_explain")
require("config.options")
require("config.cmp")

-- Order matters: lsp.lua maps <leader>q (diagnostics loclist) and the default
-- leader is "\\", so it collides with the \\q (:nohlsearch) mapping in
-- keymaps.lua. keymaps.lua must load last so \\q stays :nohlsearch, which is
-- how the original single-file config behaved.
require("config.lsp")
require("config.keymaps")
