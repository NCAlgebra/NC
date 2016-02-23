// ncgbfrontend.c

#include "GBInput.hpp"
#include "GBOutput.hpp"
#include "GBStream.hpp"
#include "Command.hpp"
#include "MmaSource.hpp"
#include "MmaSink.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "symbolGB.hpp"
#include "StartEnd.hpp"
//#define DEBUG_COMMANDS
//#define TELL_COMMANDS
extern "C" {
#include "mathlink.h"

extern MLINK stdlink;
}

bool s_inInitialize = true;

//#include "choose_mynew.h"
#ifdef MYNEW
#include "mynew.h"
#endif

MmaSource * s_mma_source_p = 0;
MmaSink * s_mma_sink_p = 0;

void printAllCommands();

void NCGBStartUpMma() {
  GBStream << "> We are in the command NCGBStartUpMma\n"; GBStream.flush();
  // New packet covered by ncgbfrontendtm.c
  symbolGB name;
  delete s_mma_source_p;
  delete s_mma_sink_p;
  s_mma_source_p = new MmaSource(stdlink);
  s_mma_sink_p = new MmaSink(stdlink);
  char * string = new char[1];
  string[0] = '\n';
  if(!MLNewPacket(stdlink)) DBG();
  if(!MLPutSymbol(stdlink,"Null")) DBG();
//  printAllCommands();
  GBStream << "< We are done with the command NCGBStartUpMma\n"; GBStream.flush();
};

void NCGBShutDownMma() {
  GBStream << "> We are in the command NCGBShutDownMma\n"; GBStream.flush();
  // New packet covered by ncgbfrontendtm.c
  // nothing here
  if(!MLNewPacket(stdlink)) DBG();
  if(!MLPutSymbol(stdlink,"Null")) DBG();
  GBStream << "< We are done with the command NCGBShutDownMma\n"; GBStream.flush();
};

void NCGBFrontEnd() {
//  GBStream << "We are in the command NCGBFrontEnd\n"; GBStream.flush();
  symbolGB s;
  // ExecuteCommand is responsible for reading the list
  // of argmuments and sending output back for usage.
  MmaSource * mma_source_p = new MmaSource(stdlink);
  mma_source_p->d_has_new_packet = true;
  Alias<ISource> isource(mma_source_p,Adopt::s_dummy);
  Alias<ISink> isink(new MmaSink(stdlink),Adopt::s_dummy);
  Source so(isource);
  Sink si(isink);
  so >> s;
#ifdef TELL_COMMANDS
  GBStream << "Command:" << s.value().chars() << '\n';
#endif
  Source cmdsource(so.inputNamedFunction("List"));
  execute_command(s.value().chars(),cmdsource,si);
#ifdef DEBUG_COMMANDS
  GBStream << "Source count:" << so.Count() << '\n';
  GBStream << "Source eoi:" << so.eoi() << '\n';
  GBStream << "Sink count:" << si.Count() << '\n';
  if(so.Count()!=0) DBG();
  if(!so.eoi()) DBG();
  if(si.Count()!=1) DBG();
#endif
  GBStream.flush();
};

int MLMain( int argc, charpp_ct argv);

int main(int argc, char * * argv) {
  cerr << "> Starting C++ code\n";
  cerr.flush();
  AddingStart::s_execute();
  s_inInitialize = false;
  int n = MLMain(argc,argv);
  AddingEnd::s_execute();
  return n;
};
