// Mark Stankus 1999 (c)
// GraphVertex.cpp

#include "GraphVertex.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif

void GraphVertex::errorh(int n) { 
   cerr << "Erron on line " << n << " of the file GraphVertex.hpp\n";
   exit(-222);
};

void GraphVertex::errorc(int n) { 
   cerr << "Erron on line " << n << " of the file GraphVertex.hpp\n";
   exit(-222);
};
