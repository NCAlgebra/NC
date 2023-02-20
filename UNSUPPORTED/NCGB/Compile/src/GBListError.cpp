// (c) Mark Stankus 1999
// GBListError.c

#include "GBListError.hpp"
#include "Debug1.hpp"

void GBListError::errorh(int n) { DBGHF("GBList.hpp",n); };

void GBListError::errorc(int n) { DBGCF("GBList.cpp",n); };
