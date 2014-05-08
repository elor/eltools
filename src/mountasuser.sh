#!/bin/bash
#
# mounts a device as $USER under /media/$USER/

printhelp(){
  cat >&2 << EOF
Syntax: `basename $0` <device>

Description:
  This script mounts a device with default options as the current user

Example:
  `basename $0` /dev/sdb1
EOF
}

if [ $USER == root ]; then
  cat >&2 << EOF
Cannot run this script as root. Use 'mount' instead.
EOF
  exit 1
fi

defaultdevice=/dev/sdb1

case "$1" in
  --help)
    ;;
  -h)
    ;;
  "")
    echo "No device supplied" >&2
    read -r -p "Which device? [$defaultdevice] " device
    [ -z "$device" ] && device=$defaultdevice
    ;;
  *)
    device="$1"
    ;;
esac

if ! [ -d /media ]; then
  cat >&2 << EOF
/media directory not found
EOF
  exit 1
fi

if ! [ -e "$device" ]; then
  echo "device $device does not exist" >&2
  exit 1
fi

if ! [ -b "$device" ]; then
  read -r -p "$device is no block device. Try anyway?" response
  case $response in
    yes|Yes|y|"")
      ;;
    *)
      exit 1
  esac
fi

fulldevice=$(dirname `readlink -f $device`/`basename $device`)
if [ -z "$fulldevice" ]; then
  echo "cannot find absolute path of $device" >&2
  exit 1
fi

oldpath=`mount | grep "^$fulldevice" | cut -d\  -f3 | xargs`

if [ -n "$oldpath" ]; then
  echo "$device ($fulldevice) is already mounted as:" >&2
  echo "  $oldpath" >&2
  exit 1
fi

# default to a random id
id=`sed -e 's \\\\ / g' -e 's ^/  g' -e 's / _ g' <<< $device`

if [ "`dirname "$device"`" == /dev ]; then
  uuid=`ls -l /dev/disk/by-uuid | grep "$(basename $device)$" | xargs | cut -d\  -f9`
  [ -n "$uuid" ] && id=$uuid
fi

targetdir=/media/$USER/$id

uid=`id -u`
gid=`id -g`

[ -z $uid ] && echo "error: 'id' shows no uid" >&2 && exit 1
[ -z $gid ] && echo "error: 'id' shows no gid" >&2 && exit 1

echo "mounting $device to $targetdir with ids: $uid:$gid"

# create the directory
if ! sudo mkdir -p $targetdir; then
  echo "mkdir failed for some strange reason" >&2
  exit 1
fi

# mount the device
if ! sudo mount "$device" "$targetdir" -o uid=$uid,gid=$gid; then
  echo "mount failed" >&2
  exit 1
fi

ln -si "$targetdir" "`basename "$targetdir"`"

echo "mount successful"

