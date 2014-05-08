#!/bin/bash
#
# pull all

for dir in */;do 
	pushd $dir
	branches=`git for-each-ref --shell --format='%(refname)' refs/heads/ | sed "s/'refs\/heads\/\(.*\)'/\1/"`
	for branch in $branches; do
		git checkout $branch >/dev/null
		git pull --ff-only --all >/dev/null
	done
	popd
done

