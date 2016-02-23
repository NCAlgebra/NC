// (c) Mark Stqnkus 1999 
// vectortemplates.cpp

#include "simpleString.hpp"
#include "Choice.hpp"
#include "GBVector.cpp"
#include "constiterGBVector.cpp"
#include "iterGBVector.cpp"
#pragma warning(disable:4661)

template class GBVector<bool>;
template class const_iter_GBVector<bool>;
template class iter_GBVector<bool>;
template class GBVector<int>;
template class const_iter_GBVector<int>;
template class iter_GBVector<int>;
template class GBVector<simpleString>;
template class const_iter_GBVector<simpleString>;
template class iter_GBVector<simpleString>;
