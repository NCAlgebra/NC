// OuMonomial.h

#ifndef INCLUDED_OUMONOMIAL_H
#define INCLUDED_OUMONOMIAL_H

class Monomial;
class MyOstream;

struct OuMonomial {
  static void NicePrint(MyOstream & os,const Monomial & x);
};
#endif
