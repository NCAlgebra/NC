// (c) Mark Stankus 1999
// RuleDisplayPart.c

#include "RuleDisplayPart.hpp"
#include "Sink.hpp"

RuleDisplayPart::~RuleDisplayPart() {};

void RuleDisplayPart::perform() const {
  typedef list<GroebnerRule>::const_iterator LI;
  LI w = d_list.begin(), e = d_list.end();
  while(w!=e) {
    d_sink << *w;
    ++w;
  };
};
