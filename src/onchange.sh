#!/bin/bash

file=$1
shift
command="$@"

[ -z "$command" ] && command="$file"

if ! [ -f "$file" ] || [ -z "$command" ];then
  echo "syntax: $0 <filename> <command>"
  exit 1
fi

# can't figure out inotify just yet
if false && which inotifywait>/dev/null 2>/dev/null;then
  while true;do
    change=$(inotifywait -e close_write,moved_to,create $(dirname "$file"))
    echo $change
    if [ "`basename "$change"`" = "`basename "$file"`" ]; then
      $command
    fi
  done
else
  curdate=""

  while true;do
    newdate=`date -r "$file"`

    if [ "$curdate" != "$newdate" ];then

      set -- $command
      if [ -x "$1" ] || [ -x `which $1` ]; then
        echo
        echo "----- starting command -----"

        if $command; then
          echo
          echo "----- command finished -----"
        else
          echo -e "\n----- command failed: $? -----"
        fi

        curdate="$newdate"
      else
        echo "cannot execute $1 at the moment"
        sleep 1
      fi
    fi

    usleep 100000
  done
fi

