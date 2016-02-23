// PrintSet.h

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "vcpp.hpp"
class MyOstream;

template<class T,class U> void PrintSet(MyOstream &,const char *,const set<T,U> &);
template<class T,class U> void PrintSet(const char *,const set<T,U> &);
