#!/bin/bash

[ $1 ] && src="$1" || src="`grep -l \\documentclass *.tex`"
if [ -z "$src" ]; then
    echo "usage: $0 <input.tex>"
    exit
fi

gethash(){
    # find file changes by date
	  find . -name '*.tex' -o -name '*.pdf_tex' -o -name '*.sty' -o -name '*.bib' | grep -v '#' | xargs stat -c %y | md5sum
    # find file changes by content (table of contents and stuff), for second pass, e.g. after a failure
    find . -name '*.toc' -o -name '*.loa' -o -name '*.lof' -o -name '*.lot' | xargs cat | md5sum
}

senderror(){
	  if type notify-send &>/dev/null; then
		    notify-send -t 1000 "latexrefre.sh: $@"
	  else
		    echo "couldn't find'notify-send'"
	  fi

	  echo "$@" >&2
}

oldhash=""

colorize(){
    sed -e "s/^!.*\|^l.[0-9]\+\s.*\|error\|overfull\|undefined\|warning/\x1b[7m&\x1b[0m/gi"
}

while true; do
    sync

    newhash=`gethash`

    if [ "$oldhash" != "$newhash" ]; then
        pdflatex --halt-on-error --interaction=nonstopmode "$src" | colorize || senderror 'pdflatex failed'
        echo
        echo "Your options:"
        echo "[Enter]: manually restart"
        echo "[Ctrl+C]: quit"
        echo
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

