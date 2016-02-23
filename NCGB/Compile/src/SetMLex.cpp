// SetMLex.c

#include "CreateOrder.hpp"
#ifndef INCLUDED_GBINPUT_H
#include "GBInput.hpp"
#endif
#include "Source.hpp"
#include "Sink.hpp"
#include "Choice.hpp"
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#ifndef INCLUDED_MLEX_H
#include "MLex.hpp"
#endif
#ifndef INCLUDED_ORDERTYPE_H
#include "OrderType.hpp"
#endif
#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"

#include "vcpp.hpp"


void GBInput(vector<vector<Variable> > & x,Source & so) {
  x.erase(x.begin(),x.end());
  Variable v;
  Source counted1(so.inputNamedFunction("List"));
  while(!counted1.eoi()) {
    Source counted2(counted1.inputNamedFunction("List"));
    vector<Variable> V1;
    while(!counted2.eoi()) {
      counted2 >> v;
      V1.push_back(v);
    };
    x.push_back(V1);
  };
};

void _SetMLex(Source & so,Sink & si) {
  vector<vector<Variable> > V2;
  GBInputSpecial(V2,so);
  so.shouldBeEnd();
  si.noOutput();
  setOrderAdopt(new MLex(V2));
};

AddingCommand temp1SetMLex("SetMLex",1,_SetMLex);
