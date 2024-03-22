## Git Cheat Sheet

### Merging a branch off a branch into trunk (master)

Given branch B branched off branch A branched off master

git fetch # pull latest master locally
git rebase -i origin/master # exclude (skip or comment out) the commits that were from A, leaving only B's commits
git push origin branch --force # (optional) if branch exists remotely

#### Reference
https://stackoverflow.com/questions/34301568/git-branch-off-a-branch

### Removing untracked files and directories

After committing only tracked changes you'll be left with untracked files and directories.
If you want to remove these you can use

git clean (optionally with -fdx)

-f : force
-d : include directories
-x : remove ignored files (don't use this if you want to keep your local .gitignore files)

### Only stage modified and deleted files

If you have a diff with both tracked and untracked changes (changes to existing files
and changes to new files, respectively) and you only want to stage (git add ) the
tracked changes but don't want to use `git add -p` to go through the diff.

git add -u
