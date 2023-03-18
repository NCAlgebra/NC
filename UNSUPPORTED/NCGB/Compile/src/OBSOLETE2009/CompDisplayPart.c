// (c) Mark Stankus 1999
// CompDisplayPart.c

#include "CompDisplayPart.hpp"

CompDisplayPart::~CompDisplayPart() {};

void CompDisplayPart::perform() const {
  typedef list<ICopy<DisplayPart> >::const_iterator LI;
  LI w = d_list.begin(), e = d_list.end();
  while(w!=e) {
    (*w)().perform();
    ++w;
  };
};
