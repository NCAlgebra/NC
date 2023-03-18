// Mark Stankus 1999 (c)
// Timers.c

#include "AllTimings.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"


void _CreateTimer(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  AllTimings temp;
};

AddingCommand temp1Timers("CreateTimer",0,_CreateTimer);
