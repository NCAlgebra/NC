// UniqueList.c

#ifndef INCLUDED_UNIQUELIST_H
#include "UniqueList.hpp"
#endif
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#include "RecordHere.hpp"
#include "MyOstream.hpp"

void UniqueList::addString(const char * const value,int i,
   const char * const tag) {
  if(strcmp(tag,"tex")==0) {
    d_texstring[i] = value;
  } else DBG();
};

const char * const UniqueList::string(int i,const char * const tag) const {
  if(strcmp(tag,"tex")==0) {
    return d_texstring[i].chars();
  } else DBG();
  return "not found";
};

void UniqueList::setComposite(const Composite & x,int i) {
  RECORDHERE(delete d_composites[i];)
  RECORDHERE(d_composites[i] = new Composite(x);)
};

UniqueList * Variable::d_stringList = 0;
