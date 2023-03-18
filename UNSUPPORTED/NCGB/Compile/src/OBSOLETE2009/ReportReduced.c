// Mark Stankus 1999 (c)
// ReportReduced.cpp

#include "ReportReduced.hpp"
#include "PolynomialData.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "Polynomial.hpp"
#include "Tag.hpp"
#include "GBStream.hpp"

ReportReduced::~ReportReduced() {};
  
void ReportReduced::action(const BroadCastData & x) const {
  if(!x.cancast(PolynomialData::s_ID)) DBG();
  const PolynomialData  & y = (const PolynomialData  &) x;
  GBStream << "The polynomial is " << y.d_p << '\n';
  if(y.d_poly_tag_p) {
    GBStream << "*poly_tag_p is ";
    y.d_poly_tag_p->print(GBStream);
  } else {
    GBStream << "The poly_tag_p is NULL\n";
  };
#if 0
  if(y.d_rule_tag_p) {
    GBStream << "*rule_tag_p is ";
    y.d_rule_tag_p->print(GBStream);
  } else {
    GBStream << "The rule_tag_p is NULL\n";
  };
#endif
};

Recipient * ReportReduced::clone() const {
  return new ReportReduced(d_os);
};
