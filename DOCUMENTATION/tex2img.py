#!/usr/bin/env python

"""
Pandoc filter to convert all regular text to uppercase.
Code, link URLs, etc. are not affected.
"""

from pandocfilters import toJSONFilter, Para, Str, Image
import re, sys, os
import subprocess

version = '5.0.2'
base_url = 'http://math.ucsd.edu/~ncalg/DOCUMENTATION/eqns/'
count = 0

def latex(formula, count):

    global base_url, version
    
    # create file 'formula.tex'
    with open('formula.tex','w') as f:
        f.write(r"""\documentclass[border=2pt,10pt]{standalone}
\usepackage{amsmath,amsfonts}
\usepackage{varwidth}
\begin{document}
\begin{varwidth}{\linewidth}
""")
        f.write('{}'.format(formula))
        f.write(r"""
\end{varwidth}
\end{document}
""")

    try:

        # compile formula
        p = subprocess.Popen(['pdflatex',
                              'formula.tex'],
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE)
        p.wait()
        
        # convert to png
        p = subprocess.Popen(['convert',
                              '-density',
                              '300',
                              'formula.pdf',
                              '-quality',
                              '90',
                              'formula.png'],
                             stdin=subprocess.PIPE,
                             stdout=subprocess.PIPE)
        p.wait()

        # move file
        os.rename('formula.png','eqns/' + version + '/eqn_{}.png'.format(count))
        
    except subprocess.CalledProcessError as e:
        print(e, file = sys.stderr)
    
        
def filter(key, value, format, meta):

    global base_url, version
    global count

    if key == 'Math':

        # grab equation
        par = False
        if value[0]['t'] == 'InlineMath':
            formula = '$' + value[1] + '$'
            caption = value[1]
        else:
            par = True
            formula = r'\begin{align*}' + value[1] + r'\end{align*}'
            caption = ''
                
        # typeset formula
        count += 1
        latex(formula, count)

        # replace by image
        return Image(['', [], []],
                     [Str(caption)],
                     [base_url + version + '/eqn_{}.png'.format(count), ''])


if __name__ == "__main__":

    count = 0
    # filter
    toJSONFilter(filter)
