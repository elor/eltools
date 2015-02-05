#!/bin/bash
#
# another elor git tool: try to remove subdirectories from git. Ask for each one

git rev-parse --show-toplevel >/dev/null || exit 1

gitrootdir=`git rev-parse --show-toplevel | xargs readlink -f`
[ -n "$1" ] && gitsubdir="`pwd`/$1"
[ -z "$gitsubdir" ] && gitsubdir="`pwd | xargs readlink -f`"
gitsubdir=`sed "s#^$gitrootdir/\?##" <<< "$gitsubdir"`
[ -z "$gitsubdir" ] && gitsubdir=.
relroot=`pwd | sed -e "s#^$gitrootdir/\?##" -e 's/[^/]\+/../g'`
[ -z "$relroot" ] && relroot=.

(
    cd "$gitrootdir"

    case "$2" in
        --list|-l)
            git log --pretty=format: --name-status -- "$relroot/$gitsubdir" | cut -f2- | sed -e "s#^$gitsubdir/##" -e 's /.*$  ' | sort -u
            exit
            ;;
        --debug|-d)
            cat  <<EOF
gitrootdir: $gitrootdir
gitsubdir: $gitsubdir
relroot: $relroot
EOF
            exit
            ;;
        *)
            ;;
    esac

    options=($(git log --pretty=format: --name-status -- "$relroot/$gitsubdir" | cut -f2- | sed -e "s#^$gitsubdir/##" -e 's /.*$  ' | sort -u \
        | while IFS= read file; do
                [ -z "$file" ] && continue
                
                let ++id
                echo -n "$id $file off"
                echo "${options[@]}"
                done))

    selection=""
    if (( ${#options[@]} != 0 )); then
        selection=$(dialog --separate-output --checklist "Select files to remove from $gitsubdir/:" 30 55 26 "${options[@]}" 2>&1 >/dev/tty)
        clear
    fi

    if [ -n "$selection" ]; then
        for index in $selection; do
            let index=index*3-2
            file="$gitsubdir/${options[index]}"
            echo "deleting '$file'"
            git filter-branch --force --index-filter "git rm --cached --ignore-unmatch -r \"$file\"" --prune-empty --tag-name-filter cat -- --all
        done
    else
        echo
        echo "No files selected (OR: $gitsubdir/ contains no cached files)"
    fi
)
