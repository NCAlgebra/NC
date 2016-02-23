// MatcherMonomial.h

#ifndef INCLUDED_MONOMIALMATCHER_H
#define INCLUDED_MONOMIALMATCHER_H

#include "load_flags.hpp"
#include "RecordHere.hpp"
#include "GBList.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
class subMonomial;
#ifndef INCLUDED_GBMATCH_H
#include "GBMatch.hpp"
#endif
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif
#include "vcpp.hpp"
#ifndef EnumMono
#define EnumMono
typedef enum { SUB_MATCH=1,SUBSET_MATCH,OVERLAP_MATCH} MATCHING_TYPES;
#endif

class MatcherMonomial {
  static void errorh(int);
  static void errorc(int);
  MatcherMonomial(const MatcherMonomial &);
    // not implemented
  void operator=(const MatcherMonomial &);
    // not implemented
public:
   typedef Monomial MONOMIAL;

   MatcherMonomial();
   ~MatcherMonomial();

   // the matching code
   void subMatch( const MONOMIAL & mona,int a,
      const MONOMIAL & monb,int b, GBList<Match> & result);
   void overlapMatch(const MONOMIAL & mona,int a,
      const MONOMIAL & monb,int b, GBList<Match> & result);
   void subMatch( const MONOMIAL & mona,int a,
      const MONOMIAL & monb,int b, list<Match> & result);
   void overlapMatch(const MONOMIAL & mona,int a,
      const MONOMIAL & monb,int b, list<Match> & result);
   void overlapMatch(const MONOMIAL & mona, const MONOMIAL & monb,
      list<int> & result);
 
   // fast matching for use by reduction 
   bool matchExistsNoRecord(const MONOMIAL & mona,
                            const MONOMIAL & monb);
   bool matchExists(const MONOMIAL & mona,
                    const MONOMIAL & monb);
   const Match & matchIs();

private:
   void setInternalMatch();
   void constructMatch(
          const MONOMIAL & mona,int a,
          const MONOMIAL & monb,int b,
          const subMonomial & aINode,
          const subMonomial & bINode,
          MATCHING_TYPES type,
          Match & result) const;
   Match * _theMatch;
   mutable int k;
};

inline MatcherMonomial::MatcherMonomial() : _theMatch(0) {};

inline MatcherMonomial::~MatcherMonomial() {
  RECORDHERE(delete _theMatch;)
};

inline void MatcherMonomial::setInternalMatch() {
  delete _theMatch;
  _theMatch = new Match;
};

inline const Match & MatcherMonomial::matchIs() {
  if(_theMatch==0) errorh(__LINE__);
  return * _theMatch;
};
#endif
#endif
