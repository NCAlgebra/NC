// Mark Stankus 1999 (c)
// Banner2.c

#include "Banner2.hpp"
#include "OrdData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

Banner2::~Banner2() {};

void Banner2::action(const BroadCastData & x) const {
  OrdData & y = (OrdData &) x; 
  MyOstream & os = y.d_os;
  os << "\\rule[2pt]{" << d_columnwidth << "in}{1pt}\\hfil\\break\n"
     << "\\rule[2.5pt]{" << d_rulewidth[2] << "in}{1pt}\n"
     << "\\ USER CREATIONS APPEAR BELOW\\ \n"
     << "\\rule[2.5pt]{" << d_rulewidth[2] << "in}{1pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_columnwidth << "in}{1pt}\\hfil\\break\n";
};

Recipient * Banner2::clone() const {
  return new Banner2(GBStream,d_columnwidth,d_font);
};
