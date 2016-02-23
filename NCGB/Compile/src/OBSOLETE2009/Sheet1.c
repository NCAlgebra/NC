// Sheet1.c

#include "Sheet1.hpp"
#include "MyOstream.hpp"
#include "RecordHere.hpp"
#include "AdmWithLevels.hpp"
#include "PrintItOnALine.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif
#ifndef INCLUDED_GRABVARIABLES_H
#include "GrabVariables.hpp"
#endif
#include "Variable.hpp"
#include "Debug1.hpp"
#ifndef INCLUDED_ALGO_H
#define INCLUDED_ALGO_H
#include <algorithm>
#endif

Sheet1::Sheet1() { DBG(); };

Sheet1::Sheet1(const vector<GroebnerRule> & x,const AdmissibleOrder & order)
  : d_order(&order), d_by(order),
  d_number_of_unknowns_to_unknowns(),
  d_unknowns_to_knowns(d_by),
  d_the_categories(d_by),
  d_not_solved_for(), d_solved_for(), d_var_to_rule(),
  d_userselected(), d_number_known_levels(1) {
  typedef vector<GroebnerRule>::const_iterator VI;
  VI w = x.begin(), e = x.end();
  while(w!=e) {
    addRule(*w);
    ++w;
  };
};

void Sheet1::NumberKnownLevels(int i) { 
  Variable v;
  if(i<d_number_known_levels) {
    // Go through the unknowns and see if they become known.
    bool changed = true;
    while(changed) {
      changed = false;
      bool b = d_knowns.firstVariable(v);
      while(b) {
        if(((AdmWithLevels *)d_order)->level(v)>i) {
          d_knowns.remove(v);
          d_unknowns.insert(v);
          changed = true;
          break;
        };
        b = d_knowns.nextVariable(v);
      };
    };
  } else if(i>d_number_known_levels) {
    // Go through the knowns and see if they become unknown.
    bool changed = true;
    while(changed) {
      changed = false;
      bool b = d_unknowns.firstVariable(v);
      while(b) {
        if(((AdmWithLevels *)d_order)->level(v)<=i) {
          d_unknowns.remove(v);
          d_knowns.insert(v);
          changed = true;
          break;
        };
        b = d_unknowns.nextVariable(v);
      };
    };
  };
  d_number_known_levels = i;
}

void Sheet1::addRule(const GroebnerRule & x) {
  VariableSet v,unk,kn;
  GrabVariables(x,v);
  ((AdmWithLevels *) d_order)->sortIntoKnownsAndUnknowns(v,kn,unk);
  bool new_category = false;
  map<int,list<VariableSet>,less<int> >::iterator  w = 
     d_number_of_unknowns_to_unknowns.find(unk.size()); 
  if(w==d_number_of_unknowns_to_unknowns.end()) {
     list<VariableSet> L;
     L.push_back(unk);
     pair<const int,list<VariableSet> >pr(unk.size(),L);
     d_number_of_unknowns_to_unknowns.insert(pr); 
     new_category = true;
  } else {
     list<VariableSet> & L = (*w).second; 
     typedef list<VariableSet>::const_iterator LI;
     LI ww = L.begin(), ee = L.end();
     while(ww!=ee) {
       if(*ww==unk) {
         break;
       };
       ++ww;
     };
     if(ww==ee) {
       L.push_back(unk);
       new_category = true;
     };
  }; 
  if(new_category) {
    pair<const VariableSet,VariableSet> pr(unk,kn);
    d_unknowns_to_knowns.insert(pr);
    set<GroebnerRule,ByAdmissible> S(d_by);
    S.insert(x);
    pair<const VariableSet,set<GroebnerRule,ByAdmissible> > pr2(unk,S);
    d_the_categories.insert(pr2);
  } else {
    d_unknowns_to_knowns[unk].Union(kn);
    map<VariableSet,set<GroebnerRule,ByAdmissible>,
        ByAdmissible>::iterator ww;
    ww = d_the_categories.find(unk);
    if(ww==d_the_categories.end()) DBG();
    (*ww).second.insert(x);
  };
  if(x.LHS().numberOfFactors()==1) {
    const Variable & v = * x.LHS().begin();
    d_not_solved_for.remove(v);
    d_solved_for.insert(v); 
    d_var_to_rule.push_back(x);
  };
};

void Sheet1::addUserSelect(const GroebnerRule & r) {
   removeRule(r);
   d_userselected.push_back(r);
};

void Sheet1::removeRule(const GroebnerRule &) {
  DBG();
};

void Sheet1::uglyprint(MyOstream & os) const {
  os << "The order:";
  d_order->PrintOrder(os);
  os << '\n';

  typedef map<int,list<VariableSet>,less<int> > MAP1;
  MAP1::const_iterator w1 = d_number_of_unknowns_to_unknowns.begin();
  MAP1::const_iterator e1 = d_number_of_unknowns_to_unknowns.begin();
  while(w1!=e1) {
    DBG();
    ++w1; 
  };
};
