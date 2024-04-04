-- Neovim Configuration
------------------------

-- Plugin management
vim.cmd([[
    call plug#begin(stdpath('data') .. '/plugged')
    Plug 'kien/ctrlp.vim'
    Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'altercation/vim-colors-solarized'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'

    call plug#end()
]])

-- LSP management
local lspconfig = require("lspconfig")
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_exec([[
    augroup LspAutocommands
        autocmd! * <buffer>
        autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc
    augroup END
]], false)

local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
    }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Go settings
lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
    },
  },
})

-- Disable arrow keys in normal mode
vim.api.nvim_set_keymap('n', '<up>', '<nop>', { noremap = true }) -- Disable up arrow
vim.api.nvim_set_keymap('n', '<down>', '<nop>', { noremap = true }) -- Disable down arrow
vim.api.nvim_set_keymap('n', '<left>', '<nop>', { noremap = true }) -- Disable left arrow
vim.api.nvim_set_keymap('n', '<right>', '<nop>', { noremap = true }) -- Disable right arrow

-- Tab settings
vim.opt.autoindent = true -- Uses indent from the current line as indent for new line
vim.opt.tabstop = 4 -- Sets how many columns a tab counts for
vim.opt.shiftwidth = 4 -- Sets how many columns text is indented with the reindent operations
vim.opt.smarttab = true -- Uses the value of shiftwidth when inserting or deleting tabs
vim.opt.expandtab = true -- Tabs should be spaces by default
vim.api.nvim_set_keymap('n', '\\t', ':setlocal expandtab!<CR>', { noremap = true }) -- Change spaced tabs to actual tabs for current file only

-- Relative line numbers
vim.opt.number = true -- Shows absolute line number
vim.opt.relativenumber = true -- Shows relative line numbers
vim.api.nvim_set_keymap('n', '\\n', ':setlocal invrelativenumber<CR>', { noremap = true }) -- Toggle relative line number bar on/off

-- Search settings
vim.opt.incsearch = true -- Incremental search (i.e. search while typing)
vim.opt.hlsearch = true -- Highlights searched text
vim.opt.ignorecase = true -- Ignore case on searches
vim.opt.smartcase = true -- Override ignore case when search has uppercase in it
vim.api.nvim_set_keymap('n', '\\q', ':nohlsearch<CR>', { noremap = true }) -- Mapping to turn off highlighting

-- Status line
vim.opt.laststatus = 2 -- Always show the status line
vim.opt.statusline = '%<%f ' -- Tail of the filename with space after
vim.o.statusline = vim.o.statusline .. '%m' -- Modified flag
vim.o.statusline = vim.o.statusline .. '%r' -- Read only flag
vim.o.statusline = vim.o.statusline .. '%h ' -- Help flag
vim.o.statusline = vim.o.statusline .. '%= ' -- Left/right separator
vim.o.statusline = vim.o.statusline .. '[column:%c] ' -- Current column
vim.o.statusline = vim.o.statusline .. '[line:%l] ' -- Current line
vim.o.statusline = vim.o.statusline .. '[%p%%] ' -- Percentage through file

-- CtrlP settings
vim.g.ctrlp_max_files = 0
vim.g.ctrlp_max_depth = 30
vim.g.ctrlp_regexp = 1 -- Default to regexp search
vim.g.ctrlp_custom_ignore = [[\v[\/](target|build)$]] -- Ignore custom directories

-- Miscellaneous settings
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.cmd('syntax enable') -- Enable syntax highlighting
vim.cmd('filetype on') -- Enable filetype detection
vim.cmd('filetype plugin on') -- Enable filetype detection
vim.cmd('filetype plugin indent on') -- Enable filetype detection
vim.api.nvim_set_keymap('n', '<F12>', ':syntax enable<CR>', { noremap = true }) -- Hot key to enable syntax highlighting
vim.opt.autoread = true -- Auto-reload files that change on disk
vim.cmd('au CursorHold * checktime')
vim.cmd('highlight Pmenu ctermfg=blue ctermbg=white') -- Coloring for Pmenu (used in autocomplete)
vim.opt.maxmempattern = 2000000 -- Increase max memory for patterns because svgs are huge and cause vim to break
vim.opt.wrap = false -- Don't wrap lines because I hate that
vim.opt.hidden = true -- Only hide the file when switching buffers otherwise it will not retain its undo history
vim.api.nvim_set_keymap('n', '<F3>', ':NERDTreeToggle<CR>', { noremap = true }) -- Toggle NERDTree on and off
vim.opt.backspace = 'indent,eol,start' -- This makes backspace actually work in insert mode for some reason
vim.opt.colorcolumn = '81' -- Show colorcolumn -- lines of code should not be more than 80 characters
vim.cmd('highlight ColorColumn ctermbg=lightblue') -- Make the colorcolumn white
vim.opt.re = 0

-- Use system clipboard if available
if vim.fn.has("clipboard") then
    vim.opt.clipboard = 'unnamedplus'
end

-- Set background to dark
vim.opt.background = 'dark'

-- Toggle background between light and dark
local is_dark = true
function Toggle_background()
    if is_dark then
        vim.opt.background = 'dark'
        is_dark = false
    else
        vim.opt.background = 'light'
        is_dark = true
    end
end

vim.api.nvim_set_keymap('n', '\\b', ':lua Toggle_background()<CR>', { noremap = true })
