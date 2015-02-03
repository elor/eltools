#!/bin/bash
#
# Downloads the latest kerbal podcast

getlink(){
    curl -s kerbalpodcast.libsyn.com | grep -Pom1 'https?://[A-Za-z._/]+[0-9]{3}\.mp3'
}

link=`getlink` || { echo "Download link extraction failed"; exit 1; }
file=`basename $link`

[ -z "$link" ] && { echo "Download link cannot be extracted from kerbalpodcast.libsyn.com.">&2; exit 1; }

echo "download link: $link"
echo "output file: $file"
echo

wget -O "$file" "$link"
