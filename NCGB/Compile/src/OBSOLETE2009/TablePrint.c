// Mark Stankus 1999 (c)
// TablePrint.cpp


#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "stringGB.hpp"
#include "Polynomial.hpp"
#include "MyOstream.hpp"
#include "HTML.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

void RepeatEntryBox(int r1,int c1,int r2,int c2,HTMLTable & x,const char * s) {
  for(int r=r1;r<=r2;++r) {
    for(int c=c1;c<=c2;++c) {
       x.add(new HTMLVerbatim(s),r,c);
    };
  };
}; 

const char * AsString(const Field &) {
  return "field";
};
const char * AsString(const Monomial &) {
  return "monomial";
};

void TermPrint(const Term & term,HTMLTable & x,int r,int c) {
  HTMLTable * temp = new HTMLTable(false);
  const Field & f = term.CoefficientPart();
  const Monomial & m = term.MonomialPart();
  HTML * coeff = new HTMLVerbatim(AsString(f));
  HTML * mono = new HTMLVerbatim(AsString(m));
  temp->add(coeff,1,1);
  temp->add(mono,1,2);
  x.add(temp,r,c);
};
  

void TablePrint(const Polynomial & x,MyOstream & os,
        bool showzeros,bool gapsforzeros) {
  if(x.zero()) {
    os << "<td></td><td>0</td>";
  } else {
    const Monomial & m = x.tipMonomial();
    int deg = x.numberOfTerms();
    if(deg==0) {
      os << "<td>" << x.tipCoefficient() << "</td>\n";
    } else {
      Variable var(*m.begin());
      Field zero(0);
      PolynomialIterator w = x.begin();
      int sz = x.numberOfTerms(); 
      while(sz) {
        const Term & t = *w;
        int lowerdeg = t.MonomialPart().numberOfFactors();
        if(gapsforzeros) {
          while(deg>lowerdeg) {
            os << "<td>";
            if(showzeros) {
              os << "<td>0</td><td>" << var << "^" << deg;
              os << "</td>\n";
            };
            --deg;
          };
        };
        if(t.CoefficientPart().sgn()==1) {
          os << "<td>+</td><td>" << t << "</td>\n";
        } else {
          os << "<td>-</td><td>" << -t << "</td>\n";
        };
        ++w;--sz; 
      };
    };
  };
};

void _TablePrint(Source & so,Sink & si) {
  const char * bordertype = "border";
  stringGB filename;
  Polynomial p,q;  ;
  bool showzeros, gapsforzeros;
  so >> p >> q >> showzeros >> gapsforzeros >> filename;
  so.shouldBeEnd();
  si.noOutput();
  ofstream ofs(filename.value().chars());
  MyOstream os(ofs);
  os << "<table " << bordertype << ">\n";
  os << "<tr>";
  os << "<table " << bordertype << "><hr></table>\n";
#if 0
  int n = p.numberOfTerms();
  if(n==0) {
    n = 2;
  } else if (showzeros || gapsforzeros) {
    n = 2*(p.tipMonomial().numberOfFactors()+1);
  } else {
    n *= 2;
  };
  Dashes(n,os);
  RepeatColumns(n,os,"<hr>") {
#endif
  os << "</tr>\n";
  os << "<tr>";
  TablePrint(p,os,showzeros,gapsforzeros);
  os << "<td>!</td>\n";
  TablePrint(p,os,showzeros,gapsforzeros);
  os << "</tr>\n";
  os << "</table>\n";
  ofs.close();
};

AddingCommand temp1TablePrint("TablePrint",5,_TablePrint);
