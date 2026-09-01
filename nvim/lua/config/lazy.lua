-- Bootstrap lazy.nvim, then install the plugins from lua/plugins.lua.
-- Clones lazy.nvim on first launch, so a fresh machine needs no manual step
-- (this replaces vim-plug, which required running :PlugInstall by hand).

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { output, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"), {
  -- Where the committed lockfile lives, relative to this config directory.
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  install = { colorscheme = { "solarized" } },
  change_detection = { notify = false },
  -- No plugin here needs luarocks; disabling it keeps :checkhealth clean.
  rocks = { enabled = false },
  ui = { border = "rounded" },
})
