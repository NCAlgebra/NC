// firstDiffer.c

#include "firstDiffer.hpp"

#if 0
int  firstDiffer(const GBVector<int> & aList, const GBVector<int> & bList) {
  int result = -1; // -1 indicates equality
  bool shouldLoop = true;
  int theMin;
  const int sz1 = aList.size();
  const int sz2 = bList.size();
  theMin = (sz1 < sz2) ? sz1 : sz2;
  GBVector<int>::const_iterator w = aList.begin();
  GBVector<int>::const_iterator ww = bList.begin();
  for(int i = 1; i <= theMin && shouldLoop; ++i,++w,++ww) {
    if((*w) != (*ww)) {
      result = i;
      shouldLoop = false;
    }
  }
  return result;
};
#endif

bool IsMember(const GBVector<int> & x,int n) {
  bool result = false;
  const int sz = x.size();
  GBVector<int>::const_iterator w = x.begin();
  for(int i=1;i<=sz&&!result;++i,++w) {
    result = (*w)==n;
  }
  return result;
};

