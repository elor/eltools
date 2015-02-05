#!/bin/bash
#
# pull all

center(){
    local str="$1"
    local l=${#str}
    local h=$((l/2))
    local hwidth=10
    printf '=====%*s%-*s =====\n' $hwidth ${str:0:h} $hwidth ${str:h}
}

for dir in */;do 
    (
        cd "$dir" && {
            center `basename "$dir"`
	          branches=`git for-each-ref --shell --format='%(refname)' refs/heads/ | sed "s/'refs\/heads\/\(.*\)'/\1/"`
	          for branch in $branches; do
		            git checkout $branch >/dev/null
		            git pull --ff-only --all >/dev/null
	          done
        }
    )
done
