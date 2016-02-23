// p9aux.c

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"


extern bool s_tipReduction;

void _TipReduction(Source & so,Sink & si) {
  int i;
  so >> i;
  so.shouldBeEnd();
  Debug1::s_not_supported("_TipReduction");
  si.noOutput();
};

AddingCommand temp1p9aux("TipReduction",1,_TipReduction);
