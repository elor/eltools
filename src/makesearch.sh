#!/bin/bash
# searches a list of files retrieved by `make list` for "$1"

[ -z "$1" ] && echo "usage: $0 <search term>" && exit

for f in `make list`; do
  lines=`grep -n "$1" "$f"`

  if [ -n "$lines" ]; then
    echo "$f:"
    grep -n "$1" "$f"
  fi
done

