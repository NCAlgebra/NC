// OfstreamProxy.h

#ifndef INCLUDED_OFSTREAMPROXY_H
#define INCLUDED_OFSTREAMPROXY_H

#include "simpleString.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

using namespace std;

class OfstreamProxy {
  OfstreamProxy();
    // not implemented
  OfstreamProxy(const OfstreamProxy &);
    // not implemented
  void operator =(const OfstreamProxy &);
    // not implemented
private:
  simpleString d_s;
  ofstream * d_p;
  bool d_done;
public:
  OfstreamProxy(const char * const s);
  ~OfstreamProxy();
  ofstream & operator()(); 
};
#endif
