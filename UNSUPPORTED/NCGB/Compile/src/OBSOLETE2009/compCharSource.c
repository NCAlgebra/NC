// (c) Mark Stankus 1999
// compCharSource.c

#include "compCharSource.hpp"


compCharSource::~compCharSource(){};

bool compCharSource::eof() const {
  if(!d_valid) {
    DBG();
  };
  return d_valid;
};

void compCharSource::vGet(char &) {
  DBG();
};
