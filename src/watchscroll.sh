#!/bin/bash
#
# provides watch-like functionality, but allows scrolling

##########
# config #
##########

showtitle=true
interval=1.0
erraction=""
pagestart=1
colstart=1
tmpfile=/tmp/watchscroll_$$_command.tmp
outfile=/tmp/watchscroll_$$_command.out
logfile=''

echo "waiting for the command to finish" > $outfile

####################
# config functions #
####################

showhelp(){
    cat <<EOF >&2
TODO: print help
EOF
}

enablelog(){
    logfile=/tmp/watchscroll.log
    touch $logfile
}

enabledifferences(){
    local cumulative=$1
    echo "--differences is not implemented yet" >&2
}

enabledifferences(){
    echo "--color is not implemented yet" >&2
}

enableexec(){
    echo "--exec is not implemented yet" >&2
}

setinterval(){
    local tmpint="$1"
    # TODO: verify tmpint for a null-or-positive decimal number
    interval="$tmpint"
}

log(){
    [ -f "$logfile" ] && { echo "$@" >> $logfile ; }
    return 0
}

printversion(){
    cat <<EOF >&2
TODO: print version information
EOF
}

###############################
# process doubledash commands #
###############################

while true; do
    case "$1" in
        --help)
            showhelp
            exit
            ;;
        --differences*)
            enabledifferences
            ;;
        --color)
            enablecolor
            ;;
        --no-title)
            showtitle=false
            ;;
        --errexit)
            erraction="exit 1"
            ;;
        --exec)
            enableexec
            ;;
        --log)
            enablelog
            ;;
        --interval)
            setinterval "$2"
            shift
            ;;
        --interval=?*)
        setinterval "`sed 's/--interval=\(.*\)/\1/' <<< "$1" `"
        ;;
        --precise)
            echo "--precise not implemented yet" >&2
            ;;
        --version)
            printversion
            exit
            ;;
        --*)
            echo "unknown command: $1" >&2
            exit 1
            ;;
        -?*)
            break
            ;;
        -)
            echo "unknown command: $1" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
    shift
done

###############################
# process singledash commands #
# TODO move into upper loop   #
###############################

while [[ "$1" == -?* ]]; do
    cmd="$1"
    shift
    for c in `grep -o '[^-]' <<< "$cmd"`; do
        case $c in
            n)
                setinterval "$1"
                shift
                ;;
            d)
                enabledifferences
                ;;
            v)
                printversion
                exit
                ;;
            h)
                showhelp
                exit
                ;;
        esac
    done
done

#####################
# runtime functions #
#####################

iscommandrunning(){
    [ -e $tmpfile ]
#    (( `jobs -p | wc l` > 0 ))
}

runcommand(){
    local command="$@"

    if iscommandrunning; then
        echo "error: command is already running"
    elif [ -z "$command" ]; then
        echo "no command" > outfile
    else
        { bash -c "$command" &>$tmpfile; mv $tmpfile $outfile; } &>/dev/null &
    fi
}

abortcommand(){
    if iscommandrunning; then
        kill -KILL `jobs -rp`
        sleep 0.1
        rm $tmpfile
    fi
}

formatdate(){
    date --reference=$outfile +"%a %b %d %T %Y"
}

formatheader(){
    local COLUMNS="$1"
    shift
    local command="$@"
    local datestr=`formatdate`
    local state='   '
    iscommandrunning && state="(R)"

    local out="Every ${interval}s: "
    local outlength=`echo -ne "$out" | wc -c`
    local datelength=`echo -ne "$datestr" | wc -c`
    local cmdlength=`echo -ne "$command" | wc -c`
    local lengthleft=$(( COLUMNS - outlength - datelength - 5 ))

    if (( lengthleft < cmdlength )); then
        command="`cut -c 1-$((lengthleft-3)) 2>/dev/null <<< "$command"`..."
    fi

    out="$out$command $state"
    local outlength=`echo -ne "$out" | wc -c`
    lengthleft=$(( COLUMNS - outlength - datelength))

    for i in `seq 1 $lengthleft`; do
        out="$out "
    done
    out="$out$datestr"

    echo -ne "$out"
}

getoutput(){
    cat $outfile
}

countoutputlines(){
    getoutput | wc -l
}

pageoutput(){
    local start="$1"
    local lines="$2"
    local end=$((start+lines))
#    echo "$start - $lines - $end"
    getoutput | sed -n "$start,$end p"
}

scrollhorizontal(){
    local start="$1"
    local cols="$2"
    local end=$((start+cols))
#    echo "$start - $lines - $end"
    cut -c "$start-$end"
}

croppage(){
    pagestart="$1"
    local outlines="$2"
    local height="$3"

    log "crop:$pagestart-$outlines-$height"

    (( pagestart > outlines-height )) && pagestart=$((outlines-height))
    (( pagestart < 1 )) && pagestart=1

    log "crop:$pagestart-$outlines-$height"
}

cropcols(){
    colstart="$1"

    log "cols:$colstart"

    (( colstart < 1 )) && colstart=1

    log "cols:$colstart"
}

getinput(){
    local int="$1"
    local input
    [ -z "$int" ] && int=0.01
    read -n1 -t "$int" input &>/dev/null
    log "`xxd -ps <<< "$input"`"
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

trap 'log "killing $$"; rm -f $tmpfile $outfile ; trap 2 ; kill -2 $$' 2 3 15

############################
# TODO catch resize signal #
############################

runcommand "$@"

sleep 0.1

while true; do
    LINES=$(tput lines)
    COLUMNS=$(tput cols)
    height=$((LINES-4))
    width=$((COLUMNS-1))
    output=$(pageoutput $pagestart $height | scrollhorizontal $colstart $width)

    header=`formatheader "$COLUMNS" "$@"`

    iscommandrunning || runcommand "$@"
    echo -en '\033[2J\033[0;0H'

    cat <<EOF
$header

$output
EOF

    input=`getinput $interval`

    case $? in
        142)
        # timeout reached
            ;;
        0)
        # user input
            case `xxd -ps <<< "$input"` in 
                1b0a) # prefix for interactive keys: ^[
                    outlines=$(countoutputlines)
                    input=`getinput` || break
                    case `xxd -ps <<< "$input"` in 
                        5b0a) # [
                            input=`getinput` || break
                            case `xxd -ps <<< "$input"` in 
                                350a) # page up
                                    croppage $((pagestart-height)) $outlines $height
                                    getinput # filter the trailing "~"
                                    ;;
                                360a) # page down
                                    croppage $((pagestart+height)) $outlines $height
                                    getinput # filter the trailing "~"
                                    ;;
                                410a) # up
                                    croppage $((pagestart-1)) $outlines $height
                                    ;;
                                420a) # down
                                    croppage $((pagestart+1)) $outlines $height
                                    ;;
                                430a) # right
                                    cropcols $((colstart+width/2))
                                    ;;
                                440a) # left
                                    cropcols $((colstart-width/2))
                                    ;;
                            esac
                            ;;
                        4f0a) # second prefix for some interactive commands: O
                            input=`getinput` || break
                            case `xxd -ps <<< "$input"` in 
                                480a) # home
                                    croppage 1 $outlines $height
                                    ;;
                                460a) # end
                                    croppage $outlines $outlines $height
                                    ;;
                            esac
                            ;;
                    esac
                    ;;
                070a) # Ctrl-G
                    abortcommand
                    ;;
                6b0a) # k
                    abortcommand
                    ;;
                710a) # q
                    kill -2 $$
                    ;;
            esac
            ;;
        *)
        # some error or abort
            break
    esac
done

rm -f $tmpfile $outfile
