#!/bin/bash
#
# auto-login as SWAdmin on ensnb

getpasswd(){
    ssh -o PasswordAuthentication=no sim swadminpassword.sh
}

splitpasswd(){
    getpasswd | sed 's/./& /g'
}

xdotoolescapedpasswd(){
    splitpasswd | sed          \
        -e 's/#/numbersign/g'  \
        -e 's/%/percent/g'     \
        -e 's/(/parenleft/g'   \
        -e 's/)/parenright/g'  \
        -e 's/,/comma/g'       \
        -e 's/[$]/dollar/g'    \
        -e 's/[.]/period/g'    \
        -e 's/§/section/g'     \

}

xdotool mousemove --sync 0 500 key S W A d m i n Tab `xdotoolescapedpasswd` Return
