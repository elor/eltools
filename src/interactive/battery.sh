#!/bin/bash
#
# print current battery information

set -e -u

which upower &>/dev/null

batteries=$(upower -e | grep -i battery)

[ -n "$batteries" ] || { echo "no battery found">&2 ; exit 1; }

for battery in $batteries; do
    alldata=$(upower -i "$battery")
    [ -n "$alldata" ] || { echo "cannot read battery information">&2; continue; }

    state=$(grep 'state:' <<< "$alldata" | sed 's/^.*:\s*\(.*\S\)\s*$/\1/')
    percentage=$(grep 'percentage:' <<< "$alldata" | sed 's/^.*:\s*\(.*\S\)\s*$/\1/')
    rate=$(grep 'rate:' <<< "$alldata" | sed -e 's/^.*:\s*\(.*\S\)\s*$/\1/' -e 's/\s\s*/#/g')
    time=$(grep 'time' <<< "$alldata" | sed -e 's/^.*:\s*\(.*\S\)\s*$/\1/' -e 's/\s\s*/#/g')

    shortname=$(basename $battery)

    echo $shortname $state $percentage $rate $time

done | column -t | sed 's/#/ /g'
