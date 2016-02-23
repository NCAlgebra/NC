// (c) Mark Stankus 1999
// SimpleTableError.c

#include "SimpleTableError.hpp"
#include "Debug1.hpp"

void SimpleTableError::errorh(int n) { DBGHF("SimpleTable.hpp",n); };

void SimpleTableError::errorc(int n) { DBGCF("SimpleTable.cpp",n); };
