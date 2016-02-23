// DataConversions.c

#include "DataConversions.hpp"
//#pragma warning(disable:4786)
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif
#include "FactControl.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

#ifdef PDLOAD
void conversion(const GBList<Polynomial> & source,
        FactControl & fc,GBVector<int> & nums) {
  const int listSize = source.size();
  GroebnerRule rule;
  int num;
  GBList<Polynomial>::const_iterator w = source.begin();
  for(int i=1;i<=listSize;++i,++w) { 
    const Polynomial & poly = *w;
    if(!poly.zero()) {
      rule.convertAssign(*w);
      GBStream << '\n';
      num = fc.addFactAndHistory(rule,GBHistory(0,0),0);
      fc.setFactPermanent(num);
      nums.push_back(num);
    }
  }
};
#endif

#ifdef PDLOAD
void conversion(const GBList<Polynomial> & source,
   GBList<GroebnerRule> & dest) {
  const int sz = source.size();
  GroebnerRule rule;
  GBList<Polynomial>::const_iterator w = source.begin();
  for(int i=1;i<=sz;++i,++w) {
    rule.convertAssign(*w);
    dest.push_back(rule);
  }
};
#endif

void conversion(const GBList<GroebnerRule> & source,
      GBList<Polynomial> & dest) {
  const int sz = source.size();
  GBList<GroebnerRule>::const_iterator w = source.begin();
  Polynomial poly;
  for(int i=1;i<=sz;++i,++w) {
    (*w).toPolynomial(poly);
    dest.push_back(poly);
  }      
};

#ifdef PDLOAD
void conversion(const GBList<GroebnerRule> & source,
      FactControl & fc,GBVector<int> & nums) {
  const int sz = source.size();
  GBList<GroebnerRule>::const_iterator w = source.begin();
  GBHistory hist(0,0);
  int num;
  nums.reserve(nums.size()+sz);
  for(int i=1;i<=sz;++i,++w) {
    num = fc.addFactAndHistory(*w,hist,0);
    fc.setFactPermanent(num);
    nums.push_back(num);
  }
};
#endif
