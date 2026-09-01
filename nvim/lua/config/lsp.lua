-- LSP: capabilities, Python interpreter/root resolution, keymaps, and the
-- gopls / ruff / pyright server definitions.
--
-- Uses the nvim 0.11+ `vim.lsp.config()` + `vim.lsp.enable()` API. The older
-- `lspconfig.<server>.setup()` form was removed. nvim-lspconfig is still a
-- dependency: it ships the per-server defaults (cmd, filetypes, root_markers)
-- that these definitions layer on top of.

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
