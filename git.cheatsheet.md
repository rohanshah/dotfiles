## Git Cheat Sheet

### Merging a branch off a branch into trunk (master)

Given branch B branched off branch A branched off master

git fetch # pull latest master locally
git rebase -i origin/master # exclude (skip or comment out) the commits that were from A, leaving only B's commits
git push origin branch --force # (optional) if branch exists remotely

#### Reference
https://stackoverflow.com/questions/34301568/git-branch-off-a-branch
