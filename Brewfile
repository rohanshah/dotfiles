# Prerequisites installed by bootstrap.sh via `brew bundle`.

# --- Core environment ---
brew "neovim"        # the editor everything here is built around
brew "tmux"
brew "git"           # Apple's git is old; gitconfig uses fetch.all (needs 2.41+)

# --- CLI tools the shell config depends on ---
brew "grep"          # GNU grep as `ggrep`; g()/noascii() need -P perl regexp
brew "coreutils"
brew "jq"            # pj()
brew "pandoc"        # md()
brew "pwgen"         # `password`
brew "ripgrep"
brew "fzf"
brew "less"

# --- Language servers and toolchains ---
brew "go"            # also provides the toolchain for gopls
brew "ruff"          # nvim configures the ruff LSP; without this it fails to spawn
brew "node"          # fallback if nvm is not in use
brew "libpq"         # psql client, referenced on PATH

# --- Apps ---
cask "iterm2"
