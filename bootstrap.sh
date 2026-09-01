#!/usr/bin/env bash
#
# Set up this machine from the dotfiles repo.
#
#   ./bootstrap.sh            install and link everything
#   ./bootstrap.sh --dry-run  print what would happen, change nothing
#
# Safe to re-run: existing correct symlinks are left alone, and anything else
# occupying a target path is moved into ~/.dotfiles-backup/<timestamp>/ before
# being replaced. Nothing is ever overwritten in place.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
elif [[ $# -gt 0 ]]; then
  printf 'usage: %s [--dry-run]\n' "$0" >&2
  exit 2
fi

##### Output helpers #####

step() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '    \033[33mwarning:\033[0m %s\n' "$*" >&2; }

run() {
  if $DRY_RUN; then
    info "would run: $*"
  else
    "$@"
  fi
}

##### Symlinking #####

# back_up <path> — move an existing file/dir/symlink out of the way.
back_up() {
  local target="$1"
  if $DRY_RUN; then
    info "would back up $target -> $BACKUP_DIR/"
    return
  fi
  mkdir -p "$BACKUP_DIR"
  mv "$target" "$BACKUP_DIR/$(basename "$target")"
  info "backed up $target -> $BACKUP_DIR/$(basename "$target")"
}

# link <source-relative-to-repo> <target-absolute>
link() {
  local source="$DOTFILES/$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    warn "source missing, skipping: $source"
    return
  fi

  # Already pointing where we want it.
  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    info "ok       $target"
    return
  fi

  # A symlink somewhere else, or a real file/directory: preserve it first.
  if [[ -L "$target" || -e "$target" ]]; then
    back_up "$target"
  fi

  if $DRY_RUN; then
    info "would link $target -> $source"
  else
    mkdir -p "$(dirname "$target")"
    ln -sfn "$source" "$target"
    info "linked   $target -> $source"
  fi
}

# unlink_stale <path> — remove a symlink this repo no longer provides.
unlink_stale() {
  local target="$1"
  if [[ -L "$target" ]]; then
    if $DRY_RUN; then
      info "would remove stale symlink $target"
    else
      rm -f "$target"
      info "removed stale symlink $target"
    fi
  elif [[ -e "$target" ]]; then
    warn "$target exists but is not a symlink; leaving it alone"
  fi
}

##### 1. Homebrew and packages #####

step "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  if $DRY_RUN; then
    info "would install Homebrew"
  else
    info "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
else
  info "already installed: $(brew --version | head -1)"
fi

if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

step "Packages (Brewfile)"
if $DRY_RUN; then
  info "would run: brew bundle --file=$DOTFILES/Brewfile"
else
  # Non-fatal: a single unavailable formula (or an iTerm2 already installed by
  # hand, which makes the cask fail) must not stop the rest of the setup.
  if ! brew bundle --file="$DOTFILES/Brewfile"; then
    warn "brew bundle reported errors; continuing. Re-run it manually to inspect:"
    warn "  brew bundle --file=$DOTFILES/Brewfile"
  fi
fi

##### 2. Symlinks #####

step "Linking dotfiles into \$HOME"
link shell/zshrc          "$HOME/.zshrc"
link shell/bash_profile   "$HOME/.bash_profile"
link git/gitconfig        "$HOME/.gitconfig"
link git/gitignore_global "$HOME/.gitignore"
link tmux/tmux.conf       "$HOME/.tmux.conf"
link nvim                 "$HOME/.config/nvim"

step "Removing links from the old layout"
unlink_stale "$HOME/.vim"
unlink_stale "$HOME/.vimrc"
unlink_stale "$HOME/.bash_aliases"
unlink_stale "$HOME/.git-completion.bash"

##### 3. Machine-local shell config #####

step "Machine-local shell config"
# shell/local.sh and shell/local.zsh are committed as empty skeletons so they
# exist on a fresh clone. skip-worktree tells git to ignore every later edit,
# so secrets you put in them can never be staged or committed. The flag is
# per-clone index state and does NOT come down with the repo, which is exactly
# why it has to be applied here on every new machine.
for local_file in shell/local.sh shell/local.zsh; do
  if ! git -C "$DOTFILES" ls-files --error-unmatch "$local_file" >/dev/null 2>&1; then
    warn "$local_file is not tracked yet; commit it before it can be marked skip-worktree"
    continue
  fi

  if git -C "$DOTFILES" ls-files -v "$local_file" | grep -q '^S'; then
    info "ok       $local_file already skip-worktree"
  elif $DRY_RUN; then
    info "would mark $local_file skip-worktree"
  else
    git -C "$DOTFILES" update-index --skip-worktree "$local_file"
    info "marked   $local_file skip-worktree (local edits now invisible to git)"
  fi

  $DRY_RUN || chmod 600 "$DOTFILES/$local_file"
done

##### 3. Language servers not covered by Homebrew #####

step "Language servers"
if command -v gopls >/dev/null 2>&1; then
  info "ok       gopls ($(command -v gopls))"
elif command -v go >/dev/null 2>&1; then
  run go install golang.org/x/tools/gopls@latest
else
  warn "go not available; skipping gopls"
fi

if command -v pyright-langserver >/dev/null 2>&1; then
  info "ok       pyright-langserver ($(command -v pyright-langserver))"
elif command -v npm >/dev/null 2>&1; then
  run npm install -g pyright
else
  warn "npm not available; skipping pyright"
fi

if command -v ruff >/dev/null 2>&1; then
  info "ok       ruff ($(command -v ruff))"
else
  warn "ruff missing; nvim's ruff LSP will fail to spawn (brew install ruff)"
fi

##### 4. Neovim plugins #####

step "Neovim plugins"
if $DRY_RUN; then
  info "would run: nvim --headless \"+Lazy! restore\" +qa"
else
  # `restore` installs the exact commits in nvim/lazy-lock.json, rather than
  # whatever each plugin's HEAD happens to be today.
  nvim --headless "+Lazy! restore" +qa
  printf '\n'
  info "plugins installed at the versions pinned in nvim/lazy-lock.json"
fi

##### 5. Manual steps #####

step "Done — two things left to do by hand"
cat <<'NOTE'
    1. iTerm2 profile
       Preferences -> Profiles -> Other Actions -> Import JSON Profiles
       and choose iterm2/profile.json.

       The profile carries the Solarized ANSI palette and Monaco 12. Neovim
       runs with termguicolors off and uses those 16 terminal colors, so the
       colorscheme will look wrong until this profile is active.

    2. Restart your shell
       exec zsh -l

    If you are migrating an existing machine, the old vim-plug tree is now
    unused and can be removed:
       rm -rf ~/.local/share/nvim/site/autoload/plug.vim ~/.local/share/nvim/plugged
NOTE
