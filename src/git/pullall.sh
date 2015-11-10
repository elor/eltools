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
            branches=`git for-each-ref --shell --format='%(refname)' refs/heads/ | sed "s/'refs\/heads\/\(.*\)'/\1/"
`
            git fetch --all
            for branch in $branches; do
                for remote in $(git remote); do
                    if [ "$(git rev-parse $branch)" != "$(git rev-parse $remote/$branch)" ]; then
                        git checkout $branch >/dev/null
                        git merge --ff-only $remote/$branch
                    else
                        echo "already up-to-date with $remote/$branch"
                    fi
                done
            done
        }
    )
done
