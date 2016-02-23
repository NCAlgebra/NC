// Mark Stankus 1999 (c)
// RecordHistory.cpp

#include "RecordHistory.hpp"
#include "PolynomialData.hpp"
#include "Polynomial.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "GBStream.hpp"

RecordHistory::~RecordHistory() {};
  
void RecordHistory::action(const BroadCastData & x) const {
  if(!x.cancast(PolynomialData::s_ID)) errorc(__LINE__);
  const PolynomialData  & y = (const PolynomialData  &) x;
  GBStream << "The polynomial is " << y.d_p << '\n';
  GBStream << "History recording not fully implemented.\n";
};

Recipient * RecordHistory::clone() const {
  return new RecordHistory(d_L);
};

void RecordHistory::errorh(int n) { DBGH(n); };

void RecordHistory::errorc(int n) { DBGC(n); };
