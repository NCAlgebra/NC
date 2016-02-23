// EchoIt.cpp

#include "Source.hpp"
#include "Sink.hpp"
#pragma warning(disable:4687)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "Command.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"


void _EchoItStrings(Source & so,Sink & si) {
  list<stringGB> L;
  stringGB x;
  while(!so.eoi()) {
    so >> x;
    L.push_back(x);
  };
  so.shouldBeEnd(); 
  const int sz = L.size();
  typedef list<stringGB>::const_iterator LI;
  LI w = L.begin(), e = L.end();
  Sink sink(si.outputFunction("List",sz));
  while(w!=e) {
    sink << *w;
    ++w;
  };
};

AddingCommand temp1EchoIt("EchoItStrings",1,_EchoItStrings);

void _EchoItSymbols(Source & so,Sink & si) {
  list<symbolGB> L;
  symbolGB x;
  while(!so.eoi()) {
    so >> x;
    L.push_back(x);
  };
  so.shouldBeEnd(); 
  const int sz = L.size();
  typedef list<symbolGB>::const_iterator LI;
  LI w = L.begin(), e = L.end();
  Sink sink(si.outputFunction("List",sz));
  while(w!=e) {
    sink << *w;
    ++w;
  };
};
 
AddingCommand temp2EchoIt("EchoItSymbols",1,_EchoItSymbols);
