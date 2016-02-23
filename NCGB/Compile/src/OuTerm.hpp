// OuTerm.h

#ifndef INCLUDED_OUTERM_H
#define INCLUDED_OUTERM_H

class Term;
class MyOstream;

struct OuTerm {
  static void NicePrint(MyOstream & os,const Term & x);
};
#endif 
