// GBHistory.h

#ifndef INCLUDED_GBHISTORY_H
#define INCLUDED_GBHISTORY_H

//#pragma warning(disable:4786)
#include "SPIIDSet.hpp"
class SPIID;
class MyOstream;

class GBHistory {
public:
  typedef SPIIDSet HistoryContainerType;

  GBHistory(int a,int b);
  GBHistory(int a,int b,const HistoryContainerType & aList);
  void assign(const SPIID & a,const SPIID & b,const HistoryContainerType & aList);
  GBHistory(const GBHistory &);
  ~GBHistory(){};
  inline void operator = (const GBHistory & x);
  
  bool operator == (const GBHistory & aHistory) const;
  bool operator != (const GBHistory & aHistory) const;

  inline int first() const;
  inline int second() const;
  const HistoryContainerType & reductions() const;
  void setHistory(const HistoryContainerType & aList);
  GBHistory();
private:
  int _first;
  int _second;
  HistoryContainerType _reductions;
};

MyOstream & operator << (MyOstream & os,const GBHistory & aHistory);

inline GBHistory::GBHistory(int a,int b) : _first(a), _second(b), _reductions() {};

inline GBHistory::GBHistory(int a,int b,const HistoryContainerType & aList) 
      : _first(a), _second(b), _reductions(aList) {};

inline void GBHistory::setHistory(const HistoryContainerType & aList) {
  _reductions = aList;
};

inline const GBHistory::HistoryContainerType & GBHistory::reductions() const { 
  return _reductions;
};

inline bool GBHistory::operator == (const GBHistory & aHistory) const {
  bool result = false; 
  if(first() != aHistory.first()) {
    return result;
  } else if(second() != aHistory.second()) {
    return result;
  }
  return (reductions()==aHistory.reductions());
};

inline bool GBHistory::operator != (const GBHistory & aHistory) const { 
  return ! ((*this)==aHistory);
};

inline int GBHistory::first() const {
  return _first;
};

inline int GBHistory::second() const {
  return _second;
};

inline void GBHistory::operator = (const GBHistory & x) { 
  _first = x._first; 
  _second = x._second;
  _reductions = x._reductions; 
};

inline GBHistory::GBHistory(const GBHistory & x) : 
   _first(x._first), _second(x._second), _reductions(x._reductions) {};
#endif
