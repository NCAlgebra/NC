// symbolGB.h

#ifndef INCLUDED_SYMBOLGB_H
#define INCLUDED_SYMBOLGB_H

#include "simpleString.hpp"

class symbolGB {
  simpleString d_symbol;
public:
  symbolGB() : d_symbol() {};
  symbolGB(const simpleString & x) : d_symbol(x) {};
  symbolGB(const char * str) : d_symbol(str) {};
  ~symbolGB() {};
  void assign(const char * str) { d_symbol = str;};
  const simpleString & value() const { return d_symbol;};
  bool operator==(const char * x) const {
    return value()==x;
  };
  bool operator!=(const char * x) const {
    return !(value()==x);
  };
  bool operator==(const symbolGB & x) const {
    return value()==x.value();
  };
  bool operator!=(const symbolGB & x) const {
    return !(value()==x.value());
  };
};
#endif  
