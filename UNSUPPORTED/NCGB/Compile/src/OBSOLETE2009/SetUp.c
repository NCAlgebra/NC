// (c) Mark Stankus 1999
// SetUp.cpp

#include "SetUp.hpp"
#include "Ownership.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "fstreamSource.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#include "simpleString.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#include <cstring>
#else
#include <fstream.h>
#include <string.h>
#endif
using namespace std;

#include "StringAccumulator.hpp"


#ifdef USE_NCA
#include "NCASource.hpp"
#include "NCASink.hpp"
void CreateTheSourceSink(Source & source,Sink & sink,const char * s) {
  simpleString t1(s);
  StringAccumulator t2;
  t2.add(t1.chars());
  t2.add(".end");
#if 1
  const char * input_file = t1.chars();
  const char * output_file = t2.chars();
#else
#ifdef USE_VCPP
  const char * input_file = "c:\\windows\\desktop\\C++\\nca_input";
  const char * output_file = "c:\\windows\\desktop\\C++\\nca_output";
#endif
#ifdef USE_UNIX
  const char * input_file = "nca_input";
  const char * output_file = "nca_output";
#endif
#endif
  ifstream * p = new ifstream(input_file);
  if(!*p) {
    GBStream << "Cannot open the file " << input_file << '\n';
    DBG();
  };
  ofstream * q = new ofstream(output_file);
  if(!*q) {
    GBStream << "Cannot open the file " << output_file << '\n';
    DBG();
  };
  fstreamSource * p2 = new fstreamSource(*p);
  Alias<ISource> in(new NCASource(p2),Adopt::s_dummy);
  Alias<ISink> out(new NCASink(*q),Adopt::s_dummy);
  source = in;
  sink = out;
};
#endif

#ifdef USE_WFILE
#include "WFileSource.hpp"
#include "WFileSink.hpp"
void CreateTheSourceSink(Source & source,Sink & sink,const char * s) {
  if(s) DBG();
  char * input_file = "h:\\windows\\desktop\\file_input";
  char * output_file = "c:\\windows\\desktop\\file_output";
  ifstream * p = new ifstream(input_file);
  if(!*p) {
    GBStream << "Cannot open the file " << input_file << '\n';
    DBG();
  };
  ofstream * q = new ofstream(output_file);
  if(!*q) {
    GBStream << "Cannot open the file " << output_file << '\n';
    DBG();
  };
  fstreamSource * p2 = new fstreamSource(*p);
  Alias<ISource> in(new WFileSource(*p2),Adopt::s_dummy);
  Alias<ISink> out(new WFileSink(*q),Adopt::s_dummy);
  source = in;
  sink = out;
};
#endif

#ifdef USE_MMA
extern "C" {
#include "mathlink.h"
extern MLINK stdlink;
}
#include "MmaSource.hpp"
#include "MmaSink.hpp"
void CreateTheSourceSink(Source & source,Sink & sink,const char * s) {
  if(s) DBG();
  Alias<ISource> in(new MmaSource(stdlink),Adopt::s_dummy);
  Alias<ISink> out(new MmaSink(stdlink),Adopt::s_dummy);
  source = in;
  sink = out;
};
#endif

class Source;
class Sink;

typedef void (*SOURCESINK)(Source &,Sink &,const char *); 

SOURCESINK SetUp::s_CreateSourceSink = CreateTheSourceSink;
