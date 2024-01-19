Rohan's Wonderful Dotfiles
=========================
Welcome to my Dotfile!

Vim packages are managed using [Pathogen](https://github.com/tpope/vim-pathogen)
and kept up-to-date using [`git submodules`](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
You can add a new package with: `git submodule add`.

### How to install
1. Install brew, nvim, node/npm, iTerm2
2. Import `iterm2/profile.json` into iTerm2
3. Run the install script
```
$ ./install
```
4. Open `nvim` and run:
```
:PlugInstall
```

### How to remove submodules
```
$ git submodule deinit -f -- vim/bundle/submodule
$ rm -rf .git/modules/vim/bundle/submodule
$ git rm -f vim/bundle/submodule
```
