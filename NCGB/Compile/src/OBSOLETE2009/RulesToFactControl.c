// RulesToFactControl.c

#include "RulesToFactControl.hpp"
#include "FactControl.hpp"

void RulesToFactControl(const GBList<GroebnerRule> & source,
                        FactControl & fc) {
  const int sz = source.size();
  GBList<GroebnerRule>::const_iterator w = source.begin();
  GBHistory hist(0,0);
  int num;
  for(int i=1;i<=sz;++i,++w) {
    num = fc.addFactAndHistory(*w,hist,0);
    fc.setFactPermanent(num);
  }
};
