# Rohan's Wonderful Dotfiles
My personal configuration and tooling for neovim, tmux, bash & zsh, git, macOS and iTerm2.

## Install (macOS)

```bash
git clone git@github.com:rohanshah/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

- installs Homebrew (if missing) and the Brewfile
- symlinks configs into `$HOME`
- installs language servers and neovim plugins

`bootstrap.sh` is idempotent in that re-running it will maintain whatever is already correct.
However, anything that would get overwritten or disturbed by a fresh install is
moved to `~/.dotfiles-backup/<timestamp>/`. Use `--dry-run` to show what actions
it would perform.

### Manual Steps
1. **Import the iTerm2 profile.** Under (Preferences / Profiles / Other Actions /
   Import JSON Profiles) import `iterm2/profile.json`. **Note:** neovim runs with
   `termguicolors` off and uses the terminal's 16 colors so solarized does not work without this step.
2. **`exec zsh -l`** to pick up the new shell.

### Updating
- nvim plugins: `:Lazy sync`, then commit `lazy-lock.json`.
- Brew packages: edit `Brewfile`, then `brew bundle --file=Brewfile`.

## Local-only (e.g. work-related) configuration

`shell/local.sh` (both bash & zsh) and `shell/local.zsh` (zsh only) hold anything
that shouldn't be public or committed. The files are committed as empty skeletons so they
exist on `git clone`. Bootstrap runs: `git update-index --skip-worktree shell/local.sh shell/local.zsh`
which tells git the files never change. Any edits stay out of `git status`.

To edit and commit changes to these files, or `git pull` remote changes made
to these files:

```bash
git update-index --no-skip-worktree shell/local.sh
# edit & commit or git pull
git update-index --skip-worktree shell/local.sh
```

Use `git ls-files -v shell/ | grep '^S'` to show what files are flagged.

## Cheatsheets
```
cheat
cheat <topic>
```
The `cheat` command lists topics based on the files in `cheatsheets/`. Each topic
is backed by a vanilla markdown file that lists out common key-bindings, commands,
and workflows I use often but not often enough to memorize.
