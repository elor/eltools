#!/bin/bash

if ! (( "$#" )); then
  $0 ffield.reax.*
else

  while (( "$#" )); do
    echo $1:
    echo "  "`sed -n '2,$s/^\s*\([A-Z][a-zA-Z]*\).*$/\1/p' $1`
    shift
  done
fi
