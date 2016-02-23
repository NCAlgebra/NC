// p11c_aux3.c

#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#include "stringGB.hpp"
#ifndef INCLUDED_ALLTIMINGS_H
#include "AllTimings.hpp"
#endif
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "Composite.hpp"
#include "Command.hpp"

// ------------------------------------------------------------------

#ifdef WANT_CPlusPlusMemoryUsageCPlusPlusMemoryUsage_NO
void _CPlusPlusMemoryUsage(Source& so,Sink  & si) {
  so.shouldBeEnd();
  Debug1::s_not_supported("_CPlusPlusMemoryUsage");
  si.noOutput(ioh);
};  /* _CPlusPlusMemoryUsage */
AddingCommand temp1p3aux("CPlusPlusMemoryUsage",0,_CPlusPlusMemoryUsage);
#endif

// ------------------------------------------------------------------

void _setTiming(Source & so,Sink  & si) {
  int x;
  so >> x;
  so.shouldBeEnd(); 
  si.noOutput();
  AllTimings::s_setTiming(x!=0);
};

AddingCommand temp2p3aux("setTiming",1,_setTiming);

// ------------------------------------------------------------------

void _setTeXString(Source & so,Sink & si) {
  Variable v;
  stringGB x;
  Source source(so.inputNamedFunction("List"));
  while(!source.eoi()) {
    Source source2(source.inputNamedFunction("List"));
    source2 >> v >> x;
    v.texstring(x.value().chars());
  };
  so.shouldBeEnd(); 
  si.noOutput();
};

AddingCommand temp3p3aux("setTeXString",1,_setTeXString);

// ------------------------------------------------------------------

void _setComposites(Source & so,Sink & si) {
  Variable v;
  Source source(so.inputNamedFunction("List"));
  while(!source.eoi()) {
    Source source2(source.inputNamedFunction("List"));
    source2 >> v;
    Composite comp(GetComposite(source2));
    v.composite(comp);
  };
  so.shouldBeEnd(); 
  si.noOutput();
};

AddingCommand temp4p3aux("setComposites",1,_setComposites);

// ------------------------------------------------------------------

void _getTeXString(Source & so,Sink & si) {
  Variable v;
  so >> v;
  so.shouldBeEnd();
  GBOutputString(v.texstring(),si);
};

AddingCommand temp5p3aux("getTeXString",1,_getTeXString);
