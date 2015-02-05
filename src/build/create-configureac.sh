#!/bin/bash
#
# writes a makefile for scripts from the src directory structure

enabled="git desktop mounting download"

capitalize(){
    tr '[:lower:]' '[:upper:]' <<< "$1"
}

isdefault(){
    grep $1 <<< "$enabled" &>/dev/null
}

defaultvalue(){
    if isdefault $1; then
        echo true
    else
        echo false
    fi
}

writeenabledisable(){
    if isdefault $1; then
        echo "--disable-$basedir    Do not install $basedir scripts"
    else
        echo "--enable-$basedir    Install $basedir scripts"
    fi
}

writesubdir(){
    dir=$1
    basedir=$(basename $dir)
    basedir_cap=$(capitalize $basedir)
    cat <<EOF
AC_ARG_ENABLE([$basedir],
[  $(writeenabledisable $basedir)],
[case "\${enableval}" in
  yes) $basedir=true ;;
  no) $basedir=false ;;
  *) AC_MSG_ERROR([bad value \${enableval} for --enable-debug]) ;;
esac],[$basedir=$(defaultvalue $basedir)])
AM_CONDITIONAL([HAVE_$basedir_cap], [test x\$$basedir = xtrue])

EOF
}

writesubdirs(){
    local subdirs=`find src -mindepth 1 -maxdepth 1 -type d | xargs`

    for subdir in $subdirs; do
        writesubdir $subdir
    done
}

getemail(){
    git config user.email
}

getversion(){
    echo 1.0
}

getprojectname(){
    basename $PWD
}

cat > configure.ac <<EOF
AC_INIT([$(getprojectname)], [$(getversion)], [$(getemail)])
#AC_PREREQ(2.12)
AM_INIT_AUTOMAKE()

$(writesubdirs)
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
EOF
