#!/bin/bash
#
# creates final.xyz, converts it to lmp data file, corrects it and invokes
# lammps for rdf calculation
# 
# syntax: $0 <dump.xyz>
# note: use "--" instead of a file name to read from stdin

# list of required software
required="gitoliterepos.sh githubrepos.sh git"

# show syntax and exit
fail(){
  cat  >&2 << EOF
Syntax: `basename $0`

This script automatically initializes a personalized github archive for e.lorenz, cloning from gitolite@sim/ and git@github.com:elor/

In order to work, the directory must be completely empty
EOF
  exit 1
}

# find and print missing programs
missing=$(
for prog in $required; do
  type $prog >/dev/null 2>/dev/null || echo $prog
done
)
if [ -n "$missing" ];then
  echo "This script requires the following libraries:" >&2
  echo -e "$missing" | sed 's/^/* /' >&2
  echo
  fail
fi

case "$1" in
  --help)
    fail
    ;;
  -h)
    fail
    ;;
  "")
    ;;
  *)
    fail
    ;;
esac


######################
## Work starts here ##
######################

# only works with empty directories
if [ -n "`ls`" ]; then
  echo "directory $PWD is not empty" >&2
  exit 1
fi

# don't work within a git repository
toplevel=`git rev-parse --show-toplevel 2>/dev/null`
if [ $? == 0 ]; then
  echo "Can't work inside a git repository: $toplevel" >&2
  exit 1
fi

# verify access
ssh git@github.com exit &>/dev/null
if [ $? != 1 ]; then
  echo "ssh git@github.com failed" >&2
  exit 1
fi

ssh gitolite@sim exit &>/dev/null
if [ $? != 25 ]; then
  echo "ssh gitolite@sim failed" >&2
  exit 1
fi

# init variables
github=`githubrepos.sh elor`
gitolite=`gitoliterepos.sh gitolite@sim | grep -v gitolite-admin`

duplicates=`echo -e "$github" "$gitolite" | xargs -n1 basename | sort | uniq -d`

# remove the duplicates from $gitolite
gitolite_unique=$(for repo in $gitolite; do
  grep `basename $repo` &>/dev/null <<< "$duplicates" || echo $repo
done
)

# init the github repositories first
for repo in $github; do
  if ! git clone git@github.com:$repo; then
    echo "git clone failed" >&2
    exit 1
  fi
done

# add remotes for duplicate repos
for repo in $duplicates; do
  cd $repo || exit 1
  if ! git remote add sim gitolite@sim:`grep $repo <<< "$gitolite"`; then
    echo "git remote add failed" >&2
    exit 1
  fi

  if ! git fetch sim; then
    echo "git fetch sim failed" >&2
    exit 1
  fi
  
  cd - >/dev/null || exit 1
done

# initialize gitolite repos
for repo in $gitolite_unique; do
  echo $repo &>/dev/null
  if ! git clone gitolite@sim:$repo; then
    echo "git clone failed" >&2
    exit 1
  fi
done

# checkout every branch from origin before checkout out master again
for repo in *; do
  if ! [ -d "$repo" ]; then
    echo "$repo is no directory anymore" >&2
    exit 1
  fi

  cd $repo || exit 1

  for branch in `git branch -a | grep 'remotes/origin' | grep -v '\->' | xargs -n1 basename`; do
    git checkout $branch
  done

  # return to the master branch
  git branch -a  &>/dev/null | grep master &>/dev/null && git checkout master

  cd - >/dev/null || exit 1
done

# set up pullall
echo "creating link to pullall.sh"
ln -s eltools/src/pullall.sh pullall.sh

# done
echo done

