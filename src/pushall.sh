#!/bin/bash
#
# pushes all repos to all remotes

for dir in */.git; do
  pushd $dir>/dev/null
  for remote in `git remote`; do
    echo "$PWD $remote"
    git push --all $remote
  done
  popd>/dev/null
done

for file in */pushall.sh; do
  pushd `dirname $file`
  ./pushall.sh
  popd
done

