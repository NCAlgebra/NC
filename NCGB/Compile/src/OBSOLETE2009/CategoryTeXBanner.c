// Mark Stankus 1999 (c)
// CategoryTeXBanner.c

#include "CategoryTeXBanner.hpp"
#include "ListRuleData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

CategoryTeXBanner::~CategoryTeXBanner() {};

void CategoryTeXBanner::writeVariableSet(ostream & os,const VariableSet & x) const {
  Variable var;
  bool b = x.firstVariable(var);
  os << '\{';
  if(b) {
    os << var;
    b = x.nextVariable(var);
    while(b) {
      os << ',' << var;
      b = x.nextVariable(var);
    };
  };
  os << '\}';
};

void CategoryTeXBanner::action(const BroadCastData & x) const {
  if(x.cancast(ListRuleData.ID()) DBG();
  const ListRuleData & y = (const ListRuleData &) x;
  AdmissibleOrder & ord = y.d_ord;
  MyOstream & os = y.d_os;
  TeXSink tex(os);
  const VariableSet & knowns = y.d_knowns;
  const VariableSet & unknowns = y.d_unknowns;
  const list<GroebnerRule> & rules = y.rules();
  os << "\\rule[3pt]{" << d_columnwidth << "in}{.7pt}\\\\\n";
  os << The expressions with unknown variables ";
  writeVariableSet(os,unknowns);
  os << "\\\\\n"; 
  os << "and knowns ";
  writeVariableSet(os,knowns);
  os << "\\smallskip\\\\\n";

  typedef list<GroebnerRule>::const_iterator LI;
  LI w = d_L.begin(), e = d_L.end();
  while(w!=e) {
    const GroebnerRule & item = *w;
    os <<  "\\begin{minipage}{",ColumnWidth,"in}\n$\n";
#if 0
     If[MemberQ[userselects,item]
       ,WriteString[stream,"\\Uparrow\\ \n"];
     ];
#endif
     tex << item;
     os << '\n';
     ++w;
     if(w!=e) {
       os << "\n$\n\\end{minipage}\\medskip \\\\\n";
     } else {
       os << "\n$\n\\end{minipage}\\\\\n";
     };
   };
};

Recipient * CategoryTeXBanner::clone() const {
  return new CategoryTeXBanner;
};
