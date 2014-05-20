#!/bin/bash

sourcedir=/home/e.lorenz/code/parsivald
destination="`pwd`"

cd "$sourcedir"

cp -r input lmpout options.cfg pyprefs "$destination"

