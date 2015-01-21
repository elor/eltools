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

if [ "`echo */.git`" != "*/.git" ]; then
    for dir in */.git; do
        (
            echo "=====     $PWD/`dirname "$dir"`    ====="
            cd "`dirname "$dir"`" && {
                for remote in `git remote`; do
                    echo "=====     `dirname "$dir"` ($remote)     ====="
                    git push --all $remote || error=true
                    git push $remote master --tags || error=true
                done
            }
        )
    done
fi

if [ "`echo */pushall.sh`" != "*/pushall.sh" ]; then
    for file in */pushall.sh; do
        ./pushall.sh `dirname $file` || error=true
    done
fi

# exit
$error && exit 1
