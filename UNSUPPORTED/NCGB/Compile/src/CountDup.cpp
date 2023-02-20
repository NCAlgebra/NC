// CountDup.c

#include "CountDup.hpp"
#include "Newing.hpp"
#include "Cloning.hpp"
#include "Alias.hpp"
#include "AdmissibleOrder.hpp"
#include "ISink.hpp"
#include "ISource.hpp"
#include "RuleIDHelper.hpp"
#include "Term.hpp"
#include "GroebnerRule.hpp"
#include "Polynomial.hpp"
#include "ListChoice.hpp"
#ifdef USE_VCPP
#pragma warning(disable:4786)
#endif
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

#if 0
bool CountDup<AdmissibleOrder, Cloning<AdmissibleOrder> >::s_freeze = false;
bool CountDup<ISink, Cloning<ISink> >::s_freeze = false;
bool CountDup<ISource, Cloning<ISource> >::s_freeze = false;
bool CountDup<RuleIDHelper, Newing<RuleIDHelper> >::s_freeze = false;
bool CountDup<ISource, MakeAlias<ISource> >::s_freeze = false;
bool CountDup<ISink, MakeAlias<ISink> >::s_freeze = false;
bool CountDup<Term,Newing<Term> >::s_freeze = false;
#ifdef NEWMONOMIAL
bool CountDup<MonomialHelper, Newing<MonomialHelper> >::s_freeze = false;
#endif
#ifdef USE_NEW_GBLIST
#include "SPIID.hpp"
#include "GBHistory.hpp"
#include "Spreadsheet.hpp"
#include "GBVector.hpp"
#include "GBMatch.hpp"
#include "simpleString.hpp"
#include "FactControl.hpp"
bool CountDup<list<int>,Newing<list<int> > >::s_freeze = false;
bool CountDup<list<Variable>,Newing<list<Variable> > >::s_freeze = false;
bool CountDup<list<Term>,Newing<list<Term> > >::s_freeze = false;
bool CountDup<list<Polynomial>,Newing<list<Polynomial> > >::s_freeze = false;
bool CountDup<list<GBList<Polynomial> > ,Newing<list<GBList<Polynomial> > > >::s_freeze = false;
bool CountDup<list<GBList<int> > ,Newing<list<GBList<int> > > >::s_freeze = false;
bool CountDup<list<GBList<GBList<int> > > ,Newing<list<GBList<GBList<int> > > > >::s_freeze = false;
bool CountDup<list<GBList<GBList<int> >::iterator > ,Newing<list<GBList<GBList<int> >::iterator > > >::s_freeze = false;
bool CountDup<list<GroebnerRule> ,Newing<list<GroebnerRule> > >::s_freeze = false;
bool CountDup<list<GBHistory> ,Newing<list<GBHistory> > >::s_freeze = false;
bool CountDup<list<GBList<GBHistory> > ,Newing<list<GBList<GBHistory> > > >::s_freeze = false;
bool CountDup<list<GBList<GroebnerRule> > ,Newing<list<GBList<GroebnerRule> > > >::s_freeze = false;
bool CountDup<list<GBList<Variable> > ,Newing<list<GBList<Variable> > > >::s_freeze = false;
bool CountDup<list<Spreadsheet> ,Newing<list<Spreadsheet> > >::s_freeze = false;
bool CountDup<list<FactControl> ,Newing<list<FactControl> > >::s_freeze = false;
bool CountDup<list<SPIID> ,Newing<list<SPIID> > >::s_freeze = false;
bool CountDup<list<GBVector<int> > ,Newing<list<GBVector<int> > > >::s_freeze = false;
bool CountDup<list<Match> ,Newing<list<Match> > >::s_freeze = false;
bool CountDup<list<simpleString> ,Newing<list<simpleString> > >::s_freeze = false;
#endif
#endif
