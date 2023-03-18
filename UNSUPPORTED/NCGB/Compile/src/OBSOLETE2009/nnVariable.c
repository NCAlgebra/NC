// nnVariable.c

#include "nnVariable.hpp"
#include "RecordHere.hpp"
#ifndef INCLUDED_UNIQUELIST_H
#include "newerUniqueList.hpp"
#endif
#include "MyOstream.hpp"

int Variable::s_largestStringNumber() {
  return d_stringList ? d_stringList->largestNumber() : -1;
};

void Variable::s_newStringList() {
  RECORDHERE(delete d_stringList;)
  RECORDHERE(d_stringList = new UniqueList();)
};

void Variable::assign(const char * const x) {
  pair<char * const,UniqueList::Datum *> pr = 
          d_stringList->insertElement((char * const)x);
  d_num = pr.second->d_num;
  d_string = pr.first;
  d_texstring = &pr.second->d_texstring;
  d_composite = &pr.second->d_composite;
  d_cq_p = &pr.second->d_commutative;
};

MyOstream & operator << (MyOstream & os,const Variable & x) { 
  os << x.d_string;
  return os;
};

Variable Variable::s_variableFromNumber(int n) {
  return Variable(d_stringList->STRINGVEC()[n]);
};

#ifdef CHECK_VARIABLE
int ss_check_count = 0;

void Variable::check() const {
  ++ss_check_count;
#if 0
  GBStream << "ss_check_count:" << ss_check_count << '\n';
#endif
  if(stringNumber()<-2) DBG();
  if(stringNumber()>1000) DBG();
};
#endif

int Variable::s_numberOfVariablesOut = 0;

char * const Variable::s_Bogus_Variable_Name = "dumbVariable";

void Variable::composite(Composite & x) {
   * d_composite = new Composite(x);
};
