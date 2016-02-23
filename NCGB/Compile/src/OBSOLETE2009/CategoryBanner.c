// Mark Stankus 1999 (c)
// CategoryBanner.c

#include "CategoryBanner.hpp"
#include "ListRuleData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

CategoryBanner::~CategoryBanner() {};

void CategoryBanner::action(const BroadCastData & x) const {
  if(!x.cancast(ListRuleData.ID()) DBG();
  const ListRuleData & y = (const ListRuleData &) x;
  AdmissibleOrder & ord = y.d_ord;
  MyOstream & os = y.d_os;
  const VariableSet & knowns = y.d_knowns;
  const VariableSet & unknowns = y.d_unknowns;
  const list<GroebnerRule> & rules = y.rules();
  os << "-----------------------------------------------------------\n"];
  os << "The expressions with unknown variables " << unknowns << '\n';
  os << "and knowns " << knowns << "\n\n";
  typedef list<GroebnerRule>::const_iterator LI;
  LI w = d_L.begin(), e = d_L.end();
  while(w!=e) {
    const GroebnerRule & item = *w;
    os << item << '\n';
    ++e;
    if(w!=e) os << '\n';
  };
};

Recipient * CategoryBanner::clone() const {
  return new CategoryBanner;
};
