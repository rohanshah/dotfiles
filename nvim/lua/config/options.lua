-- Editor options. Loaded after lazy.nvim has set up plugins, because the
-- colorscheme at the bottom needs vim-colors-solarized on the runtimepath.

-- Tab settings
vim.opt.autoindent = true -- Uses indent from the current line as indent for new line
vim.opt.tabstop = 4 -- Sets how many columns a tab counts for
vim.opt.shiftwidth = 4 -- Sets how many columns text is indented with the reindent operations
vim.opt.smarttab = true -- Uses the value of shiftwidth when inserting or deleting tabs
vim.opt.expandtab = true -- Tabs should be spaces by default

-- Relative line numbers
vim.opt.number = true -- Shows absolute line number
vim.opt.relativenumber = true -- Shows relative line numbers

-- Search settings
vim.opt.incsearch = true -- Incremental search (i.e. search while typing)
vim.opt.hlsearch = true -- Highlights searched text
vim.opt.ignorecase = true -- Ignore case on searches
vim.opt.smartcase = true -- Override ignore case when search has uppercase in it

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

-- Miscellaneous settings
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.cmd('syntax enable') -- Enable syntax highlighting
vim.cmd('filetype on') -- Enable filetype detection
vim.cmd('filetype plugin on') -- Enable filetype detection
vim.cmd('filetype plugin indent on') -- Enable filetype detection
vim.opt.autoread = true -- Auto-reload files that change on disk
vim.opt.updatetime = 1000 -- Makes CursorHold fire after 1 second of inactivity instead of the default 4 seconds.
vim.cmd('au CursorHold * checktime')
vim.cmd('highlight Pmenu ctermfg=blue ctermbg=white') -- Coloring for Pmenu (used in autocomplete)
vim.opt.maxmempattern = 2000000 -- Increase max memory for patterns because svgs are huge and cause vim to break
vim.opt.wrap = false -- Don't wrap lines because I hate that
vim.opt.hidden = true -- Only hide the file when switching buffers otherwise it will not retain its undo history
vim.opt.backspace = 'indent,eol,start' -- This makes backspace actually work in insert mode for some reason
vim.wo.colorcolumn = '81' -- By default show colorcolumn -- lines of code should not be more than 80 characters
vim.cmd('highlight ColorColumn ctermbg=lightblue') -- Make the colorcolumn white
vim.opt.re = 0

-- Use system clipboard if available
if vim.fn.has("clipboard") then
    vim.opt.clipboard = 'unnamedplus'
end

-- Use the terminal's 16 ANSI colors (iTerm2's Solarized palette) instead of
-- nvim's built-in truecolor palette. vim-colors-solarized is a cterm-based
-- scheme that relies on this; newer nvim auto-enables termguicolors otherwise.
vim.opt.termguicolors = false

-- Set background to dark
vim.opt.background = 'dark'

-- Apply the Solarized colorscheme (relies on iTerm2 Solarized ANSI palette)
vim.g.solarized_termcolors = 16
vim.cmd('colorscheme solarized')

local autoreload_group = vim.api.nvim_create_augroup("autoreload_files", {
  clear = true,
})

vim.api.nvim_create_autocmd({
  "FocusGained",
  "BufEnter",
  "CursorHold",
  "CursorHoldI",
}, {
  group = autoreload_group,
  pattern = "*",
  callback = function()
    vim.cmd("silent checktime")
  end,
})
