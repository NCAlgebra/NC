#!/usr/bin/env python

"""
Pandoc filter to convert all regular text to uppercase.
Code, link URLs, etc. are not affected.
"""

from pandocfilters import toJSONFilter, Str, Link
import sys, re

def filter(key, value, format, meta):
    if key == 'Link':
        link = value[2][0]
        if link[0] == '#' and link[1:] in links:
            # internal link,
            # replace by mangled version
            value[2][0] = '#' + links[link[1:]]
            return Link(value[0], value[1], value[2])

if __name__ == "__main__":

    links = {}
    try:
        with open('pandoc.idx','r') as f:
            for line in f:
                splitline = line.strip().split('\t')
                links[splitline[1]] = splitline[2]

        toJSONFilter(filter)
    except:
        pass
