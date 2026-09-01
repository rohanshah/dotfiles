# Shared shell configuration, sourced by BOTH zsh and bash.
# Keep this file free of shell-specific syntax (no zsh globs, no bashisms
# beyond arrays, which both shells handle identically for "${arr[@]}").

export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

##### PATH helpers #####

# Add a directory to PATH only if it exists and is not already present.
# Keeps PATH from growing every time a shell config is re-sourced.
path_prepend() {
  case ":$PATH:" in *":$1:"*) return 0 ;; esac
  [ -d "$1" ] || return 0
  PATH="$1:$PATH"
}

path_append() {
  case ":$PATH:" in *":$1:"*) return 0 ;; esac
  [ -d "$1" ] || return 0
  PATH="$PATH:$1"
}

##### PATH #####

# Homebrew: sets PATH, MANPATH, and the brew env vars. Handles both the
# Apple Silicon (/opt/homebrew) and Intel (/usr/local) prefixes.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export GOPATH="$HOME/go"

path_prepend "$HOME/.local/bin"
path_prepend "/opt/homebrew/opt/libpq/bin"
path_append  "/usr/local/sbin"
path_append  "$GOPATH/bin"
path_append  "$HOME/.cargo/bin"
path_append  "$HOME/.lmstudio/bin"

export PATH

##### Environment #####

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# -R keeps colors, -F quits on a single screen, -X leaves output on screen.
export LESS="-RFX"

# bash-only, harmless under zsh (zsh history options live in shell/zshrc).
export HISTCONTROL=ignoreboth:erasedups

##### Node (nvm) #####

# Lives here rather than in zshrc so `node` is available in bash too.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

##### Aliases, functions, and private overrides #####

. "$DOTFILES/shell/aliases.sh"
. "$DOTFILES/shell/functions.sh"

# Machine-local overrides. Sourced last so it can override anything above.
# Tracked but skip-worktree; see shell/local.sh.
[ -f "$DOTFILES/shell/local.sh" ] && . "$DOTFILES/shell/local.sh"
