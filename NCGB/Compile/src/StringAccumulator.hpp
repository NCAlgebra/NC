// StringAccumulator.h

#ifndef INCLUDED_STRINGACCUMULATOR_H
#define INCLUDED_STRINGACCUMULATOR_H

//#pragma warning(disable:4786)
#include "StringAccumulator.hpp"
#include "Choice.hpp"
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif
#include "vcpp.hpp"

class StringAccumulator {
  static void errorh(int);
  static void errorc(int);
  StringAccumulator(const StringAccumulator &);
    // not implemented
  void operator=(const StringAccumulator &);
    // not implemented
private:
  mutable char * d_result;
  vector<char *> d_v;
  int d_sz;
public:
  StringAccumulator() : d_v(), d_sz(0) {
    d_result = (char *) 0;
  };
  ~StringAccumulator();
  void clear();
  int size() const { return d_sz;};
  void add(const char * const);
  void add(const char);
  void add(unsigned int);
  void add(int);
  void add(long int);
#ifdef USE_UNIX
  void add(long long int);
#endif
  void add(float);
  void add(double);
  const char * const chars() const;
}; 
#endif
