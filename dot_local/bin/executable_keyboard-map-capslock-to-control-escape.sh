#!/bin/bash
if [ -x /usr/bin/setxkbmap ]; then
    /usr/bin/setxkbmap -option 'caps:ctrl_modifier'
fi

if [ -x /usr/bin/xcape ]; then
    /usr/bin/xcape -e 'Caps_Lock=Escape' -t 100
fi
