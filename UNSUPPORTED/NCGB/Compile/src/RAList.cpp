// Mark Stankus 1999 (c)
// RAList.cpp


#include "Debug1.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"

void RAListAccessHold(int n) {
  GBStream << "An attempt was made to access a hole in an RAList.\n";
  GBStream <<  "Did you try to access a marker which was destroyed?\n";
  GBStream << "It was marker number: " << n << " of unknown type (sorry).\n";
  DBG();
};

void RAListMarkerOutOfRange(int n) {
  GBStream << "Tried to access a marker number out of range.\n";
  GBStream << "The number was " << n << '\n';
  DBG();
};
