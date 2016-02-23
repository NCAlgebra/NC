// BaseSelectionOrder.c

#include "BaseSelectionOrder.hpp"
#include "RecordHere.hpp"
#include "SPIID.hpp"
#include "SPI.hpp"
#ifndef INCLUDED_COMPARISONEXTENDED_H
#include "ComparisonExtended.hpp"
#endif
#ifndef INCLUDED_ADMISSIBLEORDER_H
#include "AdmissibleOrder.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif

BaseSelectionOrder::~BaseSelectionOrder(){};

// ------------------------------------------------------------------

extern const Monomial & tipOfRule(int);

// ------------------------------------------------------------------

bool BaseSelectionOrder::operator==(const BaseSelectionOrder&) const { 
  return true;
};

// ------------------------------------------------------------------

BaseSelectionOrder * BaseSelectionOrder::clone() const {
  RECORDHERE(BaseSelectionOrder* p = new BaseSelectionOrder;)
  return p;
};
 
// ------------------------------------------------------------------

ComparisonExtended BaseSelectionOrder::compare(const SPI& s1, const SPI& s2) const {
  ComparisonExtended result(ComparisonExtended::s_EQUAL); 
#if 0
  const int sz1 = s1.common_multiple_length();
  const int sz2 = s2.common_multiple_length();
  if(sz1<sz2) {
    result = ComparisonExtended::s_LESS;
  } else if(sz1>sz2) {
    result = ComparisonExtended::s_GREATER;
  } else {
    SPIID x = s1.leftID();
    SPIID y = s2.rightID();
    if(x==y) {
      x = s1.rightID();
      y = s2.rightID();
    };
    if(x!=y) {
      const Monomial & mon1 = tipOfRule(x);
      const Monomial & mon2 = tipOfRule(y);
      AdmissibleOrder * p;
DBG();
      if(p->monomialLess(mon1,mon2)) {
        result = ComparisonExtended::s_LESS;
      } else {
        result = ComparisonExtended::s_GREATER;
      };
    };
  }
#else
	DBG();
#endif
  return result;
};
