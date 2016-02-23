// (c) Mark Stankus 1999
// CreateSourceSink.c

#include "CreateSourceSink.hpp"
#include "NCASource.hpp"
#include "NCASink.hpp"
#include "WFileSource.hpp"
#include "WFileSink.hpp"
#include "Ownership.hpp"
#include "Source.hpp"
#include "fstreamSource.hpp"
#include "Sink.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

using namespace std;

//char * s_Choice = "WFile";
char * s_Choice = "NCA";

void CreateSourceSink(Source & source,Sink & sink) {
  char * input_file = 0;
  char * output_file = 0;
  if(s_Choice=="" || strcmp(s_Choice,"WFile")==0) {
    input_file = "h:\\windows\\desktop\\file_input";
    output_file = "c:\\windows\\desktop\\file_output";
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
  } else if(strcmp(s_Choice,"NCA")==0) {
    input_file = "c:\\windows\\desktop\\nca_input";
    output_file = "c:\\windows\\desktop\\nca_output";
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
  } else DBG();
};
