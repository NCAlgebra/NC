// marker.c

#include "marker.hpp"
#include "Debug1.hpp"
#include "GBIO.hpp"
#include "symbolGB.hpp"
#include "stringGB.hpp"
#include "simpleString.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#define RECORDMARKERS
#ifdef  RECORDMARKERS

#include "GBGlobals.hpp"
#include "MemoryOptions.hpp"

#endif
#include "MyOstream.hpp"
#pragma warning(disable:4687)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <functional>
#else
#include <function.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "vcpp.hpp"

marker::marker() : d_number(-999), d_name("unknown") {}; 

void marker::operator =(const marker & x) {
  d_number = x.d_number;
  d_name = x.d_name;
};

marker::~marker() {
#ifdef  RECORDMARKERS
  if(d_number>=0) {
    if(MemoryOptions::s_recordNamesOfGBMarkers) {
      GBGlobals::s_dismissMarker(d_number,d_name.chars());
    };
  };
#endif
};

marker::marker(const marker & mark) : d_number(mark.d_number), 
    d_name(mark.d_name) {
#ifdef  RECORDMARKERS
  // Record the duplicate. I expect that the user will change the name 
  // at some point via the non-constant name function below.
  if(MemoryOptions::s_recordNamesOfGBMarkers) {
    GBGlobals::s_recordMarker(d_number,d_name.chars());
  };
#endif
};

extern map<simpleString,marker,less<simpleString> > s_StringToMarker;

void marker::getNamed(const char * const s,Source & so) {
  get(so);
  if(!nameis(s)) DBG();
};

void marker::get(Source & so) {
  Source source(so.inputNamedFunction("GBMarker"));
  stringGB y;
  source >> d_number >> y;
  d_name = y.value().chars();
#ifdef  RECORDMARKERS
  if(MemoryOptions::s_recordNamesOfGBMarkers) {
    GBGlobals::s_recordMarker(d_number,d_name.chars());
  };
#endif
};

void marker::put(Sink & si) const {
  Sink sink(si.outputFunction("GBMarker",2L));
  sink << d_number;
  stringGB x(d_name);
  sink << x;
};

bool marker::nameis(const char * const s) const {
  return d_name==s;
};

void marker::name(const char * const s) {
#ifdef  RECORDMARKERS
  if(MemoryOptions::s_recordNamesOfGBMarkers) {
    GBGlobals::s_dismissMarker(d_number,d_name.chars());
  };
#endif
  d_name = s;
#ifdef  RECORDMARKERS
  if(MemoryOptions::s_recordNamesOfGBMarkers) {
    GBGlobals::s_recordMarker(d_number,d_name.chars());
  };
#endif
};

marker marker::s_last_marker;
