#!/bin/bash

pdf="$1"

while true; do
  ls > /dev/null
  checksum_new=`md5sum *.tex *.bib`
  if [ "$checksum" != "$checksum_new" ]; then
    ssh ensarm00 "cd `pwd`; make clean; make -j 8 bib; make -j 8"
    if [ -z "$1" ]; then
      pdf=`du -b -a *.pdf | sort -rn | head -n 1 | sed 's/^\S*\s*\(\S*\)$/\1/'`
    fi
    if [ -e "$pdf" ]; then
      evince $pdf > /dev/null 2> /dev/null &
    fi
    checksum="$checksum_new"
  fi

  sleep 1
done

