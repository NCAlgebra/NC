// newaux.c

//#pragma warning(disable:4786)
//#pragma warning(disable:4661)
//#pragma warning(disable:4660)

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "ListChoice.hpp"
#include "SPIID.hpp"
#ifndef INCLUDED_TERM_H
#include "Term.hpp"
#endif
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#ifndef INCLUDED_GBGLOBALS_H
#include "GBGlobals.hpp"
#endif
#ifndef INCLUDED_GBHISTORY_H
#include "GBHistory.hpp"
#endif
#ifndef INCLUDED_GBMATCH_H
#include "GBMatch.hpp"
#endif
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#include "simpleString.hpp"
#include "Spreadsheet.hpp"

#ifndef INCLUDED_GBLIST_C
#ifdef USE_UNIX
#include "GBList.c"
#else
#include "GBList.cpp"
#endif
#endif
#ifndef INCLUDED_DLNODE_C
#ifdef USE_UNIX
#include "DLNode.c"
#else
#include "DLNode.cpp"
#endif
#endif

#ifndef INCLUDED_GBVECTOR_C
#ifdef USE_UNIX
#include "GBVector.c"
#else
#include "GBVector.cpp"
#endif
#endif
#ifndef INCLUDED_CONST_ITER_GBVECTOR_C
#ifdef USE_UNIX
#include "constiterGBVector.c"
#else
#include "constiterGBVector.cpp"
#endif
#endif
#ifndef INCLUDED_ITER_GBVECTOR_C
#ifdef USE_UNIX
#include "iterGBVector.c"
#else
#include "iterGBVector.cpp"
#endif
#endif
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

#define USE_UNIX
#ifdef USE_UNIX
template class GBVector<GBList<GroebnerRule>::const_iterator >;
#endif
#define USE_UNIX
template class GBVector<Variable>;
template class GBVector<GBVector<int> >;
template class GBVector<bool>;
#ifdef USE_UNIX
template class GBVector<int>;
#endif
template class iter_GBVector<GBList<int> > ;
template class iter_GBVector<Variable>;
template class iter_GBVector<GBVector<int> >;
template class iter_GBVector<bool>;
template class iter_GBVector<int>;
template class const_iter_GBVector<Variable>;
template class const_iter_GBVector<GBVector<int> >;
template class const_iter_GBVector<bool>;
template class const_iter_GBVector<int>;


GBList<simpleString> GBGlobals::s_CurrentMarkerStrings;
GBList<int> GBGlobals::s_CurrentMarkerNumbers;
#ifdef USE_OLD_GBLIST
template class DLNode<GBList<GBList<int> >::iterator >;
#endif

#include "Polynomial.hpp"

#ifdef USE_UNIX
extern template class GBList<int>;
template class GBList<GBList<int> >;
template class GBList<GroebnerRule>;
template class GBList<GBList<GroebnerRule> >;
template class GBList<Polynomial>;
template class GBList<GBList<Polynomial> >;
template class GBList<Variable>;
template class GBList<GBList<Variable> >;
template class GBList<simpleString>;
#endif
#ifdef USE_OLD_GBLIST
template class GBListIterator<simpleString>;
template class const_GBListIterator<simpleString>;
#ifdef PDLOAD
template class GBList<GBHistory>;
#endif
#endif
#ifdef USE_UNIX
template class GBList<GroebnerRule>;
template class GBList<Match>;
template class GBList<Polynomial>;
template class GBList<Term>;
template class GBList<Variable>;
template class GBList<int>;
#endif
#ifdef USE_OLD_GBLIST
template class GBList<GroebnerRule>;
template class GBList<Polynomial>;
template class GBList<Variable>;
template class GBList<int>;
template class GBListIterator<GBList<GroebnerRule> >;
template class GBListIterator<GBList<Polynomial> >;
template class GBListIterator<GBList<Variable> >;
template class GBListIterator<GBList<int> >;
template class GBListIterator<GBListIterator<GBList<int> > >;
template class GBListIterator<GroebnerRule>;
template class GBListIterator<Match>;
template class GBListIterator<Polynomial>;
template class GBListIterator<Term>;
template class GBListIterator<Variable>;
template class GBListIterator<int>;
template class GBListRep<GBList<GroebnerRule> >;
template class GBListRep<GBList<Polynomial> > ;
template class GBListRep<GBList<Polynomial> >;
template class GBListRep<GBList<Variable> >;
template class GBListRep<GBList<int> >;
template class GBListRep<GBListIterator<GBList<int> > >;
template class GBListRep<GroebnerRule>;
template class GBListRep<Polynomial>;
template class GBListRep<Term>;
template class GBListRep<Variable >;
template class GBListRep<int>;
#endif
#ifdef USE_OLD_GBLIST
template class const_GBListIterator<GBList<GroebnerRule> >;
template class const_GBListIterator<GBList<Polynomial> > ;
template class const_GBListIterator<GBList<Variable> >;
template class const_GBListIterator<GBList<int> >;
template class GBListIterator<GBList<int> >;
template class const_GBListIterator<GBListIterator<GBList<int> > >;
template class const_GBListIterator<GroebnerRule>;
template class const_GBListIterator<Match>;
template class const_GBListIterator<Polynomial>;
template class const_GBListIterator<Term>;
template class const_GBListIterator<Variable>;
template class const_GBListIterator<int>;
extern template class GBVector<int> ;
#ifdef USE_OLD_GBLIST
template class DLNode<GBVector<int> > ;
#endif
#endif

#ifdef USE_UNIX
extern template class GBVector<int>;
template class GBList<GBVector<int> > ;
#endif
#ifdef USE_OLD_GBLIST
template class GBListIterator<GBVector<int> >;
template class GBListRep<GBVector<int> > ;
#endif

#ifdef USE_OLD_GBLIST
template class GBVector<const_GBListIterator<GroebnerRule> >;
#ifdef PDLOAD
template class GBVector<const_GBListIterator<GBHistory> >;
#endif
#endif
template class GBVector<GBList<int> >;
#ifdef USE_OLD_GBLIST
template class GBVector<GBListIterator<Variable> >;
#endif
template class GBVector<simpleString>;
template class iter_GBVector<simpleString>;
template class const_iter_GBVector<simpleString>;

#include "Composite.hpp"
template class const_iter_GBVector<Composite *>;
template class iter_GBVector<Composite *>;
template class GBVector<Composite *>;
template class GBList<SPIID>;
#ifdef USE_OLD_GBLIST
template class const_GBListIterator<SPIID>;
template class GBListIterator<SPIID>;
#endif
template class GBVector<GBList<GBHistory>::const_iterator>;

#ifdef PDLOAD
#ifndef INCLUDED_FACTCONTROL_H
#include "FactControl.hpp"
#endif
#endif

#ifdef USE_UNIX
#ifdef USE_OLD_GBLIST
template class GBListRep<FactControl>;
#ifdef PDLOAD
template class GBListIterator<FactControl>;
#endif
template class const_GBListIterator<FactControl>;
#endif
//template class GBList<FactControl>;
#endif

#ifdef USE_OLD_GBLIST
template class DLNode<GBList<GroebnerRule> >;
template class DLNode<GBList<Polynomial> >;
template class DLNode<GBList<Variable> >;
template class DLNode<GBList<int> >;
#endif
