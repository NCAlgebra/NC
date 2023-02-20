// (c) Mark Stankus 1999
// CompareOnDouble.cpp

#include "CompareOnDouble.hpp"
#include "ComparisonExtended.hpp"
#include "NewMonomial.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

ComparisonExtended CompareOnDouble(const Monomial & first, const Monomial & second) {
  ComparisonExtended result = ComparisonExtended::s_EQUIVALENT;
  const vector<int> & a = first.FORORDER();
  const vector<int> & b = second.FORORDER();
  if(a.size()!=b.size()) DBG();
  typedef vector<int>::const_iterator VI;
  VI w1 = a.begin(), e1 = a.end();
  VI w2 = b.begin();
  int n1,n2;
  while(w1!=e1) {
    n1 = *w1;
    n2 = *w2;
    if(n1!=n2) {
      if(n1<n2) {
        result = ComparisonExtended::s_LESS;
      } else {
        result = ComparisonExtended::s_GREATER;
      };
      break;
    };
    ++w1;++w2;
  };
  return result;
};
