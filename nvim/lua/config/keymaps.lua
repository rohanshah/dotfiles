-- Non-LSP keymaps. (LSP keymaps live in config/lsp.lua, next to the servers
-- they drive; completion keymaps live in config/cmp.lua.)

-- Disable arrow keys in normal mode
vim.api.nvim_set_keymap('n', '<up>', '<nop>', { noremap = true }) -- Disable up arrow
vim.api.nvim_set_keymap('n', '<down>', '<nop>', { noremap = true }) -- Disable down arrow
vim.api.nvim_set_keymap('n', '<left>', '<nop>', { noremap = true }) -- Disable left arrow
vim.api.nvim_set_keymap('n', '<right>', '<nop>', { noremap = true }) -- Disable right arrow

-- Toggles
vim.api.nvim_set_keymap('n', '\\t', ':setlocal expandtab!<CR>', { noremap = true }) -- Change spaced tabs to actual tabs for current file only
vim.api.nvim_set_keymap('n', '\\n', ':setlocal invrelativenumber<CR>', { noremap = true }) -- Toggle relative line number bar on/off
vim.api.nvim_set_keymap('n', '\\q', ':nohlsearch<CR>', { noremap = true }) -- Mapping to turn off highlighting

-- Function keys
vim.api.nvim_set_keymap('n', '<F12>', ':syntax enable<CR>', { noremap = true }) -- Hot key to enable syntax highlighting
vim.api.nvim_set_keymap('n', '<F3>', ':NERDTreeToggle<CR>', { noremap = true }) -- Toggle NERDTree on and off

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

