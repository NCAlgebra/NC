// (c) Mark Stankus 1999
// Reduce.c

#include "Reduce.hpp"
#include "FullReduceFor.hpp"
#include "Debug1.hpp"

Reduce::~Reduce(){};

Reduce * Reduce::make_full() {
  if(d_tip) DBG();
  return new FullReduceFor(*this);
};
