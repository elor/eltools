#!/bin/bash
#
# counts the number of colored and grey pages

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ -z "$1" ]; then
    shift
    cat <<EOF
`basename $0` [OPTIONS] file.pdf...

DESCRIPTION

  counts the number of colored and grey (black/white) pages in pdf files

OPTIONS

  --help, -h:
    show this message

  --list, -l:
    list every page in the document, not just a summary

NOTE

  There is no special exit code on error, so please verify that the file is valid before using this script.

EOF
    exit
fi

getlines(){
    local file="$1"
    local log=/tmp/elor_ghostscript$$.log
    gs -o - -sDEVICE=inkcov "$file" | tee "$log" \
        | grep -iP '^\s*[0-9.]+\s+[0-9.]+\s+[0-9.]+\s+[0-9.]+\s+[A-Z]+\s+[A-Z]+\s*$' \
        | awk '{if ($1!=0 || $2 != 0 || $3 != 0) {print "color",NR} else {print "grey",NR} fi}'
    grep -iP "warning|undefined|unknown|error" "$log" >&2
    rm -f "$log" &>/dev/null
}

counttypes(){
    awk '{print $1;print "total"}' | sort | uniq -c
}

listtypes(){
    awk '{print $2,$1}' | column -t
}

if [ "$1" == "--list" ] || [ "$1" == "-l" ]; then
    shift
    for file; do
        echo "$file"
        getlines "$file" | listtypes
    done
else
    for file; do
        echo "$file"
        getlines "$file" | counttypes
    done
fi
