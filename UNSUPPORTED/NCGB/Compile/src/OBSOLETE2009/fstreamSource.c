// (c) Mark Stankus 1999
// fstreamSource.c

#include "fstreamSource.hpp"


fstreamSource::~fstreamSource(){};

bool fstreamSource::eof() const {
  return d_ifs.eof();
};

void fstreamSource::vGet(char & c) {
  if(d_skipws) {
    d_ifs >> c;
  } else {
    d_ifs.get(c);
  };
};
