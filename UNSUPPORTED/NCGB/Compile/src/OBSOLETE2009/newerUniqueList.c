// UniqueList.c

#ifndef INCLUDED_UNIQUELIST_H
#include "newerUniqueList.hpp"
#endif
#ifndef INCLUDED_VARIABLE_H
#include "nnVariable.hpp"
#endif
#include "RecordHere.hpp"
#include "MyOstream.hpp"

void UniqueList::addString(const char * const value,int i,
   const char * const tag) {
  if(strcmp(tag,"tex")==0) {
    d_vec[i]->d_texstring = value;
  } else DBG();
};

const char * const UniqueList::string(int i,const char * const tag) const {
  if(strcmp(tag,"tex")==0) {
    return d_vec[i]->d_texstring;
  } else DBG();
  return "not found";
};

void UniqueList::setComposite(const Composite & x,int i) {
  RECORDHERE(delete d_vec[i]->d_composite;)
  RECORDHERE(d_vec[i]->d_composite = new Composite(x);)
};

UniqueList * Variable::d_stringList = 0;
