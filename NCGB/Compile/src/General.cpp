// Mark Stankus 1999 (c) 
// general.c 

#include "GBStream.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "stringGB.hpp"
#include "Command.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <fstream>
#else
#include <list.h>
#include <fstream.h>
#endif
#include <stdlib.h> 
  // for system()

void printAllCommands();

#include "load_flags.hpp"
#include "vcpp.hpp"
#include "MyOstream.hpp"

void getAllCommands(list<simpleString> & L) ;

void _PrintAllCommands(Source & so,Sink & si) {
  so.shouldBeEnd();
  printAllCommands();
  si.noOutput();
};

AddingCommand temp1general("PrintAllCommands",0,_PrintAllCommands);

void _GetAllCommands(Source & so,Sink & si) {
  so.shouldBeEnd();
  list<simpleString> L;
  getAllCommands(L);
  long sz  = L.size();
  Sink sink(si.outputFunction("List",sz));
  GBStream << "Begin loop\n";
  list<simpleString>::const_iterator w = L.begin();
  for(long i=1L;i<=sz;++i,++w) {
    sink.putString((*w).chars());
  };
  GBStream << "Done with " << sz << "elements!\n";
};

AddingCommand temp2general("GetAllCommands",0,_GetAllCommands);


void _NCGBQuit() {
  GBStream.flush();
  if(GBStream.ostreamvalid()&&(&GBStream.getostream()!=&cerr)) {
    ((ofstream *) (&GBStream.getostream()))->close();
  };
  exit(0);
};

void _NCGBQuit(Source &,Sink &) {
  _NCGBQuit();
};

AddingCommand temp3general("NCGBQuit",1,_NCGBQuit);

void _NCGBComment(Source & so,Sink & si) {
  so.passString();
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp4general("NCGBComment",1,_NCGBComment);

void _UnixDo(Source & so,Sink & si) {
  stringGB s;
  so >> s;
  so.shouldBeEnd();
  si.noOutput();
  system(s.value().chars());
};

AddingCommand temp5general("UnixDo",1,_UnixDo);

#include "StartEnd.hpp"

class sayHiToUser : public AnAction {
public:
  sayHiToUser() : AnAction("sayHiToUser") {};
  void action() {
    GBStream << "> You are using the program NCGB.\n";
  };
};

AddingStart temp1General(new sayHiToUser);
