// Orders.c

#include "load_flags.hpp"
#include "Command.hpp"
#include "stringGB.hpp"
#pragma warning(disable:4687)
#include "Source.hpp"
#include "Sink.hpp"
#include "MyOstream.hpp"
#include "AdmWithLevels.hpp"

void _setMonOrd(Source & so,Sink & si) {
  int n;
  so >> n;
#ifdef PDLOAD
  Source source(so.inputNamedFunction("List"));
  Variable tree;
  AdmWithLevels & ORD = (AdmWithLevels &) AdmissibleOrder::s_getCurrent();
  while(!source.eoi()) {
    source >> tree;
    ORD.addVariable(tree, n);
  }
#else
  Debug1::s_not_supported("_setMonOrd");
#endif
  so.shouldBeEnd();
  si.noOutput(); 
} /* _setMonOrd */

AddingCommand temp1Orders("setMonomialOrder",2,_setMonOrd);
