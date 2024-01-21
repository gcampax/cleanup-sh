#!/bin/bash

set -e
#set -x
set -o pipefail

if git rev-parse master 2>&1 >/dev/null ; then
	main_branch=master
else
	main_branch=main
fi

branch=${1:-$(git for-each-ref --format '%(refname)')}

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
	git rebase origin/$main_branch
	git log -1
	echo "delete? "
	read delete
	if test $delete != 'y' ; then
		continue
	fi
	git checkout $main_branch
	git branch -d "$b"
done
