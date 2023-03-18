// Sheet1.h

#ifndef INCLUDED_SHEET1_H
#define INCLUDED_SHEET1_H

class MyOstream;
#include "AdmissibleOrder.hpp"
#include "ByAdmissible.hpp"
#include "VariableSet.hpp"
#include "GroebnerRule.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "vcpp.hpp"

class Sheet1 {
  const AdmissibleOrder * d_order;
  ByAdmissible d_by;
  map<int,list<VariableSet>,less<int> > d_number_of_unknowns_to_unknowns;
  map<VariableSet,VariableSet,ByAdmissible> d_unknowns_to_knowns;
  map<VariableSet,set<GroebnerRule,ByAdmissible>,ByAdmissible > 
             d_the_categories;
  VariableSet d_not_solved_for;
  VariableSet d_solved_for;
  list<GroebnerRule> d_var_to_rule;
  list<GroebnerRule> d_userselected;
  void addRule(const GroebnerRule & r);
  void removeRule(const GroebnerRule & r);
  int d_number_known_levels;
  VariableSet d_knowns, d_unknowns;
public:
  Sheet1();
  Sheet1(const vector<GroebnerRule> & x,const AdmissibleOrder & ord);
  Sheet1(const Sheet1 &);
  void NumberKnownLevels(int);
  int NumberKnownLevels() { 
    return d_number_known_levels;
  };
  void operator=(const Sheet1 &);
  ~Sheet1(){};
  void setUp(const vector<GroebnerRule> &);
  void addUserSelect(const GroebnerRule &);
  const AdmissibleOrder & order() const { return * d_order;};
  bool operator==(const Sheet1 &) const;
  void uglyprint(MyOstream &) const;
  const map<int,list<VariableSet>,less<int> > NumberUnknownToKnown() const {
    return d_number_of_unknowns_to_unknowns;
  };
  const map<VariableSet,VariableSet,ByAdmissible> &
     UnknownsToKnowns() const {
    return d_unknowns_to_knowns;
  };
  const map<VariableSet,set<GroebnerRule,ByAdmissible>,ByAdmissible > &
        theCategories() const {
    return d_the_categories;
  };
  const VariableSet & notSolvedFor() const {
    return d_not_solved_for;
  };
  const VariableSet & solvedFor() const {
    return d_solved_for;
  };
  const list<GroebnerRule> & VarToRule() const {
    return d_var_to_rule;
  };
  const list<GroebnerRule> & userselected() const {
    return d_userselected;
  };
};
#endif
