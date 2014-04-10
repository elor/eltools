#!/usr/bin/env python
#
# retrieves the element name from its mass by closest match

import periodictable, re, sys

if len(sys.argv) != 2:
  sys.stderr.write('syntax: %s <mass (float)>'%(sys.argv[0]))
  exit(1)

mass = float(sys.argv[1])

elements = [ x for x in periodictable.__dict__ if re.match('^[A-Z][a-z]*$', x) ]
masses = [ periodictable.__dict__[x].mass for x in elements ]
diffs = [ abs(x - mass) for x in masses ]

mindiff = min(diffs)
mindiffindex = diffs.index(mindiff)

element = elements[mindiffindex]
mass = masses[mindiffindex]

print "%s %f"%(element, mass)

