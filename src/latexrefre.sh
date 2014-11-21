#!/bin/bash

showmishaps=true

if [ "$1" == '--nomishaps' ];then
    showmishaps=false
    shift
fi

[ $1 ] && src="$1" || src="`grep -l \\documentclass *.tex`"
if [ -z "$src" ]; then
    echo "usage: $0 <input.tex>"
    exit
fi

gethash(){
    # find file changes by date
	  find . -name '*.tex' -o -name '*.pdf_tex' -o -name '*.sty' -o -name '*.bib' -o -name '*.bst' | grep -v '#' | xargs stat -c %y | md5sum
    # find file changes by content (table of contents and stuff), for second pass, e.g. after a failure
    find . -name '*.toc' -o -name '*.loa' -o -name '*.lof' -o -name '*.lot' | xargs cat | md5sum
}

auxhash(){
    find . -name '*.aux' | grep -v '#' | xargs md5sum
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
    sed -r -e "s/^!.*|^l.[0-9]+\s.*|error|overfull|undefined|warning|multipl[ey]/\x1b[7m&\x1b[0m/gi"
}

copybak(){
    base="$1"
    cp -v "$base.pdf" "${base}_bak.pdf"
}

listmultiple(){
    base="$1"
    
    multiple=$(grep -i 'multipl[ey]' "$base".log | sed -r -n "s/^[^\`]*\`([^']+)'.*$/\1/p")
    if [ -n "$multiple" ]; then
        cat <<EOF

multiple labels:
$multiple
EOF
    fi
}

listundefined(){
    base="$1"
    
    undefined=$(grep -i undefined "$base".log | sed -r -n "s/^[^\`]*\`([^']+)'.*$/\1/p")
    if [ -n "$undefined" ]; then
        cat <<EOF

undefined references and citations:
$undefined
EOF
    fi
}

base=`basename "$src" .tex`

while true; do
    sync

    newhash=`gethash`

    if [ "$oldhash" != "$newhash" ]; then
        
        timebefore=`date +%s%N`

        if pdflatex --halt-on-error --interaction=nonstopmode "$src" | colorize; then
            auxhashbefore=`auxhash`
            bibtex $base.aux

            copybak "$base"

            if $showmishaps; then
                listmultiple "$base" | colorize
                listundefined "$base" | colorize
            fi

            if [ "$auxhashbefore" != "`auxhash`" ]; then
                newhash=""
            fi

            timeafter=`date +%s%N`

            let runtime=timeafter-timebefore

            echo "runtime: $runtime" | sed -r 's/([0-9]{3})([0-9]{6})$/.\1 s/'

        else
            senderror 'pdflatex failed'
        fi

        cat <<EOF

"Your options:"
"[Enter]: manually restart"
"[Ctrl+C]: quit"

EOF
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
