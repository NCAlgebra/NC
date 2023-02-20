// ncgbofstream.h

#ifndef INCLUDED_NCGBOFSTREAM_H
#define INCLUDED_NCGBOFSTREAM_H

#include "simpleString.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

class ncgbofstream : public ofstream {
public:
  ncgbofstream(const char *);
  virtual ~ncgbofstream();
  static list<simpleString> s_L;
};
#endif
