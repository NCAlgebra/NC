#!/usr/bin/env python3

"""
Pandoc filter to convert inline math for display on github markdown.
Inspired by: https://gist.github.com/a-rodin/fef3f543412d6e1ec5b6cf55bf197d7b
"""

from pandocfilters import toJSONFilter, Image, Div, Para, Str, attributes
import re, sys, os
import subprocess
from urllib.parse import quote

base_url = 'https://render.githubusercontent.com/render/math?math={}{}'

def filter(key, value, format, meta):

    global base_url

    if key == 'Math':

        [math_type, math] = value
        
        # grab equation
        caption = math
        if math_type['t'] == 'InlineMath':
            # replace by image
            return Image(
                ['', [], []],
                [Str(caption)],
                [base_url.format(quote(math.strip()), '&mode=inline'), '']
            )
        else:
            # replace by image, wrap with paragraph
            return Image(
                ['', [], []],
                [Str('inline equation')],
                [base_url.format(quote(math.strip()), ''), '']
            )
        
    elif isinstance(value, list) and len(value) > 1:

        array = []
        current_array = []
        for item in value: 
            if (isinstance(item, dict) and 't' in item and
                item['t'] == 'Math' and item['c'][0]['t'] == 'DisplayMath'):
                # flush current array
                array.append({'t': key, 'c': current_array})
                # pull out math item
                array.append(Div(attributes({'style': 'display:block;'}), [Para([item])]))
                # reset current array
                current_array = []
            else:
                current_array.append(item)
        if len(array) == 0:
            # there were no math elements, flush
            return {'t': key, 'c': current_array}
        else:
            if len(current_array) > 0:
                # flush first
                array.append({'t': key, 'c': current_array})
            return array

if __name__ == "__main__":

    # filter
    toJSONFilter(filter)
