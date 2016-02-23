// OfstreamProxy.c

#include "OfstreamProxy.hpp"
#include "RecordHere.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

OfstreamProxy::OfstreamProxy(const char * const s) : 
   d_s(s), d_p((ofstream *)0),d_done(false){};

OfstreamProxy::~OfstreamProxy(){ 
  if(d_done) {
    d_p->close();
  };
};

ofstream & OfstreamProxy::operator()() { 
  if(!d_done) {
    RECORDHERE(d_p = new ofstream();)
    const char * x = d_s.chars();
    d_p->open(x);
    d_done = true;
  }
  return * d_p;
};
