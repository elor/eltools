#!/bin/bash
# finds a port within range $1..$2
# $1 not set: start at 31159
# $2 not set: traverse whole range (upwards)

if [ -z "$1" ];then
  start=31159
else
  start=$1
fi

if [ -z "$2" ];then
  end=49151
else
  end=$2
fi

for port in `seq $start $end`;do
  if [ -z "`netstat -an | grep $port`" ];then
    echo $port
    exit 0
  fi
done

echo "no open port found in whole range" >&2

exit 1

