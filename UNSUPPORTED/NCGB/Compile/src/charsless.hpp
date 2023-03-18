// charsless.h

#ifndef INCLUDED_CHARSLESS_H
#define INCLUDED_CHARSLESS_H

#include "Choice.hpp"
#ifndef INCLUDED_CSTRING_H
#define INCLUDED_CSTRING_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#endif

class charsless {
public:
  bool operator()(const char * const x,const char * const y) const {
    return strcmp(x,y)<0;
  };
};

#endif
