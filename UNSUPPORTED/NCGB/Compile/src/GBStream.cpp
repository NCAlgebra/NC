// Mark Stankus 1999 (c)
// GBStream.c


#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif

MyOstream GBStream(cerr);
MyOstream NBStream(cerr);
MyOstream DEBBStream(cerr);
MyOstream WARNStream(cerr);
