// (c) Mark Stankus 1999
// TestCode.c

#ifndef INCLUDED_GBINPUT_H
#include "GBInput.hpp"
#endif
#ifndef INCLUDED_GBOUTPUT_H
#include "GBOutput.hpp"
#endif
#include "FCGiveNumber.hpp"
#include "Choice.hpp"
#pragma warning(disable:4786)
#include "Command.hpp"
#include "Polynomial.hpp"
#include "PrintList.hpp"
#include "Source.hpp"
#include "Sink.hpp"

extern int s_number_of_spolynomials;

#include "vcpp.hpp"


void _PrintAddPolynomials(Source & so,Sink & si) {
  Polynomial p,q,r;
  so >> p >> q;
  so.shouldBeEnd();
  GBStream << "***First assignment***\n";
  r = p;
  GBStream << "***First +=***\n";
  r += q;
  GBStream << "***Print***\n";
  GBStream << "The sum of " << p << " and " << q << " is " << r << '\n'; 
  si.noOutput();
};

AddingCommand temp1Code("PrintAddPolynomials",2,_PrintAddPolynomials);

void _PrintTimesMonomial(Source & so,Sink & si) {
  Monomial p,q,r;
  so >> p >> q;
  so.shouldBeEnd();
  r = p;
  r *= q;
  GBStream << "The product of " << p << " and " << q << " is " << r << '\n'; 
  si.noOutput();
};

AddingCommand temp2Code("PrintTimesMonomial",2,_PrintTimesMonomial);

#include "FactControl.hpp"
#include "PDReduction.hpp"

void _PrintReduceBy(Source & so,Sink & si) {
  Polynomial p,q;
  GroebnerRule r;
  list<Polynomial> L;
  GBInput(L,so);
  so >> p;
  so.shouldBeEnd();
  FactControl fc;
  FCGiveNumber give(fc);
  PDReduction red(give);
  typedef list<Polynomial>::const_iterator LI;
  int n;
  LI w = L.begin(), e = L.end();
  while(w!=e) {
    const Polynomial & pp = *w;
    r.convertAssign(pp);
    GBStream << "polynomial:" << pp << '\n';
    GBStream << "rule:" << r << '\n';
    n = fc.addFact(r);
    SPIID id(n);
    red.addFact(id);
    ++w;
  };
  red.reduce(p,q);
  PrintList("Using list for reduction:",L);
  GBStream << "The reduction of " << p << " is " << q << ".\n"; 
  si.noOutput();
};

AddingCommand temp3Code("PrintReduceBy",2,_PrintReduceBy);

#include "MatcherMonomial.hpp"
#include "GBMatch.hpp"

void _PrintSubMatches(Source & so,Sink & si) {
  Monomial m,n;
  so >> m >> n;
  si.noOutput();
  MatcherMonomial matcher;
  list<Match> L;
  FactControl fc;
  Polynomial zip;
  GroebnerRule mru(m,zip);
  GroebnerRule nru(n,zip);
  int mnum = fc.addFact(mru);
  int nnum = fc.addFact(nru);
  matcher.subMatch(m,mnum,n,nnum,L);
  typedef list<Match>::const_iterator LI;
  LI w = L.begin(), e = L.end();
  GBStream << "There are " << L.size() << " sub matches of " 
           << m << " and " << n << ".\n";
  while(w!=e) {
    GBStream << *w << '\n';
    ++w;
  };
};

AddingCommand temp4Code("PrintSubMatches",2,_PrintSubMatches);

void _PrintOverlapMatches(Source & so,Sink & si) {
  Monomial m,n;
  so >> m >> n;
  si.noOutput();
  MatcherMonomial matcher;
  list<Match> L;
  FactControl fc;
  Polynomial zip;
  GroebnerRule mru(m,zip);
  GroebnerRule nru(n,zip);
  int mnum = fc.addFact(mru);
  int nnum = fc.addFact(nru);
  matcher.overlapMatch(m,mnum,n,nnum,L);
  typedef list<Match>::const_iterator LI;
  LI w = L.begin(), e = L.end();
  GBStream << "There are " << L.size() << " overlap matches of "
           << m << " and " << n << ".\n";
  while(w!=e) {
    GBStream << *w << '\n';
    ++w;
  };
};

AddingCommand temp5Code("PrintOverlapMatches",2,_PrintOverlapMatches);

void _PrintSpolynomialsSubMatches(Source & so,Sink & si) {
  Polynomial m,n;
  GroebnerRule mru,nru;
  so >> m >> n;
  si.noOutput();
  MatcherMonomial matcher;
  list<Match> L;
  FactControl fc;
  mru.convertAssign(m);
  nru.convertAssign(n);
  GBStream << "First rule:" << mru << '\n';
  GBStream << "Second rule:" << nru << '\n';
  int mnum = fc.addFact(mru);
  int nnum = fc.addFact(nru);
  matcher.subMatch(mru.LHS(),mnum,nru.LHS(),nnum,L);
  typedef list<Match>::const_iterator LI;
  LI w = L.begin(), e = L.end();
  GBStream << "There are " << L.size() << " sub matches of " 
           << m << " and " << n << ".\n";
  while(w!=e) {
    const Match & aMatch = *w;
    Polynomial firstpart;
    firstpart.doubleProduct(aMatch.const_left1(),
                           mru.RHS(),
                           aMatch.const_right1());
    Polynomial secondpart;
    secondpart.doubleProduct(aMatch.const_left2(),
                            nru.RHS(),
                            aMatch.const_right2());
    Polynomial spol(firstpart);
    spol -= secondpart;
    GBStream << aMatch << '\n';
    GBStream << spol << '\n';
    ++w;
  };
};

AddingCommand temp6Code("PrintSpolynomialsSubMatches",2,
         _PrintSpolynomialsSubMatches);

void _PrintSpolynomialsOverlapMatches(Source & so,Sink & si) {
  Polynomial m,n;
  GroebnerRule mru,nru;
  so >> m >> n;
  si.noOutput();
  MatcherMonomial matcher;
  list<Match> L;
  FactControl fc;
  mru.convertAssign(m);
  nru.convertAssign(n);
  GBStream << "First rule:" << mru << '\n';
  GBStream << "Second rule:" << nru << '\n';
  int mnum = fc.addFact(mru);
  int nnum = fc.addFact(nru);
  matcher.overlapMatch(mru.LHS(),mnum,nru.LHS(),nnum,L);
  typedef list<Match>::const_iterator LI;
  LI w = L.begin(), e = L.end();
  GBStream << "There are " << L.size() << " overlap matches of " 
           << m << " and " << n << ".\n";
  while(w!=e) {
    const Match & aMatch = *w;
    Polynomial firstpart;
    firstpart.doubleProduct(aMatch.const_left1(),
                           mru.RHS(),
                           aMatch.const_right1());
    Polynomial secondpart;
    secondpart.doubleProduct(aMatch.const_left2(),
                            nru.RHS(),
                            aMatch.const_right2());
    Polynomial spol(firstpart);
    spol -= secondpart;
    GBStream << aMatch << '\n';
    GBStream << spol << '\n';
    ++w;
  };
};

AddingCommand temp7Code("PrintSpolynomialsOverlapMatches",2,
         _PrintSpolynomialsOverlapMatches);
