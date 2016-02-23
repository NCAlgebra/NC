// Variable.c

#include "Variable.hpp"
#include "RecordHere.hpp"
#ifndef INCLUDED_UNIQUELIST_H
#include "UniqueList.hpp"
#endif
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
using namespace std;

int Variable::s_largestStringNumber() {
  return d_stringList ? d_stringList->largestNumber() : -1;
};

void Variable::s_newStringList() {
  RECORDHERE(delete d_stringList;)
  RECORDHERE(d_stringList = new UniqueList();)
};

Variable::Variable()   : d_num(0) {
  if(!d_stringList) DBG();
  pair<char *,bool *> pr(
        d_stringList->insertElement(d_num,"dumbVariable"));
#ifdef COPY_STRING
  d_string = new char[strlen(pr.first)+1];
  strcpy(d_string,pr.first);
#else
  d_string = pr.first;
#endif
  d_cq_p = pr.second;
  if(!d_string) DBG();
  if(!d_cq_p) DBG();
#ifdef CHECK_VARIABLE
  check();
#endif
};

Variable::Variable(const char * x) : d_num(0) { 
  ++s_numberOfVariablesOut;
  if(!d_stringList) DBG();
  pair<char *,bool *> pr(d_stringList->insertElement(d_num,x));
#ifdef COPY_STRING
  d_string = new char[strlen(pr.first)+1];
  strcpy(d_string,pr.first);
#else
  d_string = pr.first;
#endif
  d_cq_p = pr.second;
  if(!d_string) DBG();
  if(!d_cq_p) DBG();
#ifdef CHECK_VARIABLE
  check();
#endif
};

void Variable::assign(const char * const x) {
#ifdef CHECK_VARIABLE
  check();
#endif
  pair<char *,bool *> pr(d_stringList->insertElement(d_num,x));
#ifdef COPY_STRING
  d_string = new char[strlen(pr.first)+1];
  strcpy(d_string,pr.first);
#else
  d_string = pr.first;
#endif
  d_cq_p = pr.second;
  if(!d_string) DBG();
  if(!d_cq_p) DBG();
#ifdef CHECK_VARIABLE
  check();
#endif
};

void Variable::slowDelete() {
#ifdef CHECK_VARIABLE
  check();
#endif
};

MyOstream & operator << (MyOstream & os,const Variable & x) { 
  os << x.cstring();
  return os;
};

Variable Variable::s_variableFromNumber(int n) {
  return Variable(d_stringList->d_vec[n].first);
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


Composite * Variable::composite() const {
  return d_stringList->composite_p(stringNumber());
};

void Variable::composite(Composite & x) {
  d_stringList->setComposite(x,stringNumber());
};

const char * const Variable::texstring() const {
  return d_stringList->string(stringNumber(),"tex");
};

void Variable::texstring(const char * x) const {
  d_stringList->addString(x,stringNumber(),"tex");
};
