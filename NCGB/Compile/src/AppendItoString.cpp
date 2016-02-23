#include "AppendItoString.hpp"
#include "RecordHere.hpp"
#ifndef INCLUDED_GBSTRING_H
#include "GBString.hpp"
#endif
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif

// My own append i to the end of a string function.
// The library class way (sprintf) is way to slow.


void AppendItoString(int i,GBString & aString) {
  char p[10];
  AppendItoStringHelper(i,p);
  aString += p;
};
