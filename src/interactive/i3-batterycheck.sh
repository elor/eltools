#!/bin/bash
#
# continuously check for battery status and show a nagbar if it's low

set -e -u

which upower &>/dev/null

nagbarpid=''
tolerance=10
interval=1

showwarning(){
    batterystatus="(unknown, but low)"
    (( ${#@} > 0 )) && batterystatus="$1"

    [ -n "$nagbarpid" ] && { kill $nagbarpid; nagbarpid=''; }

    i3-nagbar -m "Your battery is low. You have $batterystatus left before a hard shutdown" &

    nagbarpid=$!
}

checkbattery(){
    battery=$(upower -e | grep -i battery | head -1)

    [ -z "$battery" ] && return # no battery found. Must be a desktop PC

    timeleft=$(upower -i "$battery" | grep 'time to empty' | cut -d: -f2-)
    timeleft=$(echo $timeleft) # trim spaces

    [ -z "$timeleft" ] && return # not discharging. Must be plugged in.

    timeleft_minutes=$(grep -Po '[0-9]+(\.[0-9]*)' <<<"$timeleft")

    [ -z "$timeleft_minutes" ] && return; # formatting error.
    # I will know that something is wrong when the pc shuts down spontaneously

    if [ $(bc <<< "$timeleft_minutes < $tolerance ") == 1 ]; then
        showwarning "$timeleft"
    fi
}

while true; do
    checkbattery
    sleep $((60*interval))
done
