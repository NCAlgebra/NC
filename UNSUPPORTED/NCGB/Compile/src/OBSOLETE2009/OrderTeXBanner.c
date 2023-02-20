// Mark Stankus 1999 (c)
// OrderTeXBanner.c

#include "OrderTeXBanner.hpp"
#include "OrdData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

OrderTeXBanner::~OrderTeXBanner() {};

void OrderTeXBanner::action(const BroadCastData & x) const {
  if(x.ID()!=OrdData.ID()) DBG();
  const OrdData & y = (const OrdData &) x;
  AdmissibleOrder & ord = y.d_ord;
  MyOstream & os = y.d_os;
  os << "THE ORDER IS NOW THE FOLLOWING:\\hfil\\break\n";
  if(ord.ID()==MLex::s_ID) {
    const MLex & OR = (const MLex &) ord;
    const int sz = OR.multiplicity();
    for(int i=1;i<=sz;++i) {
      const vector<Variable> & V = OR.monomialsAtLevel(i);
      vector<Variable> ::const_iterator w = V.begin();
      const int sz2 = V.size();
      if(sz2>0) {
        for(int j=1;j<sz2;++j,++w) {
          os << (*w).texstring();
          os << " $ < $ ";
        };
        os << (*w).texstring();
      };
      if(i==sz) {
        os << "\\\\\n";
      } else {
        os << "$\\ll$\n";
      };
   };
 } else DBG();
};

Recipient * OrderTeXBanner::clone() const {
  return new OrderTeXBanner;
};
