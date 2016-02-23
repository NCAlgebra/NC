// UniqueList.c

#ifndef INCLUDED_UNIQUELIST_H
#include "UniqueList.hpp"
#endif
#include "RecordHere.hpp"
#include "MyOstream.hpp"
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif

void UniqueList::error1() const {
  GBStream << d_zeroCount << '\n';
  errorc(__LINE__);
};

const char * const UniqueList::string(int i,const char * const tag) const {
  if(strcmp(tag,"tex")==0) {
    return d_texstring[i].chars();
  } else errorc(__LINE__);
  return "not found";
};

void UniqueList::addString(const char * const value,int i,
     const char * const tag) {
  if(strcmp(tag,"tex")==0) {
    d_texstring[i] = value;
  } else errorc(__LINE__);
};

void UniqueList::setComposite(const Composite & x,int i) {
  RECORDHERE(delete d_composites[i];)
  RECORDHERE(d_composites[i] = new Composite(x);)
};

UniqueList * Variable::_stringList = 0;

void UniqueList::errorh(int n) { DBGH(n); };

void UniqueList::errorc(int n) { DBGC(n); };
