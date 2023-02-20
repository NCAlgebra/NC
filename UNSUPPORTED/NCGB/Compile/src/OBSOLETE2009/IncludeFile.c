// Mark Stankus (c) 1999
// IncludeFile.cpp


#include "Source.hpp"
#include "Sink.hpp"
#include "NCASource.hpp"
#include "NCASink.hpp"
#include "stringGB.hpp"
#include "Command.hpp"
#include "fstreamSource.hpp"
#include "GBInputNumbers.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

void _IncludeFile(CharacterSource & in,ofstream & out) {
  symbolGB name;
  Alias<ISource> inX(new NCASource(&in),Adopt::s_dummy);
  Alias<ISink> outX(new NCASink(out),Adopt::s_dummy);
  Source source = inX;
  Sink sink = outX;
  while(source.getType()!=GBInputNumbers::s_IOEOF) {
    Source cmdsource(source.inputCommand(name));
GBStream << "InternalCommand:" << name.value().chars() << '\n';
    execute_command(name.value().chars(),cmdsource,sink);
    source.setNotEndOfInput();
  };
GBStream << "Done with include file.\n";
};

void _IncludeFile(ifstream & ifs,ofstream & out) {
  CharacterSource * p = new fstreamSource(ifs);
  _IncludeFile(*p,out);
}

void _IncludeFile(const char * filein,const char * fileout) {
  ifstream ifs(filein);
  ofstream ofs(fileout);
  _IncludeFile(ifs,ofs);
  ifs.close();
  ofs.close();
};  

void _IncludeFile(Source & so,Sink & si) {
  stringGB in,out;
  so >> in >> out;
  so.shouldBeEnd();
  _IncludeFile(in.value().chars(),out.value().chars());
  si.noOutput();
};

AddingCommand temp1Include("IncludeFile",2,_IncludeFile);
