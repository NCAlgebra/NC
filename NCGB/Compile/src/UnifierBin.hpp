//  UnifierBin.h

#ifndef INCLUDED_UNIFIERBIN_H
#define INCLUDED_UNIFIERBIN_H

#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
class FactControl;
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
//#pragma warning(disable:4786)
#ifndef INCLUDED_LIST_H
#define INCLUDED_LIST_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#endif
#include "SizeList.hpp"
#include "vcpp.hpp"

class UnifierBin {
  friend class OKFriend;
  UnifierBin(); 
    // not implemented
  UnifierBin(const UnifierBin &); 
    // not implemented
  void operator=(const UnifierBin &); 
    // not implemented
public:
 explicit UnifierBin(const FactControl & fc);
 ~UnifierBin();

 void addNewNumber(int number);
 bool iterationEmpty() const;
 bool empty() const;
 void fillForNextIteration();
 pair<int,int> nextPair();
 void removeAllNumber(int number);
  
 MyOstream & InstanceToOstream(MyOstream & os) const;

 friend MyOstream & operator << (MyOstream & os,const UnifierBin & Bin)
  { return Bin.InstanceToOstream(os); }
 int size() const;
 void reorder(int n);
 void markDone(int i,int j);
 bool isDoneQ(int i,int j);
private:
  SizeList<pair<int,int> > _pairsForThisIteration;
  GBList<int> _allNumbersThisIteration;
  GBList<int> _newNumbers;
  GBList<GBList<int> > _done;
  bool _reorder;
  const FactControl & _fc;
};
 
inline int UnifierBin::size() const { 
  return _pairsForThisIteration.size();
};

inline void UnifierBin::reorder(int n) { _reorder = n!=0;};

inline UnifierBin::UnifierBin(const FactControl & fc) :
    _pairsForThisIteration(), _allNumbersThisIteration(),
    _newNumbers(), _done(), _reorder(false), _fc(fc){};

inline UnifierBin::~UnifierBin(){};

inline void UnifierBin::addNewNumber(int number) { 
  _newNumbers.insertIfNotMember(number);
};
   
inline bool UnifierBin::iterationEmpty() const { 
  return _pairsForThisIteration.empty();
};

inline bool UnifierBin::empty() const { 
  return iterationEmpty() &&  _newNumbers.size()==0;
};

inline bool UnifierBin::isDoneQ(int i,int j) {
  bool flag = _done.size()>=i;
  if(!flag) {
    GBList<GBList<int> >::const_iterator ww = 
       ((const GBList<GBList<int> > &)_done).begin();
    ww.advance(i-1);
    flag = (*ww).Member(j).first();
  }
  return flag;
};
#endif
#endif
