#!/bin/bash

src="$1"
if [ -z "$src" ]; then
  echo "usage: $0 <input.tex>"
  exit
fi

gethash(){
  for f in *.tex */*.tex; do
    echo "$f `date --reference $f`"
  done | md5sum
}

oldhash=""

while true; do
  ls > /dev/null

  newhash=`gethash`

  if [ "$oldhash" != "$newhash" ]; then
    pdflatex --halt-on-error --interaction=nonstopmode "$src" 
    oldhash="$newhash"
  else
    if read -t 0; then
      read line
      oldhash=""
    else
      usleep 100000
    fi
  fi

done

