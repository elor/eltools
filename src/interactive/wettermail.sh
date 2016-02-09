#!/bin/bash
#
# prepare a german weather mail

set -e -u

if (( ${#@} != 1 )); then
    echo "syntax: $(basename $0) mail@address.com" >&2
    exit 1
fi

recipient="$1"
subject="Wetterbericht $(date +%F)
Content-Type: text/html"

mail -s "$subject" $recipient <<< '<img src="http://www.wetterzentrale.de/pics/MS_128508_wrf.png" />'
