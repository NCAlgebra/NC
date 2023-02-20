// GBList.c

#include "ListChoice.hpp"

#ifdef USE_NEW_GBLIST
#include "Choice.hpp"
#include "nGBList.cpp"
#else
#include "Choice.hpp"
#include "oGBList.cpp"
#endif
