#!/bin/bash
#
#PBS -l nodes=1:ppn=1
#PBS -m ae
#
# compresses the current folder into a .tar.xz file

[ -n "$PBS_O_WORKDIR" ] && cd "$PBS_O_WORKDIR"

foldername="`basename $PWD`"
archivename="$foldername.tar.xz"

cd ..

[ -d "$foldername" ] || { echo "$foldername is not a directory">&2; exit 1; }
[ -n "$archivename" ] || { echo "\$archivename is empty">&2; exit 1; }

time tar c "$foldername" | xz -9ec - > "$archivename" || exit 1

cat <<EOF

Sizes:

`du -h --apparent-size --max-depth=0 "$foldername" "$archivename"`

$PWD/$foldername has been successfully compressed to $PWD/$archivename

EOF

