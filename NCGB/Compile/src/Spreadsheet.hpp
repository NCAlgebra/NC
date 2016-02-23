// Spreadsheet.h

#ifndef INCLUDED_SPREADSHEET_H
#define INCLUDED_SPREADSHEET_H

#include "load_flags.hpp"
class MyOstream;
#include "AdmissibleOrder.hpp"
#include "VariableSet.hpp"
class FactControl;
#include "Categories.hpp"
#include "GroebnerRule.hpp"
//#pragma warning(disable:4786)
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
#include "vcpp.hpp"

class Spreadsheet {
public:
  Spreadsheet();
  vector<GroebnerRule> d_rules;
  AdmissibleOrder * d_order; 
  list<int> d_digested;
  list<int> d_userselected;
  vector<list<Categories> > d_categories;
    // d_categories[i] has i unknowns
  list<GroebnerRule> d_singleRules;
  VariableSet d_singleVariables;
  VariableSet d_nonsingleVariables;
  Categories * findCategory(const VariableSet & L);
  Categories * findCategory(const vector<bool> &);
  void addCategory(const Categories &);
public:
   Spreadsheet(const FactControl & x,const AdmissibleOrder & order);
   Spreadsheet(const vector<GroebnerRule> & x,const AdmissibleOrder & order);
  Spreadsheet(const Spreadsheet &);
  void operator=(const Spreadsheet &);
   ~Spreadsheet(){};
   void setUp(const FactControl &);
   void setUp(const vector<GroebnerRule> &);
   void addUserSelect(int);
   const list<int> & digested() const { return d_digested;};
   const list<int> & userselected() const { return d_userselected;};
   const vector<list<Categories> > & categories() const {
     return  d_categories;
   };
   const list<GroebnerRule> & singleRules() const {
     return d_singleRules;
   };
   const VariableSet & singleVariables() const {
     return d_singleVariables;
   };
   const VariableSet & nonsingleVariables() const {
     return d_nonsingleVariables;
   };
   const vector<GroebnerRule> & RULES() const {
     return d_rules;
   };
   const AdmissibleOrder & order() const { return * d_order;};
   bool operator==(const Spreadsheet &) const;
   void uglyprint(MyOstream &) const;
};
#endif
