#!/bin/bash
# 
# starts quicksynergy and uses xdotool to 

type xwininfo >/dev/null || exit 1
type xdotool >/dev/null || exit 1
type sed >/dev/null || exit 1
type quicksynergy >/dev/null || exit 1

quicksynergy &>/dev/null &

winid=''
while [ -z "$winid" ]; do
  sleep 0.1
  winid=`xwininfo -name QuickSynergy | sed -n 's/^.*Window id:\s*\(0x[0-9a-fA-F]*\).*$/\1/p'`
  echo "winid: '$winid'"
done

xdotool key --window $winid alt+e


