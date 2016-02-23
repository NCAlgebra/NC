// Mark Stankus 1999 (c)
// DoubleDispatch.cpp

#include "DoubleDispatch.hpp"
#include "Debug1.hpp"

void DoubleDispatch::errorh(int n) { DBGH(n); };

void DoubleDispatch::errorc(int n) { DBGC(n); };
