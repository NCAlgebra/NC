// VariableSet.h

#ifndef INCLUDED_VARIABLE_SET
#define INCLUDED_VARIABLE_SET

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"
#include "Variable.hpp"
#include "MyOstream.hpp"

class VariableSet {
  int d_sz;
  int d_low;
  int d_vec_sz;
  vector<bool> d_vec;
public:
  VariableSet() : d_sz(0),d_low(-999), d_vec_sz(0), d_vec() {
    d_vec.reserve(Variable::s_largestStringNumber()+1);
  };
  void clear();
  void setAll();
  bool full() const {
    return d_sz == (int)d_vec.size();
  };
  int size() const { 
    return d_sz;
  };
  void insert(const Variable & v);
  void remove(const Variable & v);
  bool present(const Variable & v) const {
    int n  = v.stringNumber();
    return n<(int)d_vec.size() && d_vec[n];
  };
  bool firstVariable(Variable & x) const {
    bool result = d_low!=-999;
    if(result) x = Variable::s_variableFromNumber(d_low);
    return result;
  };
  bool nextVariable(Variable & x) const {
    bool result = false;
    int n = x.stringNumber();
    ++n;
    while(!result && n<d_vec_sz) {
      result = d_vec[n];
      if(result) { 
        x = Variable::s_variableFromNumber(n);
        break;
      }; 
      ++n;
    };
    return result;
  };
  bool operator==(const VariableSet & x) const;
  bool operator!=(const VariableSet & x) const {
    return !operator==(x);
  };
  void Union(const VariableSet & x) {
    Variable var;
    bool b = x.firstVariable(var);
    while(b) {
      insert(var);
      b = x.nextVariable(var);
    };
  };
  void intersection(const VariableSet & x) {
    VariableSet y(*this);
    clear();
    Variable var1;
    Variable var2;
    bool b1 = x.firstVariable(var1);
    bool b2 = y.firstVariable(var2);
    while(b1&&b2) {
      if(var1==var2) {
        insert(var1);     
        b1 = x.nextVariable(var1);
        b2 = y.nextVariable(var2); 
      } else {
        if(var1.stringNumber()<var2.stringNumber()) {
          b1 = x.nextVariable(var1);
        } else {
          b2 = y.nextVariable(var2); 
        };
      };
    };
  };
  char * toString() const;
  char * toString(char beg,char mid,char end) const;
};
 
MyOstream & operator<<(MyOstream &,const VariableSet &);
#endif
