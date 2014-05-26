#!/bin/bash
#
# example script to start a task n times in parallel
# syntax: `dirname $0 <command> <numrepetitions>

mytest(){
  echo "job $TASKID/$TASKNUM started"
  sleep $(( $RANDOM % 10 ))
  echo "job $TASKID/$TASKNUM finished"
  return 1
}

dead=false
quit(){
  dead=true
  jobs -rl | awk '{print $2}' | xargs kill &>/dev/null
}

trap quit INT
trap quit KILL
trap quit TERM

cmd="$1"
[ -z "$cmd" ] && cmd=mytest && echo "no first argument given. cmd=mytest (test mode)" >&2
ncpus=`grep proc /proc/cpuinfo|wc -l`
num="$2"
[ -z "$num" ] && num=-1 && echo "no second argument given. num=-1 (infinite loop)" >&2

export TASKNUM=$num
i=0
while (( i < num )) || (( num == -1 )); do
  let i++
  export TASKID=$i
  $cmd &
  (( $ncpus > `jobs -r|wc -l` )) || wait -n
  $dead && break
done

$dead && quit || wait

