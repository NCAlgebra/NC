// p13aux.c

#include "Source.hpp"
#include "Sink.hpp"
#include "AltInteger.hpp"
#include "Command.hpp"


void _UseGCDs(Source & so,Sink & si) {
  int yn;
  so >> yn;
  so.shouldBeEnd();
  INTEGER::gcds(yn);
  si.noOutput();
};

AddingCommand temp1p13aux("UseGCDs",1,_UseGCDs);
