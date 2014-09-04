#!/bin/bash

[ $1 ] && src="$1" || src="masterthesis.tex"
if [ -z "$src" ]; then
    echo "usage: $0 <input.tex>"
    exit
fi

gethash(){
	  find . -name '*.tex' -o -name '*.pdf_tex' | grep -v '#' | xargs stat -c %y | md5sum
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
    ls > /dev/null || exit 1

    newhash=`gethash`

    if [ "$oldhash" != "$newhash" ]; then
        pdflatex --halt-on-error --interaction=nonstopmode "$src" | colorize || senderror 'pdflatex failed'
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

