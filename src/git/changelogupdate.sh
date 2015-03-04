#!/bin/bash
# print changelog line for the current date and git user

listfiles(){
    {
    # list staged files
    git diff --name-only --cached
    # list changed files
#   git diff --name-only
    } | sort -u | grep -iv '^changelog$'
}

formatnewfile(){
    sed -e 's/^/\t* /' -e 's/$/: \n/' <<< "$1"
}

input="`cat $1`"
files="`listfiles`"

if [ -z "$files" ]; then
    echo "No staged files found. Use 'git add' to stage files." >&2
    cat <<< "$input"
    exit 1
fi

thischange="`changelogline.sh`"

if grep -q "$thischange" <<< "$input"; then
    # this date already exists
    before="`sed -n "0,/$thischange/ { /$thischange/b ; p }"<<< "$input"`"
    after="`sed -e "0,/$thischange/d" -e "0,/^[0-9]\{4\}-[0-9][0-9]-[0-9][0-9]\s/ { /^[0-9]\{4\}-[0-9][0-9]-[0-9][0-9]\s/b ; d }" <<< "$input"`"

    current="`sed -n "/$thischange/,/^[0-9]\{4\}-[0-9][0-9]-[0-9][0-9]\s/ p" <<< "$input" | sed -e '$d'`
"
    while IFS= read file; do
        if grep -q "\* $file:" <<< "$current"; then
            current=$(sed "/\* `sed 's/\//\\\\\//g' <<< "$file"`:/,/^\s*$/ { /^\s*$/i\
\\\t
 }" <<< "$current")
        else
            append="$append`formatnewfile "$file"`

"
        fi
    done <<< "$files"
    [ -z "$append" ] && append="
"

    cat << EOF | sed '1 { /^\s*$/d }'
$before
$current
$append$after
EOF

else
    # this date doesn't exist yet. Let's push it to the front
    cat <<EOF
$thischange

`cat <<< "$files" | while IFS= read file; do formatnewfile "$file"; done`

$input
EOF
fi
