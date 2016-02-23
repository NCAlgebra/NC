//
// This file allows one to ``retire" functions
// from _tramps without having to renumber.
//

#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif


void _NotSupported(Source & so,Sink & si) { 
  Debug1::s_not_supported(); 
  so.shouldBeEnd();
  si.noOutput();
};

void _LinkAlive(Source & so,Sink & si) { 
  so.shouldBeEnd();
  symbolGB out("True");
  si << out;
};

AddingCommand temp1Obsolete("LinkAlive",0,_LinkAlive); 
