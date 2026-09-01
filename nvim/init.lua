-- Neovim Configuration
------------------------

require("claude_explain")

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
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local python_root_markers = {
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Pipfile",
  "pyrightconfig.json",
  "ruff.toml",
  ".ruff.toml",
  ".git",
}

local function python_root_dir(filename)
  if not filename or filename == "" then
    return vim.fn.getcwd()
  end
  return vim.fs.root(filename, python_root_markers) or vim.fn.getcwd()
end

local function executable_exists(executable_path)
  return executable_path ~= nil
    and executable_path ~= ""
    and vim.fn.executable(executable_path) == 1
end

local function find_project_executable(workspace, executable_names)
  local virtual_environment_names = { ".venv", "venv" }
  local executable_directories = { "bin", "Scripts" }

  for _, virtual_environment_name in ipairs(virtual_environment_names) do
    for _, executable_directory in ipairs(executable_directories) do
      for _, executable_name in ipairs(executable_names) do
        local executable_candidates = {
          vim.fs.joinpath(
            workspace,
            virtual_environment_name,
            executable_directory,
            executable_name
          ),
        }

        if not executable_name:match("%.exe$") then
          table.insert(
            executable_candidates,
            vim.fs.joinpath(
              workspace,
              virtual_environment_name,
              executable_directory,
              executable_name .. ".exe"
            )
          )
        end

        for _, executable_path in ipairs(executable_candidates) do
          if executable_exists(executable_path) then
            return executable_path
          end
        end
      end
    end
  end

  for _, executable_name in ipairs(executable_names) do
    local system_executable_path = vim.fn.exepath(executable_name)
    if executable_exists(system_executable_path) then
      return system_executable_path
    end
  end

  return executable_names[1]
end

local function find_python_path(workspace)
  return find_project_executable(workspace, { "python", "python3" })
end

local function find_ruff_path(workspace)
  return find_project_executable(workspace, { "ruff" })
end

function LspFormatBuffer()
  if vim.lsp.buf.format ~= nil then
    vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
  else
    vim.lsp.buf.formatting_sync(nil, 1000)
  end
end

local function ruff_fix_all()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.fixAll.ruff" },
    },
    apply = true,
  })
end

local function ruff_organize_imports()
  vim.lsp.buf.code_action({
    context = {
      only = { "source.organizeImports.ruff" },
    },
    apply = true,
  })
end

vim.api.nvim_create_user_command("RuffFixAll", ruff_fix_all, {})
vim.api.nvim_create_user_command("RuffOrganizeImports", ruff_organize_imports, {})

-- LSP navigation / inspection
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })

-- LSP refactors / fixes
vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })

-- Diagnostics
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Formatting / import maintenance
vim.api.nvim_set_keymap('n', 'ff', '<cmd>lua LspFormatBuffer()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rf', '<cmd>RuffFixAll<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>oi', '<cmd>RuffOrganizeImports<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})

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
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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

-- Resolve a Python project root for a given buffer (new-API root_dir form)
local function python_buf_root_dir(bufnr, on_dir)
  on_dir(python_root_dir(vim.api.nvim_buf_get_name(bufnr)))
end

-- Go settings
vim.lsp.config('gopls', {
  capabilities = capabilities,
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
vim.lsp.enable('gopls')

vim.lsp.config('ruff', {
  capabilities = capabilities,
  root_dir = python_buf_root_dir,
  cmd = function(dispatchers, config)
    local workspace = config.root_dir or vim.fn.getcwd()
    local ruff_path = find_ruff_path(workspace)
    return vim.lsp.rpc.start({ ruff_path, "server" }, dispatchers)
  end,
})
vim.lsp.enable('ruff')

vim.lsp.config('pyright', {
  capabilities = capabilities,
  root_dir = python_buf_root_dir,
  before_init = function(_, config)
    local workspace = config.root_dir or vim.fn.getcwd()
    local python_path = find_python_path(workspace)

    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = python_path
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        autoImportCompletions = true,
        indexing = true,
      },
    },
  },
})
vim.lsp.enable('pyright')

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
vim.opt.updatetime = 1000 -- Makes CursorHold fire after 1 second of inactivity instead of the default 4 seconds.
vim.cmd('au CursorHold * checktime')
vim.cmd('highlight Pmenu ctermfg=blue ctermbg=white') -- Coloring for Pmenu (used in autocomplete)
vim.opt.maxmempattern = 2000000 -- Increase max memory for patterns because svgs are huge and cause vim to break
vim.opt.wrap = false -- Don't wrap lines because I hate that
vim.opt.hidden = true -- Only hide the file when switching buffers otherwise it will not retain its undo history
vim.api.nvim_set_keymap('n', '<F3>', ':NERDTreeToggle<CR>', { noremap = true }) -- Toggle NERDTree on and off
vim.opt.backspace = 'indent,eol,start' -- This makes backspace actually work in insert mode for some reason
vim.wo.colorcolumn = '81' -- By default show colorcolumn -- lines of code should not be more than 80 characters
vim.cmd('highlight ColorColumn ctermbg=lightblue') -- Make the colorcolumn white
vim.opt.re = 0

-- Toggle colorcolumn on/off
function ToggleColorColumn()
  local current_value = vim.wo.colorcolumn
  if current_value == "" then
    vim.wo.colorcolumn = '81' -- lines of code should not be more than 80 characters
  else
    vim.wo.colorcolumn = ""
  end
end

vim.api.nvim_set_keymap('n', '\\c', ':lua ToggleColorColumn()<CR>', { noremap = true })

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
