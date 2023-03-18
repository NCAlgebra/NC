// Mark Stankus 1999 (c)
// TheRule.cpp

#include "TheRule.hpp"

TheRule::TheRule(const Monomial & m) : 
   d_style(FULL), d_number(s_number), d_m(m), d_rest(), d_recent(true) {
  ++s_number;
};

TheRule::TheRule(const TheRule & x) :  d_style(FULL), d_number(s_number), 
        d_m(x.d_m), d_rest(x.d_rest), d_recent(x.d_recent) {
  ++s_number;
};

void TheRule::print(MyOstream & os,PrintStyle s) const {
  if(s==FULL) {
    GBStream << "Recent:" << (d_recent ? "yes" : "no") << '\n';
  };
  if(s==FULL || s==SIMPLE) {
    LIST::const_iterator w = d_rest.begin(), e = d_rest.end();
    if(w==e) {
      os << "Invalid rule " << this << " via monomial " << d_m << '\n';
      DBG();
    } else {
      while(w!=e) {
        const Polynomial & poly = *w;
        os << "RULE:(" <<  d_number << ',' << d_m << " -> -(" << poly 
           << ')' << '\n';
        ++w;
      };
    };
  } else if(s==HTML) {
    os << "<table border>\n";
    os << "<tr><td>\n";
    os << "<font color=\"purple\">Tip:" << d_m << "</font>\n";
    os << "</td><td>";
    os << (d_recent ? "recent" : "not recent");
    os << "</td></tr>\n";
    os << "<tr><td>\n";
    LIST::const_iterator w = d_rest.begin(), e = d_rest.end();
    if(w!=e) {
      os << "<table border>\n";
      while(w!=e) {
        os << "<tr><td>\n";
        os << *w << '\n';
        os << "</td></tr>\n";
        ++w;
      };
      os << "</table>\n";
    };
    os << "</table>\n";
  } else DBG();
};

int TheRule::s_number = 0;
