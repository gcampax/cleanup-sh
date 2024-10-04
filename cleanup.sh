#!/bin/bash

set -e
#set -x
set -o pipefail

if git rev-parse master 2>&1 >/dev/null ; then
	main_branch=master
else
	main_branch=main
fi

branch=${1:-$(git for-each-ref --format '%(refname)' refs/heads/)}

on_rebase_fail() {
	echo "rebase failed, abort?"
	read abort
	if test $abort == 'y' ; then
		git rebase --abort
		echo "rebase aborted"
		return
	else
		echo "please fix the merge failure and continue the rebase"
		echo "press any key to continue"
		read
	fi
}


git checkout $main_branch
for b in $branch ; do
	b=$(sed -E 's|refs/heads/?||' <<<"$b")
	if test "$b" = $main_branch ; then
		continue
	fi
	git checkout "$b"
	git log -1
	echo "rebase? "
	read rebase
	if test $rebase == 'D' ; then
		echo "Force deleting ${b} ..."
		git checkout $main_branch
		git branch -D "$b"
		continue
	fi
	if test $rebase != 'y' ; then
		continue
	fi
	if git rebase origin/$main_branch ; then
		git log -1
		echo "delete? "
		read delete
		if test $delete != 'y' ; then
			continue
		fi
		git checkout $main_branch
		git branch -d "$b"
	else
		on_rebase_fail
	fi
done
