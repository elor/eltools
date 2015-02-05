#!/bin/bash

printprogress(){
  local cur=$1
  local max=$2
  local text="$3"

  local pre="$text ["

  local spaced=$cur

  while (( "${#spaced}" < ${#max} )); do
    spaced=" $spaced"
  done

  local post="] $spaced/$max"

  if [ "$max" == '%' ]; then
    max=100

    (( $cur < 10 )) && cur=0$cur
    (( $cur < 100 )) && cur=0$cur

    post="] $cur%"
  fi

  local width=`tput cols`
  local progress

  let width=width-${#pre}-${#post}
  let progress=$width*$cur/$max

  local mid=''

  while (( $progress > 0 )) && (( $width > 0 )); do
    mid="#$mid"
    let progress-=1
    let width-=1
  done

  while (( $width > 0 )); do
    mid="$mid-"
    let width-=1
  done

  echo -ne "\r$pre$mid$post\r"
}

