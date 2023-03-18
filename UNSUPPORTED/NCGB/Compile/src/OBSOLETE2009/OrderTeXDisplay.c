// (c) Mark Stankus 1999
// OrderTeXDisplay.c

#include "OrderTeXDisplay.hpp"
#include "MLex.hpp"


OrderTeXDisplay::~OrderTeXDisplay() {};

void OrderTeXDisplay::perform() const {
  if(d_ord.ID()==MLex::s_ID) {
    const MLex & OR = (const MLex &) d_ord;
    const int sz = OR.multiplicity();
    for(int i=1;i<=sz;++i) {
      const vector<Variable> & V = OR.monomialsAtLevel(i);
      vector<Variable> ::const_iterator w = V.begin();
      const int sz2 = V.size();
      if(sz2>0) {
        for(int j=1;j<sz2;++j,++w) {
          d_sink.put(*w);
          d_sink << " $ < $ ";
        };
        d_sink.put(*w);
      };
      if(i==sz) {
        d_sink << "\\\\\n";
      } else {
        d_sink << "$\\ll$\n";
      };
   };
  } else DBG();

};
