#!/bin/bash

if [ -z "$1" ]; then
  filename="$HOME/screenshot.jpg"
else
  filename="$1"
fi

if [ -z "$DISPLAY" ];then
  echo "no X11 display found (\$DISPLAY not set)" >&2
  exit 1
fi

echo "click on the window to capture"

winid=`xwininfo | sed -n 's/^.*Window id: \(0x[0-9a-f]*\) .*$/\1/p'`

if [ -z "$winid" ]; then
  echo "no window id found" >&2
  exit 2
fi

if import -display $DISPLAY -window $winid "$filename" ; then
  echo "image saved to $filename"
else
  echo "error while capturing or saving" >&2
fi


