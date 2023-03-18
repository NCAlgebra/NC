// Mark Stankus 1999 (c)
// Holder.c


#include "Holder.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif
#include <stdlib.h>

void Holder::errorh(int n) {
  std::cerr << "Error on line " << n << " of the file Holder.c\n";
  exit(-333);
}; 

void Holder::errorc(int n) {
  std::cerr << "Error on line " << n << " of the file Holder.hpp\n";
  exit(-333);
}; 
