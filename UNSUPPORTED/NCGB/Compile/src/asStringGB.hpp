// (c) Mark Stankus 1999
// asStringGB.h

#ifndef INCLUDED_ASSTRINGGB_H
#define INCLUDED_ASSTRINGGB_H

#include "simpleString.hpp"

class asStringGB {
  simpleString d_string;
public:
  asStringGB() : d_string() {};
  asStringGB(const char * str) : d_string(str) {};
  asStringGB(const simpleString & x) : d_string(x) {};
  ~asStringGB() {};
  void assign(const char * str) { d_string = str;};
  const simpleString & value() const { return d_string;};
};
#endif  
