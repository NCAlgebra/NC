// Mark Stankus 1999 (c)
// TestIO.c

#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "MyOstream.hpp"


void _GetInteger(Source & so, Sink & si) {
  int x;
  so >> x;
  so.shouldBeEnd();
  GBStream << "integer:" << x << '\n';
  si.noOutput();
};

AddingCommand temp1TestIO("GetInteger",1,_GetInteger);

void _DoNothing(Source & so, Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp2TestIO("DoNothing",0,_DoNothing);

void _GetSymbol(Source & so, Sink & si) {
  symbolGB x;
  so >> x;
  so.shouldBeEnd();
  GBStream << "symbol:" << x.value().chars() << '\n';
  si.noOutput();
};

AddingCommand temp3TestIO("GetSymbol",1,_GetSymbol);

void _GetString(Source & so, Sink & si) {
  symbolGB x;
  so >> x;
  so.shouldBeEnd();
  GBStream << "symbol:" << x.value().chars() << '\n';
  si.noOutput();
};

AddingCommand temp4TestIO("GetString",1,_GetString);

void _GetListInt(Source & so, Sink & si) {
  int x;
  Source so2(so.inputNamedFunction("List"));
  while(!so2.eoi()) {
    so2 >> x;
    GBStream << "integer from list:" << x << '\n';
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp5TestIO("GetListInt",1,_GetListInt);

void _PutInteger(Source & so, Sink & si) {
  so.shouldBeEnd();
  si << 7;
};

AddingCommand temp6TestIO("PutInteger",0,_PutInteger);

void _PutSymbol(Source & so, Sink & si) {
  symbolGB x("hi");
  so.shouldBeEnd();
  si << x;
};

AddingCommand temp7TestIO("PutSymbol",1,_PutSymbol);

void _PutString(Source & so, Sink & si) {
  symbolGB x("there");
  so.shouldBeEnd();
  si << x;
};

AddingCommand temp8TestIO("PutString",1,_PutString);

void _PutListInt(Source & so, Sink & si) {
  so.shouldBeEnd();
  Sink si2(si.outputFunction("List",4));
  si2 << 1;
  si2 << 2;
  si2 << 3;
  si2 << 4;
};

AddingCommand temp9TestIO("PutListInt",1,_PutListInt);
