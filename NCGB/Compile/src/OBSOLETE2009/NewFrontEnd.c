// NewFrontEnd.c


bool s_inInitialize = true;
#include "GBStream.hpp"
#include "memwatch.h"
#include "SetUp.hpp"
#include "Source.hpp"
#include "MyOstream.hpp"
#include "Sink.hpp"
#include "StartEnd.hpp"
#include "symbolGB.hpp"
#include "GBInputNumbers.hpp"
#include "Command.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

using namespace std;

#include "choose_mynew.hpp"
#ifdef MYNEW
#include "Choice.hpp"
#ifdef USE_UNIX
#include "mynew.c"
#else
#include "mynew.cpp"
#endif
#endif
 

void readFileForCommands(const char * file) {
  symbolGB name;
  Source source;
  Sink sink;
  SetUp::s_CreateSourceSink(source,sink,file);
  while(source.getType()!=GBInputNumbers::s_IOEOF) {
    Source cmdsource(source.inputCommand(name));
GBStream << "Command:" << name.value().chars() << '\n';
    execute_command(name.value().chars(),cmdsource,sink);
    source.setNotEndOfInput();
  };
};

int main(int argc, char * argv[]) {
#ifdef MYNEW
  set_new_handler(out_of_store);
#endif
  AddingStart::s_print();
  AddingStart::s_execute();
  s_inInitialize = false;
  char * file = 0;
  if(argc==2) { 
    file = argv[1];
  } else {
    file = "code.nca";
    file = "code3.nca";
    GBStream << "You should supply a filename.\n";
    GBStream << "The file name \"" << file << "\" is assumed.\n";
  };
  readFileForCommands(file);
  return 0;
};
