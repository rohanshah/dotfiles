-- Plugin specifications for lazy.nvim.
--
-- Same plugin set that vim-plug managed previously. The versions actually
-- installed are pinned in nvim/lazy-lock.json, which is committed so a fresh
-- machine reproduces this exact set rather than whatever HEAD is that day.

return {
  -- Fuzzy file finder (<C-p>).
  -- ctrlpvim/ctrlp.vim is the maintained community fork; the original
  -- kien/ctrlp.vim has been archived for years. Drop-in identical.
  {
    "ctrlpvim/ctrlp.vim",
    init = function()
      vim.g.ctrlp_max_files = 0
      vim.g.ctrlp_max_depth = 30
      vim.g.ctrlp_regexp = 1                                  -- default to regexp search
      vim.g.ctrlp_custom_ignore = [[\v[\/](target|build)$]]   -- ignore build output
    end,
  },

  -- File tree, opened on demand with <F3>.
  { "preservim/nerdtree", cmd = "NERDTreeToggle" },

  -- Colorscheme. Loaded eagerly and early so config/options.lua can apply it.
  { "altercation/vim-colors-solarized", lazy = false, priority = 1000 },

  -- Ships the per-server defaults (cmd, filetypes, root_markers) that
  -- config/lsp.lua layers its own settings on top of.
  { "neovim/nvim-lspconfig" },

  -- Completion engine and its sources.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
  },
}
