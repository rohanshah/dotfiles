# Machine-local / work-specific zsh config.
#
# This file is TRACKED in git, but bootstrap.sh marks it skip-worktree so your
# edits never show up in `git status` and can never be committed by accident.
# Use it for zsh-only settings (setopt, zstyle, completion tweaks); anything
# that should also apply to bash belongs in shell/local.sh instead.
#
# If you ever need to change the committed skeleton itself:
#   git update-index --no-skip-worktree shell/local.zsh
#   ...edit and commit...
#   git update-index --skip-worktree shell/local.zsh

# export SOME_WORK_VAR="..."
