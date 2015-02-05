#!/bin/bash
#
# writes a makefile for scripts from the src directory structure

writescriptfiles(){
    local files=`find src -maxdepth 1 -type f | xargs`
    cat <<EOF
dist_bin_SCRIPTS = $files

EOF
}

capitalize(){
    tr '[:lower:]' '[:upper:]' <<< "$1"
}

writesubdir(){
    local dir=$1
    local files=`find $dir -type f | xargs`

cat <<EOF
if HAVE_$(capitalize $(basename $dir))
dist_bin_SCRIPTS += $files
endif

EOF
}

writesubdirs(){
    local subdirs=`find src -mindepth 1 -maxdepth 1 -type d | xargs`

    for subdir in $subdirs; do
        writesubdir $subdir
    done
}

cat > Makefile.am <<EOF
ACLOCAL_AMFLAGS = \${ACLOCAL_FLAGS}

$(writescriptfiles)

$(writesubdirs)

EOF
