// (c) Mark Stankus 1999
// MyOstream.hpp

#ifndef INCLUDED_MYOSTREAM_H
#define INCLUDED_MYOSTREAM_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#include "SimpleTable.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif
#include "StringAccumulator.hpp"
#include "PrinterAttributes.hpp"

using namespace std;

class MyOstream  {
  ostream * d_os_p;
  StringAccumulator * d_strings_p;
  PrinterAttributes d_attr;
  static void errorh(int);
  static void errorc(int);
public:
  MyOstream(ostream & os) : d_os_p(&os), d_strings_p(0) {};
  MyOstream(StringAccumulator & x) : d_os_p(0), d_strings_p(&x) {};
  void swap(ostream & os) { d_os_p = &os; d_strings_p = 0;};
  void swap(StringAccumulator & x) { d_os_p = 0; d_strings_p = &x;};
  const PrinterAttributes & attributes() const { return d_attr;};
  PrinterAttributes & attributes() { return d_attr;};
  bool ostreamvalid() const { return !!d_os_p;};
  ostream & getostream() { return * d_os_p;};
  bool accumulatorvalid() const { return !!d_strings_p;};
  StringAccumulator & getaccumulator() { return * d_strings_p;};
  MyOstream & operator<<(const char * x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(const void * x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      errorh(__LINE__);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(char x[]) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(char x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(unsigned int x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(int x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(long int x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
#ifdef USE_UNIX
  MyOstream & operator<<(long long int x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
#endif
  MyOstream & operator<<(double x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  MyOstream & operator<<(float x) {
    if(d_os_p) {
      (*d_os_p) << x;
    } else if(d_strings_p) {
      d_strings_p->add(x);
    } else errorh(__LINE__);
    return *this;
  };
  void flush() {
    if(d_os_p) {
      d_os_p->flush();
    } else if(d_strings_p) {
      // do nothing
    } else errorh(__LINE__);
  };
  void swapfiles(const char * extension,const char * base,int i);
  static SimpleTable<MyOstream> s_table;
  static const int s_ID;
};
#endif
