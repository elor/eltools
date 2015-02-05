#!/bin/bash
#
# scrolls all open evince windows by 1 page

# termwinid=`xwininfo | grep 'Window id' |grep -o '0x[0-9a-f]\+'`
termwinid=`xdotool getwindowfocus`

log(){
    echo "$1" >&2
}

getwinids(){
    xdotool search --onlyvisible --class evince
}

scroll(){
    log "$1 $2 $3 $4"
    for winid in `getwinids`; do
        xdotool mousemove --window $winid 50 200 click 1 mousemove_relative 10 110 click $@
    done
    wait
    xdotool mousemove --window $termwinid 50 50 click --repeat 2 1
}

scrollpage(){
    local times="$1"
    [ -z "$times" ] && times=1

    if [[ "$1" == -* ]]; then
        scroll --repeat ${times#-} 4
    else
        scroll --repeat ${times#+} 5
    fi
}

getinput(){
    local input
    int="$1"
    [ -z "$int" ] && int=0.01
    read -n1 -t "$int" input &>/dev/null
    log asd
    log "getinput: `xxd -ps <<< "$input"`"
    case $? in
        142)
            return 142
            ;;
        0)
            echo -e "$input"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

while true;do
    cat <<EOF
Currently at page $pageid
Use the navigation keys to advance the page

EOF

    input=`getinput 12345`

    case $? in
        142)
            # timeout reached
            ;;
        0)
            # user input
            case `xxd -ps <<< "$input"` in 
                1b0a) # prefix for interactive keys: ^[
                    input=`getinput` || break
                    case `xxd -ps <<< "$input"` in 
                        5b0a) # [
                            input=`getinput` || break
                            case `xxd -ps <<< "$input"` in 
                                350a) # page up
                                    scrollpage -10
                                    ;;
                                360a) # page down
                                    scrollpage +10
                                    ;;
                                410a) # up
                                    scrollpage -1
                                    ;;
                                420a) # down
                                    scrollpage +1
                                    ;;
                                430a) # right
                                    scrollpage +1
                                    ;;
                                440a) # left
                                    scrollpage -1
                                    ;;
                            esac
                            ;;
                        # 4f0a) # second prefix for some interactive commands: O
                        #     input=`getinput` || break
                        #     case `xxd -ps <<< "$input"` in 
                        #         480a) # home
                        #             scrollpage 1
                        #             ;;
                        #         460a) # end
                        #             scrollpage `numberofpages`
                        #             ;;
                        #     esac
                        #     ;;
                    esac
                    ;;
                6a0a) # j
                    scrollpage +1
                    ;;
                6b0a) # k
                    scrollpage -1
                    ;;
                6e0a) # n
                    scrollpage +1
                    ;;
                700a) # p
                    scrollpage -1
                    ;;
            esac
            ;;
        *)
            # some error or abort. Just retry
            break
    esac
done
