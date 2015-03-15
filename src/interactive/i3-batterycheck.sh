#!/bin/bash
#
# continuously check for battery status and show a nagbar if it's low

set -e -u

which upower &>/dev/null

nagbarpid=''
tolerance=10
interval=1

showwarning(){
    hidewarning

    batterystatus="(unknown, but low)"
    (( ${#@} > 0 )) && batterystatus="$1"

    i3-nagbar -m "Your battery is low. You have $batterystatus left before a hard shutdown" &

    nagbarpid=$!
}

hidewarning(){
    [ -n "$nagbarpid" ] && { kill $nagbarpid; nagbarpid=''; } || :
}

checkbattery(){
    hidewarning
    battery=$(upower -e | grep -i battery | head -1)

    [ -z "$battery" ] && return # no battery found. Must be a desktop PC

    timeleft=$(upower -i "$battery" | grep 'time to empty' | cut -d: -f2-)
    timeleft=$(echo $timeleft) # trim spaces

    [ -z "$timeleft" ] && return # not discharging. Must be plugged in.

    timeleft_minutes=$(grep -Po '[0-9]+(\.[0-9]*)\s*minutes' <<<"$timeleft" | sed -r 's/[a-z]+//') || :
    timeleft_seconds=$(grep -Po '[0-9]+(\.[0-9]*)\s*seconds' <<<"$timeleft" | sed -r 's/[a-z]+//') || :

    if [ -n "$timeleft_minutes" ]; then
        echo "bc <<< $timeleft_minutes < $tolerance"

        if [ "$(bc <<< "$timeleft_minutes < $tolerance ")" == 1 ]; then
            showwarning "$timeleft"
        fi
    elif [ -n "$timeleft_seconds" ] ; then
        showwarning "$timeleft"
    else
        # hours or days... nothing to worry about
        :
    fi
}

while true; do
    checkbattery
    sleep $((60*interval))
done
