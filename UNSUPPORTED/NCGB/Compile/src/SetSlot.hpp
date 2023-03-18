// SetSlot.h

#ifndef INCLUDED_SETSLOT_H
#define INCLUDED_SETSLOT_H

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

template<class T>
void SetSlot(vector<T> & v,const T & t,int,const T &);
#endif
