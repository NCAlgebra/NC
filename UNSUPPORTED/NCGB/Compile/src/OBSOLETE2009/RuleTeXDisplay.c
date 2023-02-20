// (c) Mark Stankus 1999
// RuleTeXDisplay.c

#include "RuleTeXDisplay.hpp"
#include "GroebnerRule.hpp"

template<class CONT,class ITER>
RuleTeXDisplay<CONT,ITER>::~RuleTeXDisplay(){};

template<class CONT,class ITER>
void RuleTeXDisplay<CONT,ITER>::perform() const {
  ITER w = d_L.begin(), e = d_L.end();
  while(w!=e) {
    d_sink << "\\begin{minipage}{" << d_columnwidth << "in}\n";
    d_sink.put(*w);
    d_sink << "\n\\end{minipage}\\medskip\\\\\n";
    ++w;
  };
};

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "vcpp.hpp"

#include "ByAdmissible.hpp"
template class RuleTeXDisplay<list<GroebnerRule>,
                              list<GroebnerRule>::const_iterator >;
template class RuleTeXDisplay<vector<GroebnerRule>,
                              vector<GroebnerRule>::const_iterator >;
template class RuleTeXDisplay<set<GroebnerRule,ByAdmissible>,
               set<GroebnerRule,ByAdmissible>::const_iterator >;
