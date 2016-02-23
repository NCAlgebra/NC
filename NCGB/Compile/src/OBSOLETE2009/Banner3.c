// Mark Stankus 1999 (c)
// Banner3.c

#include "Banner3.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "OrdData.hpp"

Banner3::~Banner3() {};

void Banner3::action(const BroadCastData & x) const {
  const OrdData & y = (const OrdData &) x; 
  y.d_os << "\\rule[2pt]{" << d_columnwidth << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << d_rulewidth[3] << "in}{4pt}\n"
       << "\\ SOME RELATIONS WHICH APPEAR BELOW\\ \n"
       << "\\rule[2pt]{" << d_rulewidth[3] << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << d_rulewidth[4] << "in}{4pt}\n"
       << "\\ MAY BE UNDIGESTED\\ \n"
       << "\\rule[2pt]{" << d_rulewidth[4] << "in}{4pt}\\hfil\\break\n"
       << "\\rule[2pt]{" << d_columnwidth << "in}{4pt}\\hfil\\break\n"
       << "THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\\hfil\\break\n";
};

Recipient * Banner3::clone() const {
  return new Banner3(GBStream,d_columnwidth,d_font);
};
