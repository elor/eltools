#!/usr/bin/env python
#
# prints the average velocity of ideal gas particles at the given temperature, in Angstrom/picosecond

import sys, math
import periodictable as pte

if len(sys.argv) != 3:
    sys.stderr.write('syntax: %s <T in K> <m in u>'%(sys.argv[0]))
    exit(1)

dict = pte.__dict__

temp = float(sys.argv[1])
mass = float(sys.argv[2])

#################################
# constants and unit conversion #
# kB*NA*(g/kg*A^2/m^2*s^2/ps^2) #
#################################
factor = 1.3806488*6.0221413*0.1

print(math.sqrt(temp/mass*factor))
