// Debug2.h 

#ifndef INCLUDED_DEBUG2_H 
#define INCLUDED_DEBUG2_H

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
class MyOstream;

using namespace std;

struct Debug2 {
  static vector<int> s_DebugDisownGBVector;
  static vector<int> s_traceNumbers;
  static MyOstream & s_Log(int n);
  static int s_setLogStream(MyOstream &);
private:
  static vector<MyOstream *> s_MyOstreams;
};
#endif
