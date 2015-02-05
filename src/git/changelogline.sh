#!/bin/bash
#
# print changelog line for the current date and git user

user=`git config user.name`
[ "$user" ] || user="Undefined User"
mail=`git config user.email`
[ "$mail" ] || mail="user@mail.com"
date=`date -Idate`

echo $date$'\t'$user$'\t<'$mail'>'

