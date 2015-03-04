#!/bin/sh
#
# prepare build environment

./src/build/create-configureac.sh
./src/build/create-makefileam.sh
mkdir -p m4
autoreconf --force --install -I config -I m4
