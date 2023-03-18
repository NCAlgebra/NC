// (c) Mark Stankus 1999
// CompareOnDouble.cpp

#include "CompareOnDouble.hpp"
#include "Monomial.hpp"

#ifdef NEWMONOMIAL
#include "nCompareOnDouble.cpp"
#else
#include "oCompareOnDouble.cpp"
#endif
