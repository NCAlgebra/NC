// Categories.h

#ifndef INCLUDED_CATEGORIES_H
#define INCLUDED_CATEGORIES_H

#include "load_flags.hpp"
#include "RCountLock.hpp"
#include "VariableSet.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif
class MyOstream;
#include "vcpp.hpp"

class Categories {
  list<int> d_ruleNumbers;
  VariableSet d_knowns;
  VariableSet d_unknowns;
public:
  Categories();
  Categories(const Categories &);
  ~Categories(){};
  void operator =(const Categories &);
  bool operator ==(const Categories &) const;
  void addUnknowns(const VariableSet & x) {
    d_unknowns.Union(x);
  };
  void addKnowns(const VariableSet & x) {
    d_knowns.Union(x);
  };
  void addRuleNumber(int i) {
    d_ruleNumbers.push_back(i);
  };
  int numberOfUnknowns() const {
    return d_unknowns.size();
  };
  bool hasUnknowns(const VariableSet & x) const {
    return d_unknowns==x;
  };
  const list<int> & ruleNumbers() const { 
    return d_ruleNumbers;
  };
  const VariableSet & knowns() const { 
    return d_knowns;
  }
  const VariableSet & unknowns() const { 
    return d_unknowns;
  }
};

MyOstream & operator<<(MyOstream & os,const Categories &);
#endif
