// OuTerm.c

#include "OuTerm.hpp"
#ifndef INCLUDED_OUMONOMIAL_H
#include "OuMonomial.hpp"
#endif
#ifndef INCLUDED_TERM_H
#include "Term.hpp"
#endif
#include "MyOstream.hpp"
#include "AsciiOutputVisitor.hpp"

void OuTerm::NicePrint(MyOstream & os,const Term & x) {
  const Monomial & m = x.MonomialPart();
#if 1
   if(! x.CoefficientPart().one())
#endif
   {  
#ifdef USE_VIRT_FIELD
     AsciiOutputVisitor v(os);
     x.CoefficientPart().print(v);
#else
     x.CoefficientPart().print(os);
#endif
     os << ' ';
     if(!m.one()) OuMonomial::NicePrint(os,m);
   } else {
     OuMonomial::NicePrint(os,m);
   };
};
