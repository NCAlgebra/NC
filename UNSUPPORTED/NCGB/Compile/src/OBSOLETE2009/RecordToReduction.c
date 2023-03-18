// Mark Stankus 1999 (c)
// RecordToReduction.c

#include "RecordToReduction.hpp"
#include "Reduction.hpp"
#include "PolynomialData.hpp"
#include "SPIID.hpp"

#include "Polynomial.hpp"
#include "MyOstream.hpp"

RecordToReduction::~RecordToReduction() {};

void RecordToReduction::action(const BroadCastData & x) const {
  if(!x.cancast(PolynomialData::s_ID)) DBG();
  const PolynomialData  & y = (const PolynomialData  &) x;
  SPIID id(y.d_number);
  d_red.addFact(id);
};

Recipient * RecordToReduction::clone() const {
  return new RecordToReduction(d_red);
};
