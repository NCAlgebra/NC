// Pause.c

#ifdef USE_UNIX
#include <unistd.h>
#endif
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#pragma warning(disable:4786)
#include "compiler_specific.hpp"

void _Pause(Source & so,Sink & si) {
  int i;
  so >> i;
  so.shouldBeEnd();
  SLEEP(i);
  si.noOutput();
};

AddingCommand temp1Pause("NCGBPause",1,_Pause);
