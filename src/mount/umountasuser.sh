#!/bin/bash
#
# mounts a device as $USER under /media/$USER/

printhelp(){
    cat >&2 <<EOF
Syntax: $(basename $0) <Link>

DESCRIPTION:

        Unmounts a usb drive, which has been mounted using mountasuser.sh.

ARGUMENTS:

        Link:

                The link to the mount point, as created by mountasuser.sh.

EOF
    exit 0
}

link="$1"
[ -z "$link" ] && printhelp
[ "$link" == "--help" ] && printhelp
[ "$link" == "-help" ] && printhelp
[ "$link" == "-h" ] && printhelp
[ "$link" == "--" ] && link="$2"
[ -z "$link" ] && printhelp
[ -L "$link" ] || { echo "$link is not a link">&2; exit 1; }
path="$(readlink -f "$link")"
[ -d "$path" ] || { echo "$path is not a directory">&2; exit 1; }
mount | grep "$path" &>/dev/null || { echo "$path is not mounted"; exit 1; }

echo -n "Unmounting $link ($path)... "

sudo umount $path || { echo "fail"; exit 1; }
echo "success"
echo -n "Removing $link... "
rm $link || { echo "fail"; exit 1; }
echo "success"

echo "$link has been unmounted and removed"
