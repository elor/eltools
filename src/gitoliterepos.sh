#!/bin/bash
#
# Erik E. Lorenz <erik.e.lorenz@gmail.com>

printhelp(){
  cat >&2 <<EOF
syntax: `basename $0` <gitolite@host>

This script prints all readable gitolite repositories of the currently logged in user
EOF
  exit 1
}

case $1 in
  --help)
    printhelp
    ;;
  -h)
    printhelp
    ;;
  "")
    printhelp
    ;;
esac

address="$1"

ssh $address 2>/dev/null | sed -n 's_\s*.*R.*\s\+\(.\+\)\s*$_\1_p'

