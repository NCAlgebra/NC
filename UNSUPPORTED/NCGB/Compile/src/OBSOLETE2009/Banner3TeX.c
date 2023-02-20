// Mark Stankus 1999 (c)
// Banner3TeX.c

#include "Banner3TeX.hpp"
#include "OrdData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

Banner3TeX::~Banner3TeX() {};

void Banner3TeX::action(const BroadCastData & x) const {
  OrdData & y = (OrdData &) x; 
  MyOstream & os = y.d_os;
  os << "\\rule[2pt]{" << d_columnwidth << "in}{4pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_rulewidth[3] << "in}{4pt}\n"
     << "\\ SOME RELATIONS WHICH APPEAR BELOW\\ \n"
     << "\\rule[2pt]{" << d_rulewidth[3] << "in}{4pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_rulewidth[4] << "in}{4pt}\n"
     << "\\ MAY BE UNDIGESTED\\ \n"
     << "\\rule[2pt]{" << d_rulewidth[4] << "in}{4pt}\\hfil\\break\n"
     << "\\rule[2pt]{" << d_columnwidth << "in}{4pt}\\hfil\\break\n"
     << "THE FOLLOWING VARIABLES HAVE NOT BEEN SOLVED FOR:\\hfil\\break\n";
};

Recipient * Banner3TeX::clone() const {
  return new Banner3TeX(GBStream,d_columnwidth,d_font);
};
