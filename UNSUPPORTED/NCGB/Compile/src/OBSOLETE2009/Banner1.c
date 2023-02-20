// Mark Stankus 1999 (c)
// Banner1.c

#include "Banner1.hpp"
#include "OrdData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"


Banner1::~Banner1() {};

void Banner1::action(const BroadCastData & x) const {
  OrdData & y = (OrdData &) x; 
  MyOstream & os = y.d_os;
  os << "\\rule[2pt]{" << d_columnwidth << "in}{4pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_rulewidth[0] << "in}{4pt}\n"
     << "\\ YOUR SESSION HAS DIGESTED\\ \n"
     << "\\rule[2pt]{" << d_rulewidth[0] << "in}{4pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_rulewidth[1] << "in}{4pt}\n"
     << "\\ THE FOLLOWING RELATIONS\\ \n"
     << "\\rule[2pt]{" << d_rulewidth[1] << "in}{4pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_columnwidth << "in}{4pt}\\hfil\\break\n";
};

Recipient * Banner1::clone() const {
  return new Banner1(GBStream,d_columnwidth,d_font);
};
