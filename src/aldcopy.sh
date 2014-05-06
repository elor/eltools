#!/bin/bash

src=/home/e.lorenz/code/parsivald
dst="`pwd`"

cd "$src"

cp -r "`which parsivald`" input lmpout options.cfg pyprefs "$dst"

mkdir -p "$dst/Scripts"
cp -r Scripts/debugsimulation.sh Scripts/valgrindsimulation.sh Scripts/runsimulation.sh Scripts/startworkers.sh Scripts/screenlocal.sh Scripts/localjob.sh "$dst/Scripts/"

