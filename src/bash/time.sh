#!/bin/bash
#
# similar to `time`, but with date nanosecond accuracy

before=`date +%s%N`

$@

after=`date +%s%N`

let time=after-before

echo $time | sed 's/\([0-9]\{9\}\)$/.\1/'
