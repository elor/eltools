#!/usr/bin/env python
#
# retrieves the element name from its mass by closest match

import sys
import periodictable as pte

if len(sys.argv) < 2:
    sys.stderr.write('syntax: %s <symbol/name>...'%(sys.argv[0]))
    exit(1)

dict = pte.__dict__

for string in sys.argv[1:]:
    try:
        element = dict[string]
        print(element.mass)
    except:
        print('notfound')

