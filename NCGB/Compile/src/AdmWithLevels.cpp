// AdmWithLevels.c

#include "AdmWithLevels.hpp"
#include "vcpp.hpp"
#include "GroebnerRule.hpp"
#include "PrintVector.hpp"
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "GBStream.hpp"
#include "MyOstream.hpp"
//#pragma warning(disable:4786)
#include <algorithm>

AdmWithLevels::AdmWithLevels(int id,const vector<vector<Variable> > & L) : 
      AdmissibleOrder(id), d_number_known_levels(1) {
  setVariables(L);
};

AdmWithLevels::AdmWithLevels(const AdmWithLevels & x) : AdmissibleOrder(s_ID),
    d_number_known_levels(x.d_number_known_levels), d_v(x.d_v), 
    _stringNumberToLevel(x._stringNumberToLevel) {};

AdmWithLevels::~AdmWithLevels(){};

void AdmWithLevels::error1(const Variable & v) const {
  GBStream << "The variable " <<  v << " is not in the order.\n"
           << "It will be considered known. This is AdmWithLevels at address\n"
           << this << '\n';
  errorc(__LINE__);
};

int AdmWithLevels::level(const Variable & v) const {
  int m = v.stringNumber();
  int n;
  if(m>(int) _stringNumberToLevel.size()) {
    error1(v);
    n = 1;
  } else {
    n = _stringNumberToLevel[m];
    if(n==-1) {
      error1(v);
      n = 1;
    }
  }
  return n;
};

const vector<int> & AdmWithLevels::levels() const {
  return _stringNumberToLevel;
};

void AdmWithLevels::setVariables(const vector<vector<Variable> > & L) {
  _stringNumberToLevel.erase(_stringNumberToLevel.begin(),
                             _stringNumberToLevel.end());
  d_v = L;
  const int max = Variable::s_largestStringNumber()+2;
  _stringNumberToLevel.reserve(max);
  for(int i=1;i<=max;++i) _stringNumberToLevel.push_back(-1);
  vector<vector<Variable> >::const_iterator w1 = L.begin(), e1 = L.end();
  int j = 1;
  while(w1!=e1) {
    const vector<Variable> & V = *w1;
    vector<Variable>::const_iterator w2 = V.begin(),e2  = V.end();
    while(w2!=e2) {
      _stringNumberToLevel[(*w2).stringNumber()]  = j;
      if(j<=d_number_known_levels) {
        d_knowns.insert(*w2);
      } else {
        d_unknowns.insert(*w2);
      };
      ++w2;
    };
    ++w1;++j;
  };
//  GBStream << "Warning 1\n";
};

void AdmWithLevels::setVariables(const vector<Variable> & L,int n) {
  vector<Variable> & V = d_v[n-1];
  vector<Variable>::const_iterator w = V.begin(), e = V.end();
  while(w!=e) {
    _stringNumberToLevel[(*w).stringNumber()] = -1;
    ++w;
  }; 
  V = L;
  w = V.begin(), e = V.end();
  while(w!=e) {
    _stringNumberToLevel[(*w).stringNumber()] = n;
    if(n<=d_number_known_levels) {
      d_knowns.insert(*w);
    } else {
      d_unknowns.insert(*w);
    };
    ++w;
  }; 
};

void AdmWithLevels::addVariable(const Variable & x,int n) {
  int m = x.stringNumber();
  int sz = _stringNumberToLevel.size();
  while(sz<=m) { _stringNumberToLevel.push_back(-1); ++sz;};
  if(_stringNumberToLevel[m]!=-1) {
    GBStream << "It has been requested that " << x << " be added to the "
             << "order. It will NOT be added since it is already in the "
             << "order.\n";
  } else {
    vector<Variable> empty;
    int sz = d_v.size();
    while(sz<n) {
      d_v.push_back(empty);
      ++sz;
    };
    d_v[n-1].push_back(x);
    _stringNumberToLevel[m]=n;
    if(n<=d_number_known_levels) {
      d_knowns.insert(x);
    } else {
      d_unknowns.insert(x);
    };
  };
};

// Print the order to the MyOstream os 
void AdmWithLevels::PrintOrderViaString(MyOstream & os,const char * s) const {
  if (d_v.size()==0) {
    os << "(Empty Order).\n";
  } else {
    bool needDouble = false;
    typedef vector<vector<Variable> >::const_iterator VVI;
    VVI w1 = d_v.begin(), e1 = d_v.end();
    int i = 1;
    while(w1!=e1) {
      if(needDouble) os << ' ' << s;
      const vector<Variable> & V = *w1;
      typedef vector<Variable>::const_iterator VI;
      VI w2 = V.begin(), e2 = V.end();
      if(w2==e2) {
        os << " (Empty Level) ";
      } else { 
        os << ' ' << (*w2).cstring();
        ++w2;
        while(w2!=e2) {
          os << " < " << (*w2).cstring();
          ++w2;
        }
      }
      if(s_print_knowns_bar && d_number_known_levels==i) {
         os << " |end-of-knowns| ";
      };
      needDouble = true;
      ++w1;++i;
    }
    os << '\n'; 
  }
};

VariableSet AdmWithLevels::variablesInOrder() const {
  VariableSet result;
  typedef vector<vector<Variable> >::const_iterator VI;
  VI w = d_v.begin(), e = d_v.end();
  while(w!=e) {
    const vector<Variable> & V = *w;
    vector<Variable>::const_iterator ww = V.begin(), ee = V.end();
    while(ww!=ee) {
      result.insert(*ww);
      ++ww;
    };
    ++w;
  };
  return result;
};

bool AdmWithLevels::variableLess(const Variable & x,const Variable & y) const {
  bool result = false;
  bool done = false;
  int n1 = level(x), n2 = level(y);
  if(x==y) {
    done = true;
  } else if(n1!=n2) {
    result = n1<n2;
    done = true;
  } else {
    const vector<Variable> & V = monomialsAtLevel(n1);
    vector<Variable>::const_iterator w = V.begin(), e = V.end();
    while(w!=e) {
      const Variable & v = *w;
      if(v==x) {
        done = true;
        result = true; 
        break;
      } else if(v==y) {
        done = true;
        result = false; 
        break;
      };
      ++w;
    };
  };
  if(!done) errorc(__LINE__);
  return result;
};

bool AdmWithLevels::s_print_knowns_bar = true;

#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif

const int AdmWithLevels::s_ID = idValue("AdmWithLevels::s_ID");

int AdmWithLevels::multiplicity() const {
  return d_v.size();
};

void AdmWithLevels::sortIntoKnownsAndUnknowns(const VariableSet & x,
    VariableSet & knowns,VariableSet & unknowns) const {
  knowns.clear();
  unknowns.clear();
  Variable v;
  bool b = x.firstVariable(v);
  while(b) {
    if(d_knowns.present(v)) {
       knowns.insert(v);
    } else {
       unknowns.insert(v);
    }; 
    b = x.nextVariable(v);
  };
};

void AdmWithLevels::errorh(int n) { DBGH(n); };

void AdmWithLevels::errorc(int n) { DBGC(n); };
