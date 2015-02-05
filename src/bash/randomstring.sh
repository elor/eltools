#!/bin/bash
#
# generates a random alphanumerical string

lower=( a b c d e f g h i j k l m n o p q r s t u v w x y z )
CAPS=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z )
digit=( 0 1 2 3 4 5 6 7 8 9 )
alpha=( ${lower[@]} ${CAPS[@]} )
alnum=( ${alpha[@]} ${digit[@]} )

selectelement(){
    local array=( $@ )
    local size=${#array[@]}
    local index=$((RANDOM%size))
    echo ${array[index]}
}

asd="`selectelement ${alpha[@]}`"
numitems=$((8+RANDOM%24))
for f in `seq 2 $numitems`; do
    asd="$asd`selectelement ${alnum[@]}`"
done

echo $asd
