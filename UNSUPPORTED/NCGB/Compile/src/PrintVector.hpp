// PrintVector.h

//#pragma warning(disable:4876)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

template<class T> void PrintVector(const char *,const vector<T> &,
     const char * x = "\n");
