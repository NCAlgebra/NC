// UnifierBin.c

#include "UnifierBin.hpp"
#include "GBStream.hpp"
#include "load_flags.hpp"

#ifdef PDLOAD
#include "PrintGBList.hpp"
#include "PrintGBVector.hpp"
#ifndef INCLUDED_FACTCONTROL_H
#include "FactControl.hpp"
#endif
#include "MyOstream.hpp"
#include "PrintGBList.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

using namespace std;

// Used to set up numbers to be retrieved the next iteration
// of the GB algorithm
void UnifierBin::fillForNextIteration() { 
  const int newNSize = _newNumbers.size();
  GBList<int>::const_iterator k = 
     ((const GBList<int> &)_newNumbers).begin();
  int i=1;
  for(;i<=newNSize;++i,++k) {
    _allNumbersThisIteration.insertIfNotMember(* k);
  };
  int allSize = _allNumbersThisIteration.size();
  GBList<int> orderedNumbers;
  GBVector<int> nums;
  if(_reorder) {
    nums = _fc.PermNumbers();
    const int sz = nums.size();
    for(i=1;i<=sz;++i) {
      if(_allNumbersThisIteration.Member(nums[i]).first()) {
        orderedNumbers.push_back(nums[i]);
      }
    }
  }  else {
    orderedNumbers = _allNumbersThisIteration;
  };
  if(orderedNumbers.size()!=_allNumbersThisIteration.size()) {
    GBStream << "Expected the following two lists to have the same size:\n";
    PrintGBList("orderedNumbers",orderedNumbers);
    PrintGBList("allNumbersThisIteration",_allNumbersThisIteration);
    GBStream << "and num is:";
    PrintGBVector("nums:",nums);
    DBG();
  };
  int numi;
  int numj;
  GBList<int>::const_iterator m = 
     ((const GBList<int> &)orderedNumbers).begin();
  for(int j=1;j<=allSize;++j,++m) {
    numj = * m;
    GBList<int>::const_iterator n = ((const GBList<int> &)orderedNumbers).begin();
    for(i=1;i<=allSize;++i,++n) {
      numi = * n;
      bool flag = numi>_done.size();
      if(!flag) {
        GBList<GBList<int> >::const_iterator ww = 
          ((const GBList<GBList<int> > &)_done).begin();
        ww.advance(numi-1);
        flag = ! (* ww).Member(numj).first();
      }
      if(flag) {
        _pairsForThisIteration.push_back(make_pair(numi,numj));
      }
    };
  };
  _newNumbers.clear();
};

// Retrieve and remove the next pair from the list
pair<int,int> UnifierBin::nextPair()
#ifdef USEGnuGCode
   return result; {
#else
{
  pair<int,int> result;
#endif
  if(_pairsForThisIteration.size()==0) {
    GBStream << "Pair requested from an empty UnifierBin.\n";
    DBG();
  }
  list<pair<int,int> >::const_iterator j = _pairsForThisIteration.begin();
  result.first = (*j).first;
  result.second = (* j).second;
  _pairsForThisIteration.pop_front();
  markDone(result.first,result.second);
#ifndef USEGnuGCode
  return result;
#endif
};

// Mark that the spolynomials between _fc.fact(i) and
// _fc.fact(j) have been taken. The order is important.
void UnifierBin::markDone(int i,int j) { 
  if(_done.size()<i) {
    int diff = i - _done.size();
    GBList<int> aList;
    for(int k=1;k<=diff;++k) {
      _done.push_back(aList);
    }
  }
  GBList<GBList<int> >::iterator ww = _done.begin();
  ww.advance(i-1);
  // *ww is _done[ww]
  (*ww).push_back(j);
};

void UnifierBin::removeAllNumber(int number) { 
  int i;
  int num;
  GBList<int> temp(_newNumbers);
  _newNumbers.clear();
  const int sz = temp.size();
  GBList<int>::const_iterator w = ((const GBList<int> &)temp).begin();
  for(i=1;i<=sz;++i,++w) {
    num = *w;
    if(num!=number) _newNumbers.push_back(num);
  }

  temp = _allNumbersThisIteration;
  _allNumbersThisIteration.clear();
  const int sz2 = temp.size();
  GBList<int>::const_iterator ww = ((const GBList<int> &)temp).begin();
  for(i=1;i<=sz2;++i,++ww) {
    num = *ww;
    if(num!=number) _allNumbersThisIteration.push_back(num);
  }
};

MyOstream & UnifierBin::InstanceToOstream(MyOstream & os) const {
   os << "_newNumbers";
   PrintGBListStream(0,_newNumbers,os);
   os << "\n_allNumbersThisIteration";
   PrintGBListStream(0,_allNumbersThisIteration,os);
   os << "\n_pairsForThisIteration";
   const int sz = _pairsForThisIteration.size();
   list<pair<int,int> >::const_iterator w = _pairsForThisIteration.begin();
   for(int i=1;i<=sz;++i,++w) {
     const pair<int,int> & pr = *w;
     os << " ( " << pr.first << ',' << pr.second << " )\n";
   };
   os << '\n';
   return os;
};
#endif
