#!/bin/bash

src=/home/elor/code/ald
dst="`pwd`"

cd "$src"

cp -r ald lammps lmpout options.cfg pyprefs "$dst"

mkdir "$dst/Scripts"
cp -r Scripts/debugsimulation.sh Scripts/runsimulation.sh Scripts/startworkers.sh Scripts/screenlocal.sh Scripts/localjob.sh "$dst/Scripts/"

