#!/bin/bash
#
# In a superdirectory of git directories, print all unstaged files, excluding
# untracked files (!)
# This is intended for code directories, which contain multiple projects

for dir in `find * -maxdepth 0 -type d`; do
    (
        cd $dir && git diff --name-only | sed 's/^/'"$dir"'\//'
    );
done
