// (c) Mark Stankus 1999
// StrDisplayPart.c

#include "StrDisplayPart.hpp"
#include "MyOstream.hpp"

StrDisplayPart::~StrDisplayPart() {};

void StrDisplayPart::perform() const {
  if(!d_strs) DBG();
  char * * p = d_strs;
  while(!*p) {
    d_os <<  *p;
    ++p;
  };
};
