// Mark Stankus 1999 (c)
// TestSubWorder.cpp

#include "Command.hpp"
#include "GBInput.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Monomial.hpp"
#include "SubWorder.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include <list>


void _CreateSubWorderAndPrint(Source & so,Sink & si) {
  list<Monomial> L;
  GBInput(L,so);
  so.shouldBeEnd();
  SubWorder sw;
  list<Monomial>::const_iterator w = L.begin(), e = L.end();
  while(w!=e) {
    sw.addWord(*w);
    ++w;
  };
  sw.print(GBStream);
  si.noOutput();
};

AddingCommand temp1TestSubWorder("CreateSubWorderAndPrint",1,
                                 _CreateSubWorderAndPrint);
