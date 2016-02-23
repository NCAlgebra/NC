// NumberOfRelations.c
 
#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#include "Debug1.hpp"
#include "load_flags.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#ifndef INCLUDED_MNGRSTART_H
#include "MngrStart.hpp"
#endif
#ifndef INCLUDED_POLYNOMIAL_H
#include "Polynomial.hpp"
#endif
#include "Command.hpp"

extern MngrStart * run;

void _NumberOfRelation(Source & so,Sink & si) {
  Polynomial p;
  so >> p;
  so.shouldBeEnd();
#ifdef PDLOAD
  GroebnerRule rule;
  rule.convertAssign(p);
  int ans = -1;
  const int sz = run->numberOfFacts();
  int i= run->lowvalue();
  for(int j=1;j<=sz && ans==-1;++i,++j) {
    if(rule==run->rule(i)) ans = i;
  }
  si << ans;
#else
  Debug1::s_not_supported("_NumberOfRelation");
#endif
}; /* _NumberOfRelation */

AddingCommand temp1NumberRelations("NumberOfRelation",1,_NumberOfRelation);
