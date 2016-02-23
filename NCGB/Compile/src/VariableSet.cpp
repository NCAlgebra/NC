// VariableSet.c

#include "VariableSet.hpp"
#include "StringAccumulator.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

MyOstream & operator<<(MyOstream & os,const VariableSet & x) {
  Variable var;
  bool b = x.firstVariable(var);
  os << '{';
  if(b) {
    os << var;
    b = x.nextVariable(var);
    while(b) {
      os << ',' << var;
      b = x.nextVariable(var);
    };
  };
  os << '}';
  return os;
};

char * VariableSet::toString() const {
  return toString('\0',',','\0');
};

char * VariableSet::toString(char beg,char mid,char end) const {
  StringAccumulator acc;
  Variable var;
  bool b = firstVariable(var);
  if(beg!='\0') acc.add(beg);
  if(b) {
    acc.add(var.cstring());
    b = nextVariable(var);
    while(b) {
      if(mid!='\0') acc.add(mid);
      acc.add(var.cstring());
      b = nextVariable(var);
    };
  };
  if(end!='\0') acc.add(end);
  char * result = new char[strlen(acc.chars())+1];
  strcpy(result,acc.chars());
  return result;
};

void VariableSet::clear() {
  d_sz = 0;
  d_low = -999;
  typedef vector<bool>::iterator VI;
  VI w = d_vec.begin(), e = d_vec.end();
  while(w!=e) {
    *w = false;
    ++w;
  };
};

void VariableSet::setAll() {
  d_sz = d_vec_sz;
  d_low = 0;
  typedef vector<bool>::iterator VI;
  VI w = d_vec.begin(), e = d_vec.end();
  while(w!=e) {
    *w = true;
    ++w;
  };
};

bool VariableSet::operator==(const VariableSet & x) const {
  bool result = d_sz==x.d_sz;
  if(result&&d_sz>0) {
    Variable v1,v2;
    bool b1 = firstVariable(v1);
    bool b2 = x.firstVariable(v2);
    while(b1&&b2&&v1==v2) {
      b1 = nextVariable(v1);
      b2 = x.nextVariable(v2);
    };
    if(b1!=b2) DBG();
    result = v1==v2;
  };
//GBStream << "Comparing " << *this << " to " << x << " gives " << result << '\n';
  return result;
};

void VariableSet::insert(const Variable & v) {
  if(v==Variable()) DBG();
  int n  = v.stringNumber();
  if(d_vec_sz<=n) {
    d_vec.reserve(n+1);
    while(d_vec_sz<=n) {
      d_vec.push_back(false);
      ++d_vec_sz;
    };
  };
  if(!d_vec[n]) {
    ++d_sz;
    d_vec[n] = true;
    if(d_low==-999 || n<d_low) {
      d_low=n;
    };
  };
};

void VariableSet::remove(const Variable & v) {
  if(v==Variable()) DBG();
  const int n  = v.stringNumber();
  if(n<(int)d_vec.size()) {
    if(d_vec[n]) {
      --d_sz;
      d_vec[n] = false;
      if(d_vec_sz==0) {
        d_low=-999;
      } else if(n==d_low) {
        ++d_low;
        while(!d_vec[d_low]) ++d_low;
      };
    };
  };
};
