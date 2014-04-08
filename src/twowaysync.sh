#!/bin/bash
#
# two-way sync between sim and arm

remotehost=arm
localdir=arm
remotedir=sim

rsync -avzru --remove-source-files $remotehost:$remotedir/to/ $localdir/from/
rsync -avzru --remove-source-files $localdir/to/ $remotehost:$remotedir/from/

