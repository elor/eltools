#!/bin/bash
#
# Find OV movies at the cinestar chemnitz

set -e -u

url='http://www.cinestar.de/de/kino/chemnitz-cinestar-am-roten-turm/kinoprogramm/?version=OV'
baseurl="http://www.cinestar.de"

text=$(curl -s "$url")

moviecolumn=$(echo -ne "$text" | sed -e 's/</\n</g' | sed -e '/<script/,/<\/script>/d' -e '/class="content_col_right"/,$d' -e '/^\s*$/d' -e '1,/id="main_content_full"/d')

rawmoviedata=$(echo -ne "$moviecolumn" | grep -o '<a href="[^"]*/veranstaltungen/[^"]*" title="[^"]*"\|Vorstellung .*\|datetime="[^"]*"' | sed -e 's/datetime="\([^"]*\)"/\1/' -e 's/<a href="\([^"]*\)" title="\([^"]*\)"/\2\n\1/')

movies=$(echo -e "$rawmoviedata" | while IFS= read line; do
        if [ "${line:0:1}" == '/' ]; then
            echo "$baseurl$line"
        else
            echo "$line"
        fi
        grep '^Vorstellung' <<< "$line\n" &>/dev/null && echo "\n"
done | recode html)

echo -ne "$movies"

cat <<EOF

Alle OV-Vorstellungen: $url
EOF
