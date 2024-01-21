# Cleanup.sh - Clean up your Git repositories

This is a script to interactively rebase all feature branches
and then safely get rid of them after they are fully merged.

## Usage

Inside the git repo:
```
bash ./cleanup.sh [branch...]
```

If `branch` is unspecified, the script operates on all branches
other than the main branch.

## Operation

The script goes branch by branch, and:

1. Displays the top commit of the branch, then asks whether to attempt
   a rebase of the branch. Say `y` to rebase, `n` to skip, `D` to force
   delete the branch.
2. Rebases the branch on top of the main branch. If the rebase fails,
   the script exits allowing you to fix conflicts and continue.
3. If rebase succeeds, it displays the new top commit of the branch,
   which will be the top commit of the main branch if the feature branch
   is obsolete. Say `y` to (safely) delete the feature branch, `n` to delete.

## Notes

The script assumes that the main remote is called `origin`, and the main
branch is either `master` or `main`.
