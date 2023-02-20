// expandVector.h

#ifndef INCLUDED_EXPANDVECTOR_H
#define INCLUDED_EXPANDVECTOR_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

template<class T>
void expandVector(vector<T> &,int,const T &);
#endif
