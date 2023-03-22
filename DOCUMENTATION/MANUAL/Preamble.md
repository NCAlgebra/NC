---
title: The NCAlgebra Suite
subtitle: Version 6.0.1
header-includes: |
  \makeatletter
  \newcommand{\@minipagerestore}{\setlength{\parskip}{\medskipamount}}
  \makeatother
  \newsavebox{\mybox}
  \setlength{\fboxsep}{10pt}
  \renewenvironment{quote}%
  {\begin{lrbox}{\mybox}\begin{minipage}{\textwidth}}%
  {\end{minipage}\end{lrbox}\colorbox{black!7!white}{\usebox{\mybox}}}
author: 
- J. William Helton
- Mauricio C. de Oliveira
date:
- with earlier contributions by Bob Miller \& Mark Stankus
---

\newpage

\chapter*{License}
\addcontentsline{toc}{chapter}{License}

**NCAlgebra** is distributed under the terms of the BSD License:

\vfill

    Copyright (c) 2023, J. William Helton and Mauricio C. de Oliveira
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name NCAlgebra nor the names of its contributors may be
		  used to endorse or promote products derived from this software without
		  specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
    DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
    ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

\vfill

\part{User Guide}

# Acknowledgements 

This work was partially supported by the Division of Mathematical
Sciences of the National Science Foundation.

The program was written by the authors with major earlier contributions from:

* Mark Stankus, Math, Cal Poly San Luis Obispo
* Robert L. Miller, General Atomics Corp

Considerable recent help came from 

* Igor Klep, University of Ljubljana
* Aidan Epperly

Other contributors include:

* David Hurst, Daniel Lamm, Orlando Merino, Robert Obar, Henry Pfister,
  Mike Walker, John Wavrik, Lois Yu, J. Camino, J. Griffin, J. Ovall,
  T. Shaheen, John Shopple.
  
The beginnings of the program come from eran@slac. 

