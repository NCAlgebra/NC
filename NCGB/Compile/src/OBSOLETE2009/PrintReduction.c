// Mark Stankus 1999 (c)
// PrintReduction.cpp


#include "PrintReduction.hpp"

void PrintPolys::addPolynomial(const Polynomial & x) {
  if(!x.zero()) {
    PolynomialIterator w = x.begin();
    int sz = x.numberOfTerms();
    while(sz) {
      d_S.insert((*w).MonomialPart());
      --sz;++w;
    };
  };
};

void PrintPolys::print(MyOstream & os,const Polynomial & x) const {
  if(x.zero()) {
    int sz = d_S.size();
    --sz;
    while(sz) { 
      os << "<td></td>\n";
      --sz;
    };
    os << "<td>0</td>\n";
  } else {
    PolynomialIterator wp = x.begin();
    int polysz = x.numberOfTerms();
    int tabsz = d_S.size();
    set<Monomial>::const_reverse_iterator wS = d_S.rbegin();
    while(polysz>0) {
      while((*wp).MonomialPart()!=*wS) {
        os << "<td></td>\n";
        ++wS;
      };
      if((*wp).MonomialPart()!=*wS) DBG();
      os << "<td>" << *wp << "</td>\n";
      ++wp;++wS;--polysz;--tabsz;
    };  
    while(tabsz>0) {
      os << "<td></td>\n";
      --tabsz;
    };
  };
};

void PrintPolys::printTable(MyOstream & os,list<Polynomial> & x) {
  list<Polynomial>::const_iterator w = x.begin(), e = x.end();
  while(w!=e) {
    addPolynomial(*w);
    ++w;
  };
  w = x.begin();
  os << "<table><tr>\n";
  while(w!=e) {
    print(os,*w);
    ++w;
    if(w!=e) os << "</tr><tr>";
  };
  os << "</tr></table>\n";
};
