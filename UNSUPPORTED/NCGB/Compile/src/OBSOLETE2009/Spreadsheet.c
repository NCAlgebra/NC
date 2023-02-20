// Spreadsheet.c

#include "Spreadsheet.hpp"
#include "AdmWithLevels.hpp"
#include "GBStream.hpp"
#include "RecordHere.hpp"
#include "load_flags.hpp"
#include "PrintItOnALine.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

#include "FactControl.hpp"
#include "PrintGBList.hpp"
#include "GBList.hpp"

#ifndef INCLUDED_GRABVARIABLES_H
#include "GrabVariables.hpp"
#endif
#include "Variable.hpp"
#include "Debug1.hpp"
#ifndef INCLUDED_PRINTVECTOR_H
#include "PrintVector.hpp"
#endif
#pragma warning(disable:4786)
#ifndef INCLUDED_ALGO_H
#define INCLUDED_ALGO_H
#include <algorithm>
#endif

Spreadsheet::Spreadsheet() {
  DBG();
};

Spreadsheet::Spreadsheet(const FactControl & x,const AdmissibleOrder & order) 
   : d_rules(), 
     d_order((AdmissibleOrder *)(&order)), 
     d_digested(), d_userselected(), 
     d_categories(), d_singleRules(), d_singleVariables()
   { setUp(x); };

Spreadsheet::Spreadsheet(const vector<GroebnerRule> & x,
    const AdmissibleOrder & order)
   : d_rules(), 
     d_order((AdmissibleOrder *)(&order)), 
     d_digested(), d_userselected(), 
     d_categories(), d_singleRules(), d_singleVariables() { setUp(x); };


Spreadsheet::Spreadsheet(const Spreadsheet & x) :
  d_rules(x.d_rules),
  d_order(x.d_order),
  d_digested(x.d_digested),
  d_userselected(x.d_userselected),
  d_categories(x.d_categories),
  d_singleRules(x.d_singleRules),
  d_singleVariables(x.d_singleVariables) {};

void Spreadsheet::operator=(const Spreadsheet & x) {
  d_rules=x.d_rules;
  d_order=x.d_order;
  d_digested=x.d_digested;
  d_userselected=x.d_userselected;
  d_categories=x.d_categories;
  d_singleRules=x.d_singleRules;
  d_singleVariables=x.d_singleVariables;
};

bool Spreadsheet::operator==(const Spreadsheet & x) const {
  return d_rules==x.d_rules &&
         d_order==x.d_order &&
         d_digested==x.d_digested &&
         d_userselected==x.d_userselected &&
         d_categories==x.d_categories &&
         d_singleRules==x.d_singleRules &&
         d_singleVariables==x.d_singleVariables;
};


void Spreadsheet::addCategory(const Categories & x) {
  GBStream << x << '\n';
  int n = x.numberOfUnknowns();
GBStream << "MXS:unknowns:" << n << " elements in " << x << '\n';
  if(n>=(int) d_categories.size()) {
    d_categories.reserve(n+1);
    list<Categories> empty;
    while(n+1>= (int) d_categories.size()) d_categories.push_back(empty);
  };
  d_categories[n].push_back(x);
};

Categories * Spreadsheet::findCategory(const VariableSet & L) {
  Variable var;
  Categories * result = 0;
  int n = L.size();
  if(n>=(int) d_categories.size()) {
    Categories x;
    x.addUnknowns(L);
    addCategory(x);
    result = & (* d_categories[n].begin());
  } else {
    list<Categories> & M = d_categories[n];
    // Look for the category 
    const int sz = (int) M.size();
    list<Categories>::iterator w = M.begin();
    for(int i=1;i<=sz&&!result;++i,++w) {
      const Categories & z = *w;
      if(z.hasUnknowns(L)) {
        // We have found the category
        result = & (*w);
      };
    };
  };
  return result;
};

void Spreadsheet::setUp(const FactControl & x) {
  const GBList<int> & V = x.indicesOfPermanentFacts();
  GBList<int>::const_iterator w = V.begin();
  const int n = V.size();
//GBStream << "#:rules:" << n << '\n';
  d_rules.reserve(n);
  for(int i=0;i<n;++i,++w) {
    int j = *w;
    const GroebnerRule & r = x.fact(j);
    VariableSet variables;
    d_rules.push_back(r);
    int nfac = r.LHS().numberOfFactors();
    if(nfac==1) {
      d_singleRules.push_back(r);
      d_singleVariables.insert(*(r.LHS().begin()));
      d_digested.push_back(i);
    } else {
      GrabVariables(r,variables);
      VariableSet knownvariables,unknownvariables;
      ((AdmWithLevels *)d_order)->sortIntoKnownsAndUnknowns(
             variables,knownvariables,unknownvariables);
      Categories * ptr = findCategory(unknownvariables);
      if(!ptr) {
        RECORDHERE(ptr = new Categories(); )
        ptr->addUnknowns(unknownvariables);
        addCategory(*ptr); 
        RECORDHERE(delete ptr;)
        ptr = findCategory(unknownvariables);
        if(!ptr) DBG();
      };
      ptr->addKnowns(knownvariables);
      ptr->addRuleNumber(i);
GBStream << "Added or modified the category " << * ptr << '\n';
    };
  };
};

void Spreadsheet::addUserSelect(int i) {
   d_userselected.push_back(i);
};

void Spreadsheet::setUp(const vector<GroebnerRule> & x) {
  vector<GroebnerRule>::const_iterator w = x.begin();
  const int n = x.size();
  d_rules.reserve(n);
  for(int i=0;i<n;++i,++w) {
    const GroebnerRule & r = *w;
    d_rules.push_back(r);
    int nfac = r.LHS().numberOfFactors();
    if(nfac==1) {
      d_digested.push_back(i);
    } else {
      VariableSet variables, knownvariables,unknownvariables;
      GrabVariables(r,variables);
      const vector<int> & Levels = d_order->levels();
      Variable var;
      bool b = variables.firstVariable(var); 
      while(b) {
        if(Levels[var.stringNumber()]==1) {
          knownvariables.insert(var);
        } else {
          unknownvariables.insert(var);
        };
        b = variables.firstVariable(var); 
      };
      Categories * ptr = findCategory(unknownvariables);
      ptr->addKnowns(knownvariables);
      ptr->addRuleNumber(i);
    };
  };
};

void Spreadsheet::uglyprint(MyOstream & os) const {
  os << "The spreadsheet is the following:\n";
  os << "The rules are\n";
  PrintItOnALine<GroebnerRule> outr(os);
  PrintItOnALine<int> outi(os);
  for_each(d_rules.begin(),d_rules.end(),outr);
  os << "The digesteds are \n";
  for_each(d_digested.begin(),d_digested.end(),outi);
  os << "The user selects are \n";
  for_each(d_userselected.begin(),d_userselected.end(),outi);
  os << "The single Rules are \n";
  for_each(d_singleRules.begin(),d_singleRules.end(),outr);
  os << "d_singleVariables\n";
  Variable var;
  bool b = d_singleVariables.firstVariable(var);
  while(b) {
    os << var;
    b = d_singleVariables.nextVariable(var); 
  };
  os << "d_nonsingleVariables\n";
  b = d_nonsingleVariables.firstVariable(var);
  while(b) {
    os << var;
    b = d_nonsingleVariables.nextVariable(var); 
  };
  os << "The categories";
  typedef vector<list<Categories> >::const_iterator VI;
  typedef list<Categories>::const_iterator LI;
  VI w = d_categories.begin(), e = d_categories.end();
  int n = 1;
  while(w!=e) {
    os << "Going to output the " << n 
             << "th place on the vector which has "
             << (*w).size() << " elements.\n";
    LI w2 = (*w).begin(), e2 = (*w).end();
    while(w2!=e2) {
      os << "Going a category.\n";
      os << *w2;
      ++w2;
    };
    ++w;
  };
};
