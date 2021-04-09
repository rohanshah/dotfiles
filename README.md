Rohan's Wonderful Dotfiles
=========================
Welcome to my Dotfile!

Vim packages are managed using [Pathogen](https://github.com/tpope/vim-pathogen)
and kept up-to-date using [`git submodules`](https://git-scm.com/book/en/v2/Git-Tools-Submodules).
You can add a new package with: `git submodule add`.

### How to remove submodules
```
$ git submodule deinit -f -- vim/bundle/submodule
$ rm -rf .git/modules/vim/bundle/submodule
$ git rm -f vim/bundle/submodule
```
