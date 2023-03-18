// Mark Stankus 1999 (c)
// CountedError.hpp

#include "CountedError.hpp"
#include "Debug1.hpp"

void  CountedError::errorh(int n) { DBGHF("CountedError.hpp",n); };
void  CountedError::errorc(int n) { DBGCF("CountedError.cpp",n); };
