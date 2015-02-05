#!/bin/bash
#
# displays a slideshow for i3 backgrounds

tmpfile=/tmp/e.lorenz_i3feh.pid
echo $$ > $tmpfile
while true;do
  [ $(cat $tmpfile) != $$ ] && break || feh --bg-max -z /home/e.lorenz/Documents/cheatsheets/*.{gif,png} || break
  sleep 300
done

