// GBAlg.c

#include "GBAlg.hpp"
#include "MyOstream.hpp"
#include "Reduce.hpp"
#include "PolySource.hpp"
#include "RuleSet.hpp"

GBAlg::~GBAlg(){};

void GBAlg::print(MyOstream & os) {
  os << "reduce:\n";
  d_reduce.print(os);
  os << "\npolynomial source:\n";
  d_poly_source.print(os);
  os << "\nrules:\n";
  d_rules.print(os);
  os << '\n';
};
