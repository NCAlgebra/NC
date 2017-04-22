#!/usr/bin/env python

"""
Pandoc filter to convert all regular text to uppercase.
Code, link URLs, etc. are not affected.
"""

from pandocfilters import toJSONFilter, Str
import re

def create_anchor(level, link, text):
    
    # as discussed in
    # https://gist.github.com/asabaylus/3071099
    
    anchor = re.sub('[^\w\- ]+', ' ', text.strip().lower())
    anchor = re.sub('\s+', '-', anchor)
    anchor = re.sub('\-+$', '', anchor)

    if link not in anchors:
        anchors[link] = [[level, anchor, re.sub('\t','\\t',text)]]
    else:
        anchors[link].append([level, anchor, re.sub('\t','\\t',text)])
    
def filter(key, value, format, meta):
    if key == 'Header':

        # string
        string = ''
        for v in value[2]:
            if v['t'] == 'Str':
                string += v['c']
            elif v['t'] == 'Space':
                string += ' '
                
        create_anchor(value[0],
                      value[1][0],
                      string)


if __name__ == "__main__":

    # filter
    anchors = {}
    toJSONFilter(filter)

    # then save to file
    with open('pandoc.idx','w') as f:
        for (k,v) in anchors.items():
            if len(v) == 1:
                # single anchor
                level, anchor, text = v[0]
                f.write('{}\t{}\t{}\t{}\n'.format(level,
                                                  k,
                                                  anchor,
                                                  text))
                        
            elif len(v) > 1:
                for (i,(level, anchor, text)) in enumerate(v):
                    f.write('{}\t{}\t{}\t{}\n'.format(level,
                                                      k + '-' + str(i+1),
                                                      anchor,
                                                      text))
