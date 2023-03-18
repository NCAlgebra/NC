// (c) Mark Stankus 1999
// CompareOnDouble.cpp

#include "CompareOnDouble.hpp"
#include "ComparisonExtended.hpp"
#include "AdmissibleOrder.hpp"
#include "MLex.hpp"
#include "Monomial.hpp"
#include "RecordHere.hpp"
#include "nDataMonomial.hpp"
#include "UserOptions.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

#include "vcpp.hpp"


ComparisonExtended CompareOnDouble(const Monomial & first, const Monomial & second) {
  ComparisonExtended result = ComparisonExtended::s_INCOMPARABLE;
#if 0
  nDataMonomial * ptra = (nDataMonomial *) first.auxilaryData();
  nDataMonomial * ptrb = (nDataMonomial *) second.auxilaryData();
#else
  nDataMonomial * ptra = 0;
  nDataMonomial * ptrb = 0;
#endif
  if(!ptra) {
    //MXS
    RECORDHERE(ptra = new nDataMonomial((MLex *)AdmissibleOrder::s_getCurrentP(),(const Monomial &)first);)
    //first.auxilaryData(ptra);
  } else {
    ptra->updateMonomial(first);
  };
if(UserOptions::s_TellMultiGradedLex) {
   ptra->tellMonomial(first);
};         
  if(!ptrb) {
    RECORDHERE(ptrb = new nDataMonomial((MLex *)AdmissibleOrder::s_getCurrentP(),(const Monomial &)second);)
    //MXS
    //second.auxilaryData(ptrb);
  } else {
    ptrb->updateMonomial(second);
  };
  if(UserOptions::s_TellMultiGradedLex) {
    ptrb->tellMonomial(second);
  };         
  vector<int> tuplea(ptra->counts());
  vector<int> tupleb(ptrb->counts());
  int smallValue = 0;
  int differ = -1;
  int theMin;
  const int sz1 = tuplea.size();
  const int sz2 = tupleb.size();
  theMin = (sz1 < sz2) ? sz1 : sz2;
  int j = smallValue;
  for(int i=1;i<=theMin && differ == -1; ++i) {
    if (tuplea[j]==tupleb[j]) {
      ++j;
    } else {
      differ = i;
      if(tuplea[j] < tupleb[j]) {
        result = ComparisonExtended::s_LESS;
      } else {
        result = ComparisonExtended::s_GREATER;
      }
    }
  };
  if(differ==-1) {
    bool done = false;
    if(sz1>sz2) {
      int smallNumber = 1;
      int kk = (sz2-1)+smallNumber;
      for(int j=sz2+1;j<=sz1&&!done;++j,++kk) {
        if(tuplea[kk]!=0) {
          done = true;
          result = ComparisonExtended::s_GREATER;
        };
      };
    } else if(sz1<sz2) {
      int smallNumber = 1;
      int kk = (sz1-1)+smallNumber;
      for(int j=sz1+1;j<=sz2&&!done;++j,++kk) {
        if(tupleb[kk]!=0) {
          done = true;
          result = ComparisonExtended::s_LESS;
        };
      };
    };
  };
  if(result==ComparisonExtended::s_INCOMPARABLE) {
    result= ComparisonExtended::s_EQUIVALENT;
  };
  // MXS
  delete ptra;
  delete ptrb;
  return result;
};
