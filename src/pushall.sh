#!/bin/bash
#
# pushes all repos to all remotes

error=false

srcdir=`dirname $0`
if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    srcdir="$1"
  else
    echo "argument is no directory: '$1'" >&2
    exit 1
  fi
fi

cd "$srcdir"

[ "`echo */.git`" != "*/.git" ] && for dir in */.git; do
  cd "$dir/.." || continue
  for remote in `git remote`; do
    echo "$dir $remote"
    git push --all $remote || error=true
  done
  cd -
done

[ "`echo */pushall.sh`" != "*/pushall.sh" ] && for file in */pushall.sh; do
  ./pushall.sh `dirname $file` || error=true
done

$error && exit 1

