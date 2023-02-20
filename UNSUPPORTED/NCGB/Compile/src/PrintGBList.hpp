// PrintGBList.h

#include "GBList.hpp"
class MyOstream;

template<class T> void PrintGBList(const char *,const GBList<T> &);
template<class T> void PrintGBListStream(const char *,const GBList<T> &,MyOstream &);
