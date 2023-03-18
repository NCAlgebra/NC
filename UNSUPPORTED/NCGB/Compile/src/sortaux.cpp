// sortaux.c

#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_GBVECTOR_C
#include "Choice.hpp"
#include "GBVector.cpp"
#endif
#ifndef INCLUDED_CONST_ITER_GBVECTOR_C
#include "constiterGBVector.cpp"
#endif
#ifndef INCLUDED_ITER_GBVECTOR_C
#include "iterGBVector.cpp"
#endif
#pragma warning(disable:4661)
template class GBVector<GroebnerRule>;
#ifdef USE_UNIX
template class GBList<GroebnerRule>;
#endif
template class const_iter_GBVector<GroebnerRule>;
template class const_iter_GBVector<GBList<GroebnerRule> >;
template class iter_GBVector<GroebnerRule>;
template class iter_GBVector<GBList<GroebnerRule> >;


#ifndef INCLUDED_GBLIST_C
#include "GBList.cpp"
#endif

template class GBVector<GBList<GroebnerRule> >;

// For 2.7.0
template class const_iter_GBVector<Field *>;
template class iter_GBVector<Field *>;
template class GBVector<Field *>;
