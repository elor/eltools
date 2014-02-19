#!/bin/bash

# mute/unmute sound via amixer
# best used in conjunction with a hotkey

keymap=`setxkbmap -v | awk -F "+" '/symbols/ {print $2}'`

case $keymap in
  de)
    setxkbmap us
    ;;
  us)
    setxkbmap de
    ;;
  *)
    echo "unrecognized keymap. setting to english"
    setxkbmap us
    ;;
esac

