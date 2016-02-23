// stringGB.h

#ifndef INCLUDED_STRINGGB_H
#define INCLUDED_STRINGGB_H

#include "simpleString.hpp"
#include "MyOstream.hpp"

class stringGB {
  simpleString d_string;
public:
  stringGB() : d_string() {};
  stringGB(const char * str) : d_string(str) {};
  stringGB(const simpleString & x) : d_string(x) {};
  ~stringGB() {};
  void assign(const char * str) { d_string = str;};
  const simpleString & value() const { return d_string;};
  bool operator==(const char * x) const {
    return value()==x;
  };
};

inline MyOstream & operator<<(MyOstream & x,const stringGB & y) {
  x << y.value();
  return x;
};
#endif  
