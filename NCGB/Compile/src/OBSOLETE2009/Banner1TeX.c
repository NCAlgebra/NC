// (c) Mark Stankus 1999
// Banner1TeX.c

#include "Banner1TeX.hpp"
#include "OrdData.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

Banner1TeX::~Banner1TeX() {};

void Banner1TeX::action(const BroadCastData & x) const {
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

Recipient * Banner1TeX::clone() const {
  return new Banner1TeX(GBStream,d_columnwidth,d_font);
};
