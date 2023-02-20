// (c) Mark Stankus 1999
// ListManager.c

#include "ListManager.hpp"
#include "RecordHere.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

#if 0
#include "Choice.hpp"
#ifdef USE_UNIX
#include "oListManager.c"
#else
#include "oListManager.cpp"
#endif
#else
#include "Choice.hpp"
#ifdef USE_UNIX
#include "nListManager.c"
#else
#include "nListManager.cpp"
#endif
#endif
