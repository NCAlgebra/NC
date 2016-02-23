// Categories.c

#include "Categories.hpp"
#include "load_flags.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_PRINTLIST_H
#include "PrintList.hpp"
#endif
//#pragma warning(disable:4786)
#ifndef INCLUDED_ALGO_H
#define INCLUDED_ALGO_H
#include <algorithm>
#endif
#include "VariableSet.hpp"
#include "MyOstream.hpp"

Categories::Categories() { };

Categories::Categories(const Categories & x)  :
    d_ruleNumbers(x.d_ruleNumbers), 
    d_knowns(x.d_knowns),
    d_unknowns(x.d_unknowns) {}; 

void Categories::operator =(const Categories & x)  {
  d_ruleNumbers = x.d_ruleNumbers;
  d_knowns = x.d_knowns;
  d_unknowns = x.d_unknowns;
};

bool Categories::operator ==(const Categories & x)  const {
  return d_knowns == x.d_knowns &&
         d_ruleNumbers == x.d_ruleNumbers &&
         d_unknowns == x.d_unknowns;
};

MyOstream & operator<<(MyOstream & os,const Categories & x) {
  PrintList("d_ruleNumbers",x.ruleNumbers());
  os << x.knowns();
  os << x.unknowns();
  return os;
};
