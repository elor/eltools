#!/bin/bash

tmpfile=/tmp/elorqueue.pid

reserve(){
  echo $$ > "$tmpfile"
}

waitpid(){
  while [ -d /proc/$1 ]; do sleep 1; done
}

freepids(){
  [ -f "$tmpfile" ] && [ "`cat "$tmpfile"`" == $$ ] && rm "$tmpfile"
}

getpid(){
  cat "$tmpfile"
}

cmd="${@}"
#if [ ! -x "$cmd" ] && [ ! -x "`which "$cmd"`" ];then
#  echo "not executable"
#  exit 1
#fi

if [ -f "$tmpfile" ]; then
  pid=`getpid`
  reserve
  waitpid $pid
else
  reserve
fi

bash -c "$cmd"

freepids

