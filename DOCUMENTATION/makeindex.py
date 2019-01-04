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
    
    anchor = re.sub('[\.:`]', '', text.strip().lower())
    anchor = re.sub('[^\w\- ]+', ' ', anchor)
    anchor = re.sub('\s+', '-', anchor)
    anchor = re.sub('\-+$', '', anchor)

    if anchor not in anchors:
        anchors[anchor] = [[level, link, re.sub('\t','\\t',text)]]
    else:
        anchors[anchor].append([level, link, re.sub('\t','\\t',text)])
    
def filter(key, value, format, meta):
    if key == 'Header':

        # string
        string = ''
        for v in value[2]:
            if v['t'] == 'Str':
                string += v['c']
            elif v['t'] == 'Space':
                string += ' '
            elif v['t'] == 'Code':
                string += '`' + v['c'][1] + '`'
                
        create_anchor(value[0],
                      value[1][0],
                      string)


if __name__ == "__main__":

    # filter
    anchors = {}
    toJSONFilter(filter)

    # then save to file
    with open('pandoc.idx','w') as f:
        for (anchor,values) in anchors.items():
            for (i,(level, link, text)) in enumerate(values):
                if i == 0:
                    f.write('{}\t{}\t{}\t{}\n'.format(level,
                                                      link,
                                                      anchor,
                                                      text))
                else:
                    f.write('{}\t{}\t{}\t{}\n'.format(level,
                                                      link,
                                                      anchor + '-' + str(i),
                                                      text))
