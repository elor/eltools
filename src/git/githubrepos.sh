#!/bin/bash
#
# Erik E. Lorenz <erik.e.lorenz@gmail.com>
# Github API version from Thu May  8 13:25:40 CEST 2014

printhelp(){
  cat >&2 <<EOF
syntax: `basename $0` <github username>

This script prints all publicly visible repositories of a github user
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

user="$1"

curl -is https://api.github.com/users/$user/repos | grep full_name | sed -n 's_^.*"\([^/"]*/[^"/]*\)".*$_\1_p'

