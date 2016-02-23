// Mark Stankus 1999 (c)
// BiMap.cpp

#include "BiMap.hpp"

#include "Polynomial.hpp"
#include "ByAdmissible.hpp"
#include "SFSGExtra.hpp"

template class BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible>;
