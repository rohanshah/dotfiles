# Machine-local / work-specific shell config, shared by zsh and bash.
#
# This file is TRACKED in git, but bootstrap.sh marks it skip-worktree so your
# edits never show up in `git status` and can never be committed by accident.
# Put secrets, work-only exports, and per-machine paths here.
#
# If you ever need to change the committed skeleton itself:
#   git update-index --no-skip-worktree shell/local.sh
#   ...edit and commit...
#   git update-index --skip-worktree shell/local.sh

# export SOME_API_TOKEN="..."
# path_prepend "$HOME/some/work/bin"
