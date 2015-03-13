#!/bin/bash
#
# print current battery information

set -e -u

which upower &>/dev/null

battery=$(upower -e | grep -i battery | head -1)

[ -n "$battery" ] || { echo "no battery found">&2 ; exit 1; }

alldata=$(upower -i "$battery")
[ -n "$alldata" ] || { echo "cannot read battery information">&2; exit 1; }

grep 'state:' <<< "$alldata" || :
grep 'rate:' <<< "$alldata" || :
grep 'capacity:' <<< "$alldata" || :
grep 'time' <<< "$alldata" || :
