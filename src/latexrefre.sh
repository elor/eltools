#!/bin/bash

src="$1"
if [ -z "$src" ]; then
  echo "usage: $0 <input.tex>"
  exit
fi

gethash(){
  find . -name '*.tex' | xargs stat -c %y $f | md5sum
}

oldhash=""

while true; do
  ls > /dev/null || exit 1

  newhash=`gethash`

  if [ "$oldhash" != "$newhash" ]; then
    pdflatex --halt-on-error --interaction=nonstopmode "$src" 
    oldhash="$newhash"
  else
    if read -t 0; then
      read line
      oldhash=""
    else
      sleep 0.1
    fi
  fi

done

