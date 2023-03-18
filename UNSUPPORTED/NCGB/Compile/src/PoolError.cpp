// (c) Mark Stankus 1999
// PoolError.c

#include "PoolError.hpp"
#include "Debug1.hpp"

void PoolError::errorh(int n) { DBGHF("Pool.hpp",n); };

void PoolError::errorc(int n) { DBGCF("Pool.cpp",n); };
