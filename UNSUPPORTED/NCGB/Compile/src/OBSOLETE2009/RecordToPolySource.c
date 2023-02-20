// Mark Stankus 1999 (c)
// RecordToPolySource.c

#include "RecordToPolySource.hpp"
#include "FactControl.hpp"
#include "PolynomialData.hpp"
#include "PolySource.hpp"

RecordToPolySource::~RecordToPolySource() {};

void RecordToPolySource::action(const BroadCastData & x) const {
  if(!x.cancast(PolynomialData::s_ID)) DBG();
  const PolynomialData  & y = (const PolynomialData  &) x;
  d_ps.insert(y);
};

Recipient * RecordToPolySource::clone() const {
  return new RecordToPolySource(d_ps);
};
