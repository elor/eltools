#!/bin/bash
#
# fetch branches and tags (for bare git repos)

noremote=""

for dir in *.git; do
		remote=`git --git-dir="$dir" remote`
		[ -z "$remote" ] && { noremote="$noremote $dir"; continue; }
    echo "===== $dir ====="
		(( `wc -w <<< "$remote"` == 1 )) || { echo "invalid number of remoted">&2; continue; }
		git --git-dir="$dir" fetch $remote +refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* -v
done

[ -n "$noremote" ] && { echo; echo "===== NO REMOTES ====="; }
xargs -n1 <<< $noremote

[ */fetchall.sh == "*/fetchall.sh" ] && exit

echo
echo "========== subdirectories =========="
echo


for subdir in */fetchall.sh; do
		[ "$subdir" == '*/fetchall.sh' ] && { echo "no subdirectories found">&2; break; }
    (
				echo "===== entering `dirname $subdir` ====="
        cd `dirname "$subdir"` || continue
        ./fetchall.sh
				echo "===== leaving $subdir ====="
    )
done
