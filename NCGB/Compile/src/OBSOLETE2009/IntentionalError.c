// IntentionalError.c

#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"


void _IntentionalError(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp1IntentionalError("IntentionalError",0,_IntentionalError);
